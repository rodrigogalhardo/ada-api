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

package body Hw.PWM is

  Current_Cmd_Left : Integer_32 := 0;
  Current_Cmd_Right : Integer_32 := 0;

  Current_Secondary_Left : Integer_32 := 0;
  Current_Secondary_Right : Integer_32 := 0;

  -------------------------
  -- Set_Engine_Commands --
  -------------------------

  procedure Set_Engine_Commands (Cmd_Left : Integer_32;
                                 Cmd_Right : Integer_32) is
  begin
    Current_Cmd_Left := Cmd_Left;
    Current_Cmd_Right := Cmd_Right;
  end Set_Engine_Commands;

  ----------------------------
  -- Set_Secondary_Commands --
  ----------------------------

  procedure Set_Secondary_Commands (Cmd_Left : Integer_32;
                                    Cmd_Right : Integer_32) is
  begin
    Current_Secondary_Left := Cmd_Left;
    Current_Secondary_Right := Cmd_Right;
  end Set_Secondary_Commands;

  -------------------------
  -- Get_Engine_Commands --
  -------------------------

  procedure Get_Engine_Commands (Cmd_Left : out Integer_32;
                                 Cmd_Right : out Integer_32) is
  begin
    Cmd_Left := Current_Cmd_Left;
    Cmd_Right := Current_Cmd_Right;
  end Get_Engine_Commands;

  ----------------------------
  -- Get_Secondary_Commands --
  ----------------------------

  procedure Get_Secondary_Commands (Cmd_Left : out Integer_32;
                                    Cmd_Right : out Integer_32) is
  begin
    Cmd_Left := Current_Secondary_Left;
    Cmd_Right := Current_Secondary_Right;
  end Get_Secondary_Commands;

  -------------------------
  -- Set_Engine_Override --
  -------------------------

  procedure Set_Engine_Override (Cmd_Left : Integer_32;
                                 Cmd_Right : Integer_32) is
    pragma Unreferenced (Cmd_Left);
    pragma Unreferenced (Cmd_Right);
  begin
    null;
  end Set_Engine_Override;

  -------------------------
  -- Set_Secondary_Override --
  -------------------------

  procedure Set_Secondary_Override (Cmd_Left : Integer_32;
                                    Cmd_Right : Integer_32) is
    pragma Unreferenced (Cmd_Left);
    pragma Unreferenced (Cmd_Right);
  begin
    null;
  end Set_Secondary_Override;

  --------------------
  -- Reset_Override --
  --------------------

  procedure Reset_Override is
  begin
    null;
  end Reset_Override;

  ------------------------------
  -- Reset_Secondary_Override --
  ------------------------------

  procedure Reset_Secondary_Override is
  begin
    null;
  end Reset_Secondary_Override;

  procedure Turn_Off is
  begin
    null;
  end Turn_Off;

end Hw.PWM;
