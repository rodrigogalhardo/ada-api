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

with Hw.Button;
with Logging;
with Config;
with Util; use Util;

package body Hw.Digital_Servo_High is

  Buffered : Boolean := False;

  ------------
  -- Ax_Log --
  ------------

  procedure Ax_Log (S : String) is
  begin
    if Config.Debug_Ax12 /= Disable then
      Logging.Log (S);
    end if;
  end Ax_Log;
  pragma Inline (Ax_Log);

  ------------------
  -- Set_Buffered --
  ------------------

  procedure Set_Buffered (Value : Boolean) is
  begin
    Buffered := Value;
  end Set_Buffered;

  -------------
  -- Execute --
  -------------

  procedure Execute is
  begin
    if Buffered then
      Send_Command_No_Result (Broadcast, 5, Empty_Arg);
    end if;
  end Execute;

  -------------
  -- Get_Reg --
  -------------

  function Get_Reg(Servo : Digital_Servo_Type;
                   Reg : Unsigned_8) return Unsigned_8 is
    Reply : Servo_Reply;
  begin
    if Servo = Broadcast then
      return 0;
    end if;
    Reply := Send_Command (Servo, 2, (Reg, 1));
    if Reply.Error /= 0 then
      Ax_Log ("Unable to read red " & To_Hex (Reg) & " from " &
              To_Hex (Servo) & "; " & To_Hex (Reply.Error) &
              " Result: " & To_Hex (Reply.Params (0)));
      return 0;
    end if;
    return  Reply.Params(0);
  end Get_Reg;

  -------------
  -- Set_Reg --
  -------------

  procedure Set_Reg(Servo : Digital_Servo_Type;
                    Reg : Unsigned_8; Val : Unsigned_8) is
    Cmd : Unsigned_8 := 3;
    Reply : Servo_Reply;
  begin
    if Buffered then
      Cmd := 4;
    end if;
    Reply := Send_Command (Servo, Cmd, (Reg, Val));
    if Reply.Error /= 0 then
      Ax_Log ("Unable to set reg " & To_Hex (Reg) & " of " &
              To_Hex (Servo) & ": " & To_Hex (Reply.Error));
    end if;
  end Set_Reg;

  ---------------
  -- Get_Reg16 --
  ---------------

  function Get_Reg16(Servo : Digital_Servo_Type;
                     Reg : Unsigned_8) return Unsigned_16 is
    Reply : Servo_Reply;
  begin
    if Servo = Broadcast then
      return 0;
    end if;
    Reply := Send_Command (Servo, 2, (Reg, 2));
    if Reply.Error /= 0 then
      Ax_Log ("Unable to read reg " & To_Hex (Reg) & " from " &
              To_Hex (Servo) & ": " & To_Hex (Reply.Error));
      return 0;
    end if;
    return  Unsigned_16 (Reply.Params(0)) + Unsigned_16 (Reply.Params(1)) * 256;
  end Get_Reg16;

  ---------------
  -- Set_Reg16 --
  ---------------

  procedure Set_Reg16(Servo : Digital_Servo_Type;
                      Reg : Unsigned_8; Val : Unsigned_16) is
    Cmd : Unsigned_8 := 3;
    Reply : Servo_Reply;
  begin
    if Hw.Button.Red_Button then
      Ax_Log ("Red button!");
      return;
    end if;
    if Buffered then
      Cmd := 4;
    end if;
    Reply := Send_Command (
        Servo, Cmd, (Reg, Unsigned_8 (Val mod 256), Unsigned_8 (Val / 256)));
    if Reply.Error /= 0 then
      Ax_Log ("Unable to set reg " & To_Hex (Reg) & " of " &
              To_Hex (Servo) & ": " & To_Hex (Reply.Error));
    end if;
  end Set_Reg16;

  procedure Reset (Servo : Digital_Servo_Type) is
    Reply : Servo_Reply;
  begin
    Reply := Send_Command (Servo, 6, Empty_Arg);
    if Reply.Error /= 0 then
      Ax_Log ("Unable to reset " & To_Hex (Servo) & ": "
              & To_Hex (Reply.Error));
    end if;
  end Reset;

end Hw.Digital_Servo_High;
