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

with Interfaces; use Interfaces;

package Hw.PWM is
  procedure Set_Engine_Commands (Cmd_Left : Integer_32;
                                 Cmd_Right : Integer_32);

  procedure Set_Secondary_Commands (Cmd_Left : Integer_32;
                                    Cmd_Right : Integer_32);

  procedure Get_Engine_Commands (Cmd_Left : out Integer_32;
                                 Cmd_Right : out Integer_32);

  procedure Get_Secondary_Commands (Cmd_Left : out Integer_32;
                                    Cmd_Right : out Integer_32);

  procedure Set_Engine_Override (Cmd_Left : Integer_32;
                                 Cmd_Right : Integer_32);

  procedure Set_Secondary_Override (Cmd_Left : Integer_32;
                                    Cmd_Right : Integer_32);

  procedure Reset_Override;

  procedure Reset_Secondary_Override;

  procedure Turn_Off;

end Hw.PWM;
