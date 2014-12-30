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
with Stack_Size;

--****c* Stm32.Led/Stm32.Led
--
--  NAME
--    Stm32.Led -- Package to control the on board leds.
--  COPYRIGHT
--    (c) 2014 by Julien Brette & Julien Romero
--  SYNOPSIS
--    with Stm32.Led;
--  DESCRIPTION
--    Controls the leds on the board.
--  AUTHOR
--    Julien Brette & Julien Romero
--  USES
--    System
--
--*****

package Stm32.Led is
  pragma Elaborate_Body;

--****t* Stm32.Led/Led_Type
--
--  NAME
--    Led_Type -- The led to turn on.
--  USAGE
--    Choose between Led3, Led4, Led5 and Led6.
--
--*****

  type Led_Type is (Led4, Led3, Led5, Led6);
  for Led_Type use (Led4 => 0, Led3 => 1, Led5 => 2, Led6 => 3);

--****f* Stm32.Led/Led_On
--
--  NAME
--    Led_On -- Turn on a Led.
--  SYNOPSIS
--    Led_On(Led);
--  FUNCTION
--    Turn on the given led.
--  INPUTS
--    Led - The led to turn on, of type Led_Type
--  SEE ALSO
--    Led_Type
--
--*****

  procedure Led_On (Led : Led_Type);

--****f* Stm32.Led/Led_Off
--
--  NAME
--    Led_Off -- Turn off a Led.
--  SYNOPSIS
--    Led_Off(Led);
--  FUNCTION
--    Turn off the given led.
--  INPUTS
--    Led - The led to turn off, of type Led_Type
--  SEE ALSO
--    Led_Type
--
--*****

  procedure Led_Off (Led : Led_Type);

--****f* Stm32.Led/Led_Toggle
--
--  NAME
--    Led_Toggle -- Toggle a led.
--  SYNOPSIS
--    Led_Toggle(Led);
--  FUNCTION
--    Toggle the given led.
--  INPUTS
--    Led - The led to toggle, of type Led_Type
--  SEE ALSO
--    Led_Type
--
--*****

  procedure Led_Toggle (Led : Led_Type);

--****t* Stm32.Led/Led_Toggler
--
--  NAME
--    Led_Toggler -- Makes a led toggle at a given frequency.
--  SYNOPSIS
--    Toggler : Led_Toggler(Led, Freq, Priority);
--  FUNCTION
--    A task that makes the given led toggle at the given frequency.
--  INPUTS
--    Led      - The led to toggle, of type Led_Type
--    Freq     - An integer representing the frequency.
--    Priority - The priority of the task, of type System.Any_Priority.
--  SEE ALSO
--    Led_Type, System.Any_Priority
--
--*****

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
