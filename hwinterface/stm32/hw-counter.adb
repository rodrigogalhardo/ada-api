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

with Common.Types; use Common.Types;
with Config.Hw_Config;
with Hw.Hw_Config; use Hw.Hw_Config;
with Hw.Counter_Simu;
with Hw.Led;
with Stm32.Timer; use Stm32.Timer;
pragma Elaborate_All (Stm32.Timer);
with Config;

package body Hw.Counter is

  Polarity : constant array (Encoder_Direction_Type) of ICPolarity_Type :=
    (Up => Rising,
     Down => Falling);

  type Raw_Counter_Type is record
    Raw_Left : Unsigned_16;
    Raw_Right : Unsigned_16;
    Pliers : Unsigned_16;
  end record;

  type Counter_Queue_Type is array (1 .. 10) of Raw_Counter_Type;

  protected Counter_Queue is
    procedure Timer_Counter_Handler;
    pragma Attach_Handler (Timer_Counter_Handler, IRQ_Timer (Timer_Counter));
    entry Wait (Counters : out Raw_Counter_Type);
  private
    Queue : Counter_Queue_Type;
    Read : Integer := 1;
    Write : Integer := 1;
    Not_Empty : Boolean := False;
  end Counter_Queue;

  -------------------
  -- Counter_Queue --
  -------------------

  protected body Counter_Queue is
    -----------------------------------------
    -- Counter_Queue.Timer_Counter_Handler --
    -----------------------------------------

    procedure Timer_Counter_Handler is
      Counters : Raw_Counter_Type :=
          (Unsigned_16 (Get_Counter (
               Timer_Wheel (Config.Hw_Config.Left_Wheel_Number).Timer)),
           Unsigned_16 (Get_Counter (
               Timer_Wheel (1 - Config.Hw_Config.Left_Wheel_Number).Timer)),
           Unsigned_16 (Get_Counter (Timer_Pliers.Timer)));
    begin
      if Config.Engines_Simu /= 0 then
        Hw.Counter_Simu.Get_Next_Counters (
            Counters.Raw_Left, Counters.Raw_Right);
      end if;
      Queue (Write) := Counters;
      Write := Write + 1;
      if Write > Queue'Last then
        Write := Queue'First;
      end if;
      Not_Empty := Read /= Write;
      if Read = Write then
        -- Overflow
        -- Note that we cannot use the Leds module that uses a protected.
        Hw.Led.Led_On (Error);
      end if;
      Clear_Interrupt (Timer_Counter, Update);
    end Timer_Counter_Handler;

    ------------------------
    -- Counter_Queue.Wait --
    ------------------------

    entry Wait (Counters : out Raw_Counter_Type) when Not_Empty is
    begin
      Counters := Queue (Read);
      Read := Read + 1;
      if Read > Queue'Last then
        Read := Queue'First;
      end if;
      Not_Empty := Read /= Write;
    end Wait;
  end Counter_Queue;

  -------------------------
  -- Setup_Counter_Timer --
  -------------------------

  procedure Setup_Counter_Timer is
    Params : constant Timer_Params :=
      (Prescaler => 4 - 1,
       Counter_Mode => Up,
       Period => (Hw.Hw_Config.Timer_Counter_Period + 1)/4 - 1,
       Clock_Division => Div_1,
       Repetition_Counter => 0);
  begin
    Reset_Timer (Timer_Counter);
    Clear_Interrupt (Timer_Counter, Update);
    Init_Timer (Timer_Counter, Params, Update, Timer_Counter_Priority);
  end Setup_Counter_Timer;

  -------------------
  -- Setup_Encoder --
  -------------------

  procedure Setup_Encoder (Dir : Encoder_Direction_Type;
                           Timer : Wheel_Counter_Type) is
    Params : constant Timer_Params :=
      (Prescaler => 0,
       Counter_Mode => Up,
       Period => Unsigned_32'Last,
       Clock_Division => Div_1,
       Repetition_Counter => 0);
    P : constant ICPolarity_Type := Polarity (Dir);
  begin
    Reset_Timer (Timer.Timer);
    Configure_Encoder_Pins (Timer.Timer, Timer.Pin1, Timer.Pin2);
    Setup_Encoder (Timer.Timer, TI12, Rising, P);
    Init_Timer (Timer.Timer, Params, Disable, 0);
  end Setup_Encoder;

  ----------------------
  -- PUBLIC FUNCTIONS --
  ----------------------

  --------------------
  -- Setup_Counters --
  --------------------

  procedure Setup_Counters is
  begin
    Setup_Counter_Timer;
    Setup_Encoder (Config.Hw_Config.Right_Encoder_Direction,
                   Timer_Wheel (1 - Config.Hw_Config.Left_Wheel_Number));
    Setup_Encoder (Config.Hw_Config.Left_Encoder_Direction,
                   Timer_Wheel (Config.Hw_Config.Left_Wheel_Number));
    Setup_Encoder (Config.Hw_Config.Pliers_Encoder_Direction,
                   Timer_Pliers);
  end Setup_Counters;

  -----------------------
  -- Get_Next_Counters --
  -----------------------
  procedure Get_Next_Counters (Raw_Left : out Unsigned_16;
                               Raw_Right : out Unsigned_16;
                               Pliers : out Unsigned_16) is
    Counters : Raw_Counter_Type;
  begin
    Counter_Queue.Wait (Counters);
    Raw_Left := Counters.Raw_Left;
    Raw_Right := Counters.Raw_Right;
    Pliers := Counters.Pliers;
  end Get_Next_Counters;
end Hw.Counter;
