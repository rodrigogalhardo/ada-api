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
with Config.Hw_Config; use Config.Hw_Config;
with Hw.Button;
with Hw.Counter; use Hw.Counter;
with Hw.Hw_Config; use Hw.Hw_Config;
with Stm32.GPIO; use Stm32.GPIO;
pragma Elaborate_All (Stm32.GPIO);
with Stm32.Timer; use Stm32.Timer;
pragma Elaborate_All (Stm32.Timer);

package body Hw.PWM is

  Current_Cmd : array (Engine_Kind, Side_Type) of Integer_32 :=
      (others => (others => 0));

  type Override_Values_Type is array (Side_Type) of Integer_32;
  type Override_Type is record
    Enabled : Boolean;
    Values : Override_Values_Type;
  end record;
  Override : array (Engine_Kind) of Override_Type :=
    (others => (Enabled => False, Values => (others => 0)));

  -----------------------
  -- PRIVATE FUNCTIONS --
  -----------------------

  --------------------
  -- Setup_Hardware --
  --------------------

  procedure Setup_Hardware (Config : Engines_Config_Type) is
    Params : constant Timer_Params :=
      (Prescaler => Config.Timer_Prescaler,
       Counter_Mode => Up,
       Period => Config.Timer_Period,
       Clock_Division => Div_1,
       Repetition_Counter => 0);
    Output_Params : Output_Channel_Params;
  begin
    Output_Params.Mode := PWM1;
    Output_Params.Output_State := Enable;

    Setup_Out_Pin (Config.Left_Config.In_A);
    Setup_Out_Pin (Config.Left_Config.In_B);
    Setup_Out_Pin (Config.Right_Config.In_A);
    Setup_Out_Pin (Config.Right_Config.In_B);

    Reset_Timer (Config.Timer);
    Configure_Output_Pin (Config.Timer, Config.Left_Config.Pin);
    Configure_Output_Pin (Config.Timer, Config.Right_Config.Pin);
    Setup_Output_Channel (
        Config.Timer, Config.Left_Config.Channel, Output_Params);
    Setup_Output_Channel (
        Config.Timer, Config.Right_Config.Channel, Output_Params);

    Init_Timer (Config.Timer, Params, Disable, 0);
  end Setup_Hardware;

  procedure Setup_Hardware is
  begin
    for I in Engine_Kind loop
      Setup_Hardware (PWM_Config (I));
    end loop;
  end Setup_Hardware;

  -------------------
  -- Apply_Command --
  -------------------

  procedure Apply_Command (Kind : Engine_Kind;
                           Cmd_Left : Integer_32;
                           Cmd_Right : Integer_32) is
    Dir_Left : constant Boolean :=
      Cmd_Left < 0 xor Engine_Direction (Kind, Left) = Up;
    Dir_Right : constant Boolean :=
      Cmd_Right < 0 xor Engine_Direction (Kind, Right) = Up;
  begin
    Set_Pin (PWM_Config (Kind).Left_Config.In_A, Dir_Left);
    Set_Pin (PWM_Config (Kind).Left_Config.In_B, not Dir_Left);
    Set_Compare (PWM_Config (Kind).Timer,
                 PWM_Config (Kind).Left_Config.Channel,
                 Unsigned_32 (abs (Cmd_Left)));

    Set_Pin (PWM_Config (Kind).Right_Config.In_A, Dir_Right);
    Set_Pin (PWM_Config (Kind).Right_Config.In_B, not Dir_Right);
    Set_Compare (PWM_Config (Kind).Timer,
                 PWM_Config (Kind).Right_Config.Channel,
                 Unsigned_32 (abs (Cmd_Right)));
  end Apply_Command;

  -------------------------
  -- Set_Engine_Commands --
  -------------------------

  procedure Set_Engine_Commands (Kind : Engine_Kind;
                                 Cmd_Left : Integer_32;
                                 Cmd_Right : Integer_32) is
  begin
    Current_Cmd (Kind, Left) := Cmd_Left;
    Current_Cmd (Kind, Right) := Cmd_Right;
    if Hw.Button.Red_Button then
      -- No command
      Set_Pin (PWM_Config (Kind).Left_Config.In_A, True);
      Set_Pin (PWM_Config (Kind).Left_Config.In_B, True);
      Set_Compare (PWM_Config (Kind).Timer,
                   PWM_Config (Kind).Left_Config.Channel, 0);

      Set_Pin (PWM_Config (Kind).Right_Config.In_A, True);
      Set_Pin (PWM_Config (Kind).Right_Config.In_B, True);
      Set_Compare (PWM_Config (Kind).Timer,
                   PWM_Config (Kind).Right_Config.Channel, 0);
    elsif Override (Kind).Enabled then
      Apply_Command (Kind, Override (Kind).Values (Left),
                     Override (Kind).Values (Right));
    else
      Apply_Command (Kind, Cmd_Left, Cmd_Right);
    end if;
  end Set_Engine_Commands;

  ----------------------
  -- PUBLIC FUNCTIONS --
  ----------------------

  -------------------------
  -- Set_Engine_Commands --
  -------------------------

  procedure Set_Engine_Commands (Cmd_Left : Integer_32;
                                 Cmd_Right : Integer_32) is
  begin
    Set_Engine_Commands (Primary, Cmd_Left, Cmd_Right);
  end Set_Engine_Commands;

  ----------------------------
  -- Set_Secondary_Commands --
  ----------------------------

  procedure Set_Secondary_Commands (Cmd_Left : Integer_32;
                                    Cmd_Right : Integer_32) is
  begin
    Set_Engine_Commands (Secondary, Cmd_Left, Cmd_Right);
  end Set_Secondary_Commands;

  -------------------------
  -- Get_Engine_Commands --
  -------------------------

  procedure Get_Engine_Commands (Cmd_Left : out Integer_32;
                                 Cmd_Right : out Integer_32) is
  begin
    Cmd_Left := Current_Cmd (Primary, Left);
    Cmd_Right := Current_Cmd (Primary, Right);
  end Get_Engine_Commands;

  ----------------------------
  -- Get_Secondary_Commands --
  ----------------------------

  procedure Get_Secondary_Commands (Cmd_Left : out Integer_32;
                                    Cmd_Right : out Integer_32) is
  begin
    Cmd_Left := Current_Cmd (Secondary, Left);
    Cmd_Right := Current_Cmd (Secondary, Right);
  end Get_Secondary_Commands;

  -------------------------
  -- Set_Engine_Override --
  -------------------------

  procedure Set_Engine_Override (Cmd_Left : Integer_32;
                                 Cmd_Right : Integer_32) is
  begin
    Override (Primary).Values (Left) := Cmd_Left;
    Override (Primary).Values (Right) := Cmd_Right;
    Override (Primary).Enabled := True;
  end Set_Engine_Override;

  ----------------------------
  -- Set_Secondary_Override --
  ----------------------------

  procedure Set_Secondary_Override (Cmd_Left : Integer_32;
                                    Cmd_Right : Integer_32) is
  begin
    Override (Secondary).Values (Left) := Cmd_Left;
    Override (Secondary).Values (Right) := Cmd_Right;
    Override (Secondary).Enabled := True;
  end Set_Secondary_Override;

  --------------------
  -- Reset_Override --
  --------------------

  procedure Reset_Override is
  begin
    Override (Primary).Enabled := False;
  end Reset_Override;

  ------------------------------
  -- Reset_Secondary_Override --
  ------------------------------

  procedure Reset_Secondary_Override is
  begin
    Override (Secondary).Enabled := False;
  end Reset_Secondary_Override;

  procedure Turn_Off is
  begin
    Setup_In_Pin (PWM_Config (Primary).Left_Config.Pin);
    Setup_In_Pin (PWM_Config (Primary).Right_Config.Pin);
    Setup_In_Pin (PWM_Config (Primary).Left_Config.In_A);
    Setup_In_Pin (PWM_Config (Primary).Left_Config.In_B);
    Setup_In_Pin (PWM_Config (Primary).Right_Config.In_A);
    Setup_In_Pin (PWM_Config (Primary).Right_Config.In_B);
  end Turn_Off;
begin
  Setup_Hardware;
end Hw.PWM;
