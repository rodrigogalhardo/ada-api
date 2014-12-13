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

with Ada.Real_Time; use Ada.Real_Time;
with Ada.Unchecked_Conversion;
with Hw.Counter_Simu;
with Hw.PWM;
with Config;

package body Hw.Counter is

  Prescaler : Integer := 0;

  Pliers_Counter : Unsigned_16 := 0;

  --------------------
  -- Setup_Counters --
  --------------------

  procedure Setup_Counters is
  begin
    null;
  end Setup_Counters;

  -----------------------
  -- Get_Next_Counters --
  -----------------------

  procedure Get_Next_Counters (Raw_Left : out Unsigned_16;
                               Raw_Right : out Unsigned_16;
                               Pliers : out Unsigned_16) is
    Next_Time : Time := Clock;
    Cmd_Left : Integer_32;
    Cmd_Right : Integer_32;

    function To_Unsigned is
        new Ada.Unchecked_Conversion (Source => Integer_16,
                                      Target => Unsigned_16);
  begin
    Prescaler := Prescaler + 1;
    if Prescaler > Config.Asserv_Prescaler then
      Prescaler := 0;
      Next_Time := Next_Time + To_Time_Span (
          Duration (Config.Asserv_Prescaler) / Duration (Config.Counter_Freq));
      delay until Next_Time;
    end if;
    Hw.Counter_Simu.Get_Next_Counters (Raw_Left, Raw_Right);

    Hw.PWM.Get_Secondary_Commands (Cmd_Left, Cmd_Right);
    Pliers_Counter := Pliers_Counter + To_Unsigned (Integer_16 (Cmd_Left));
    Pliers := Pliers_Counter;
  end Get_Next_Counters;

end Hw.Counter;
