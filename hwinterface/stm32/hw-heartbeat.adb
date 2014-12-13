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
with Common.Types;
with Interfaces; use Interfaces;
with Leds;
with Stack_Size;

package body Hw.Heartbeat is

  task Counter_Task is
    pragma Priority (1);
    pragma Storage_Size (2 * Stack_Size.Default_Stack_Size);
  end Counter_Task;

  task Heartbeat_Task is
    pragma Priority (3);
    pragma Storage_Size (2 * Stack_Size.Default_Stack_Size);
  end Heartbeat_Task;

  Counter : Unsigned_32 := 0;
  pragma Atomic (Counter);
  pragma Volatile (Counter);

--  Max_Delta : Float := 0.0;
  Max_Delta : constant := 15000000.0;

  procedure Pulse is
  begin
    Leds.Led_Toggle (Common.Types.Heartbeat);
  end Pulse;

  ------------------
  -- Counter_Task --
  ------------------

  task body Counter_Task is
    Prescaled : Unsigned_32 := 0;
  begin
    loop
      Prescaled := Prescaled + 1;
      if Prescaled > 1000 then
        Prescaled := 0;
        Counter := Counter + 1;
      end if;
    end loop;
  end Counter_Task;

  --------------------
  -- Heartbeat_Task --
  --------------------

  task body Heartbeat_Task is
    Max_Period : constant Float := 1.0;
    Old_Counter : Unsigned_32;
    Old_Time : Time;
    Cur_Counter : Unsigned_32;
    Cur_Time : Time;
    Cur : Float;
    Wait_Time : Time_Span := To_Time_Span (Duration (3.0 * Max_Period / 4.0));
    Ratio : Float;
    Tmp : Float;
  begin
    loop
      begin
        Old_Counter := Counter;
        Old_Time := Clock;
        Pulse;
        delay until Clock + To_Time_Span (Duration (Max_Period / 4.0));
        Pulse;
        delay until Clock + Wait_Time;
        Cur_Counter := Counter;
        Cur_Time := Clock;
        Cur := Float (Cur_Counter - Old_Counter) /
            Float (To_Duration (Cur_Time - Old_Time));
        if Cur > Max_Delta then
--          Max_Delta := Cur;
          Cur := Max_Delta;
        end if;
        Ratio := Cur / Max_Delta;
        Tmp := Max_Period * 3.0 * Ratio / 4.0;
        Wait_Time := Microseconds (Integer (Tmp * 1000000.0));
      exception
        when others =>
          null;
      end;
    end loop;
  end Heartbeat_Task;
end Hw.Heartbeat;
