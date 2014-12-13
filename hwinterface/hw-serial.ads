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

with Common.Types; use Common.Types;

package Hw.Serial is

  -- Read one character from the given serial.
  function Read (From: Serial_Type) return Character;

  -- Skip any remaning character and go to the start of the next frame
  -- Note that this make sense only for Zigbee right now.
  procedure Flush (From : Serial_Type);

  -- Send a string to the given serial.
  -- Note that the string must be < 100 characters to fit in one zigbee frame.
  procedure Send (S : String; To: Serial_Type);

end Hw.Serial;
