--------------------------------------------------------------------------------
--
--Copyright 2014 - Julien Romero
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
with Stm32.Led; use Stm32.Led;

procedure Example is
begin
  loop
--Turn on the pin, wait a bit, turn off the pin, wait a bit
    Led_On(Led3);
    Led_On(Led4);
    Led_On(Led5);
    Led_On(Led6);
    delay until Clock + To_Time_Span (1.0);
    Led_Off(Led3);
    Led_Off(Led4);
    Led_Off(Led5);
    Led_Off(Led6);
    delay until Clock + To_Time_Span (1.0);
  end loop;
end Example;
