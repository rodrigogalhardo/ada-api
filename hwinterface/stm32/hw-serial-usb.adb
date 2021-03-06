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

with Stm32.USB;

package body Hw.Serial.USB is

  ----------
  -- Read --
  ----------

  function Read return Character is
  begin
    return Stm32.USB.Read;
  end Read;

  -----------
  -- Flush --
  -----------

  procedure Flush is
  begin
    null;
  end Flush;

  ----------
  -- Send --
  ----------

  procedure Send (S : String) is
  begin
    Stm32.USB.Send (S);
  end Send;
end Hw.Serial.USB;
