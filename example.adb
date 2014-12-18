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
with Stm32.GPIO; use Stm32.GPIO;
with Stm32.RCC; use Stm32.RCC;
pragma Elaborate_All (Stm32.GPIO);

procedure Example is
--Define the Pin
  Pin : constant Pin_Type := (GPIOD, 12);
begin
--Configure the pin as an output pin.
   Setup_Out_Pin(Pin);
  loop
--Turn on the pin, wait a bit, turn off the pin, wait a bit
    Set_Pin(Pin,True);
    delay until Clock + To_Time_Span (1.0);
    Set_Pin(Pin,False);
    delay until Clock + To_Time_Span (1.0);
  end loop;
end Example;
