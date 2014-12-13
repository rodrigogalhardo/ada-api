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

with Base_Network;
pragma Elaborate_All (Base_Network);
with Network_Serial;
pragma Elaborate_All (Network_Serial);

package body Hw.Serial.USB is

  package Net is new Base_Network ("stm32-board");
  package Serial is new Network_Serial (7777 ,Net);

  ----------------------
  -- PUBLIC FUNCTIONS --
  ----------------------

  ----------
  -- Read --
  ----------

  function Read return Character is
  begin
    return Serial.Read;
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
    Serial.Send (S);
  end Send;

end Hw.Serial.USB;
