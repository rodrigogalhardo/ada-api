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

--****c* Stm32.USB/Stm32.USB
--
--  NAME
--    Stm32.USB -- Manages USB communications.
--  COPYRIGHT
--    (c) 2014 by Julien Brette & Julien Romero
--  SYNOPSIS
--    with Stm32.USB;
--  DESCRIPTION
--    Manages USB communications. When included, the usb is initialize and ready
--to be used.
--  AUTHOR
--    Julien Brette & Julien Romero
--
--*****

package Stm32.USB is

--****f* Stm32.USB/Read
--
--  NAME
--    Read -- Read a caracter on the usb.
--  SYNOPSIS
--    C := Read;
--  FUNCTION
--    Read a caracter on the usb.
--  RESULT
--    C - The read caracter, of type Character.
--
--*****

  function Read return Character;

--****f* Stm32.USB/Send
--
--  NAME
--    Send -- Sends a string on the usb.
--  SYNOPSIS
--    Send(S);
--  FUNCTION
--    Sends a string on the usb.
--  INPUTS
--    S - The string to send, of type String.
--
--*****

  procedure Send (S : String);
end Stm32.USB;
