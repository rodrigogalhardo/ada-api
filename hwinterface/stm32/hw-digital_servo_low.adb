--------------------------------------------------------------------------------
--
--Copyright 2014 - Julien Brette
--
--This program is free software: you can redistribute it and/or modify
--it under the terms of the GNU General Public License as published by
--the Free Software Foundation, either version 3 of the License, or
--(at your option) any later version.
--
--This program is distributed in the hope that it will be useful,
--but WITHOUT ANY WARRANTY; without even the implied warranty of
--MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--GNU General Public License for more details.
--
--You should have received a copy of the GNU General Public License
--along with this program.  If not, see <http://www.gnu.org/licenses/>.
--
--------------------------------------------------------------------------------

with Ada.Real_Time; use Ada.Real_Time;
--with Hw.Led;
with Hw.UART; use Hw.UART;
pragma Elaborate_All (Hw.UART);

with Logging;
with Util; use Util;


package body Hw.Digital_Servo_Low is

  protected type Mutex_Type is
    entry Lock;
    procedure Unlock;
  private
    Free : Boolean := True;
  end Mutex_Type;

  Serial : constant array (Bus_Type) of UART_Line :=
    (Bus_1 => Ax_1);
  Mutex : array (Bus_Type) of Mutex_Type;

  Retry_Number : Integer := 5;

  ----------------
  -- Mutex_Type --
  ----------------

  protected body Mutex_Type is
    ---------------------
    -- Mutex_Type.Lock --
    ---------------------

    entry Lock when Free is
    begin
      Free := False;
    end Lock;

    -----------------------
    -- Mutex_Type.Unlock --
    -----------------------

    procedure Unlock is
    begin
      Free := True;
    end Unlock;
  end Mutex_Type;

  ------------------
  -- Send_Command --
  ------------------

  procedure Send_Command (Bus : Bus_Type;
                          Id : Digital_Servo_Type;
                          Params : Params_Type;
                          R : out Servo_Reply) is
    Data : String (1 .. Params'Length + 5);
    Reply : Params_Max_Type;
    Length : Integer;
    Checksum : Unsigned_8 := 0;
    C : Character;
    Timeout : Boolean;
  begin
    -- We need something to be sure to wait for the reply before allowing
    -- someone else to send something one the bus.
    -- We cannot use a protected since we want to call UART.Send which is
    -- a blocking operation. That's why we use a simple mutex here.
    Mutex (Bus).Lock;
    Data (1) := Character'Val (16#FF#);
    Data (2) := Character'Val (16#FF#);
    Data (3) := Character'Val (Id);
    Data (4) := Character'Val (Params'Length + 1);
    for I in Params'Range loop
      Data (5 + I - Params'First) := Character'Val (Params (I));
    end loop;

    -- Checksum
    for I in Data'First + 2 .. Data'Last - 1 loop
      Checksum := Checksum + Unsigned_8 (Character'Pos (Data (I)));
    end loop;
    Checksum := not Checksum;
    Data (Data'Last) := Character'Val (Checksum);

    Hw.UART.Flush (Serial (Bus));
    Hw.UART.Send (Serial (Bus), Data);

    for I in 0 .. Data'Length - 1 loop
      Hw.UART.Wait (Serial (Bus), C, Timeout);
      if Timeout then
        R := (Error => 255, Length => 0, Params => (others => 0));
        Mutex (Bus).Unlock;
        return;
      end if;
      if Data(I + Data'First) /= C then
--        Hw.Led.Led_On (Hw.Led.Error);
        Logging.Log ("Error reading " & To_Hex (Unsigned_8 (Character'Pos (Data (I + Data'First)))) &
            "; got " & To_Hex (Unsigned_8 (Character'Pos (C))) & " at " & To_Hex (Unsigned_8 (I)) &
            " of " & To_Hex (Unsigned_8 (Data'Length - 1)));
        R := (Error => 254, Length => 0, Params => (others => 0));
        Mutex (Bus).Unlock;
        return;
      end if;
      Reply (I) := Character'Pos (C);
    end loop;

    if Id = Broadcast then
      -- Don't read reply
      R := (Error => 0, Length => 0, Params => (others => 0));
      Mutex (Bus).Unlock;
      return;
    end if;

    for I in 0 .. 4 loop
      Hw.UART.Wait (Serial (Bus), C, Timeout);
      if Timeout then
        R := (Error => 253, Length => 0, Params => (others => 0));
        Mutex (Bus).Unlock;
        return;
      end if;
      Reply (I) := Character'Pos (C);
    end loop;
    if Reply(0) /= 255 or Reply(1) /= 255 then
--      Hw.Led.Led_On (Hw.Led.Error);
      R := (Error => 252, Length => 0, Params => (others => 0));
        Mutex (Bus).Unlock;
      return;
    end if;

    Checksum := Reply (2) + Reply(3) + Reply(4);
    Length := Integer (Reply (3));
    R.Error := Reply (4);
    R.Length := Reply (3);
    if Length > R.Params'Length or Length < 2 then
      R := (Error => 251, Length => 0, Params => (others => 0));
      Mutex (Bus).Unlock;
      return;
    end if;

    for I in 0 .. Length - 2 loop
      Hw.UART.Wait (Serial (Bus), C, Timeout);
      if Timeout then
        R := (Error => 250, Length => 0, Params => (others => 0));
        Mutex (Bus).Unlock;
        return;
      end if;
      R.Params (I) := Character'Pos (C);
      Checksum := Checksum + R.Params (I);
    end loop;
    Checksum := not (Checksum - R.Params (Length - 2));
    if Checksum /= R.Params (Length - 2) then
--      Hw.Led.Led_On (Hw.Led.Error);
      R := (Error => 249, Length => 0, Params => (others => 0));
    end if;
    Mutex (Bus).Unlock;
  end Send_Command;

  ------------------
  -- Send_Command --
  ------------------

  function Send_Command_Loop (Bus : Bus_Type;
                              Id : Digital_Servo_Type;
                              Params : Params_Type) return Servo_Reply is
    Reply : Servo_Reply := (Error => 0, Length => 0, Params => (others => 0));
    Num_Error : Integer := 0;
    Done : Boolean := False;
  begin
    while not Done loop
      Send_Command (Bus, Id, Params, Reply);
      Done := True;
      if Reply.Error = 0 then
        Done := True;
      else
        if Reply.Error < 127 then
          -- If this is really a servo error,
          -- send the command the re-enable the torque.
          if (Reply.Error and 32) /= 0 then
            Logging.Log ("About to reset " & To_Hex (Id));
            Send_Command (Bus, Id, (3, 34, 255, 3), Reply);
          end if;
          Send_Command (Bus, Id, (3, 16#18#, 1), Reply);
        end if;
--        Hw.Led.Led_On (Hw.Led.Error);
        Num_Error := Num_Error + 1;
        if Num_Error > Retry_Number then
          return Reply;
        end if;
        -- Wait a little bit to flush the serial port
        delay until Clock + To_Time_Span (0.01);
      end if;
    end loop;
    return Reply;
  end Send_Command_Loop;

  ----------------------
  -- PUBLIC FUNCTIONS --
  ----------------------

  ----------------------
  -- Set_Retry_Number --
  ----------------------

  procedure Set_Retry_Number (Number : Integer) is
  begin
    Retry_Number := Number;
  end Set_Retry_Number;

  ------------------
  -- Send_Command --
  ------------------

  function Send_Command (Servo : Digital_Servo_Type;
                         Cmd : Unsigned_8;
                         Params: Params_Type) return Servo_Reply is
    Bus : constant Bus_Type := Bus_1;
    P   : constant Params_Type := (Cmd) & Params;
  begin
    return Send_Command_Loop (Bus, Servo, P);
  end Send_Command;

  ----------------------------
  -- Send_Command_No_Result --
  ----------------------------

  procedure Send_Command_No_Result (Servo : Digital_Servo_Type;
                                    Cmd : Unsigned_8;
                                    Params : Params_Type) is
    Reply : constant Servo_Reply := Send_Command (Servo, Cmd, Params);
    pragma Warnings (Off, Reply);
  begin
    null;
  end Send_Command_No_Result;

end Hw.Digital_Servo_Low;
