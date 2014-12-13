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

with System;

package Stm32.Led is
  pragma Elaborate_Body;

  type Led_Type is (Led4, Led3, Led5, Led6);
  for Led_Type use (Led4 => 0, Led3 => 1, Led5 => 2, Led6 => 3);

  procedure Led_On (Led : Led_Type);
  procedure Led_Off (Led : Led_Type);
  procedure Led_Toggle (Led : Led_Type);

  task type Led_Toggler (Led : Led_Type; Freq : Integer;
                         Priority : System.Any_Priority) is
    pragma Priority (Priority);
    pragma Storage_Size (4 * Stack_Size.Default_Stack_Size);
  end Led_Toggler;

private

  pragma Import (C, Led_On, "STM_EVAL_LEDOn");
  pragma Import (C, Led_Off, "STM_EVAL_LEDOff");
  pragma Import (C, Led_Toggle, "STM_EVAL_LEDToggle");
end Stm32.Led;
