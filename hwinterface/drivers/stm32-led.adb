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

package body Stm32.Led is
  procedure Led_Init (Led : Led_Type);
  pragma Import (C, Led_Init, "STM_EVAL_LEDInit");

  -----------------
  -- Led_Toggler --
  -----------------

  task body Led_Toggler is
    Time_Wait : constant Time_Span := To_Time_Span (0.5 / Duration (Freq));
  begin
    loop
      Led_Toggle (Led);
      delay until Clock + Time_Wait;
    end loop;
  end Led_Toggler;

begin
  for I in Led_Type'Range loop
    Led_Init (I);
  end loop;
end Stm32.Led;
