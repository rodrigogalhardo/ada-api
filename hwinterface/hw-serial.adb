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

with Hw.Serial.Camera;
with Hw.Serial.USB;
with Hw.Serial.Zigbee;
with Logging;
with Zigbee_Wrapper;
pragma Elaborate_All (Zigbee_Wrapper);

package body Hw.Serial is

  package Wrapped_Camera is new Zigbee_Wrapper (
    Name => "Camera",
    Raw_Read => Hw.Serial.Camera.Read,
    Raw_Send => Hw.Serial.Camera.Send,
    Log => Logging.Log);

  package Wrapped_USB is new Zigbee_Wrapper (
    Name => "USB",
    Raw_Read => Hw.Serial.USB.Read,
    Raw_Send => Hw.Serial.USB.Send,
    Log => Logging.Log);

  package Wrapped_Zigbee is new Zigbee_Wrapper (
    Name => "Zigbee",
    Raw_Read => Hw.Serial.Zigbee.Read,
    Raw_Send => Hw.Serial.Zigbee.Send,
    Log => Logging.Log);

  ----------
  -- Read --
  ----------

  function Read (From : Serial_Type) return Character is
  begin
    case From is
      when USB_Serial =>
        return Wrapped_USB.Read;
      when Zigbee_Serial =>
        return Wrapped_Zigbee.Read;
      when Camera_Serial =>
        return Wrapped_Camera.Read;
    end case;
  end Read;

  -----------
  -- Flush --
  -----------

  procedure Flush (From : Serial_Type) is
  begin
    case From is
      when USB_Serial =>
        Wrapped_USB.Flush;
      when Zigbee_Serial =>
        Wrapped_Zigbee.Flush;
      when Camera_Serial =>
        Wrapped_Camera.Flush;
    end case;
  end Flush;

  ----------
  -- Send --
  ----------

  procedure Send (S : String; To: Serial_Type) is
  begin
    case To is
      when USB_Serial =>
        Wrapped_USB.Send (S);
      when Zigbee_Serial =>
        Wrapped_Zigbee.Send (S);
      when Camera_Serial =>
        Wrapped_Camera.Send (S);
    end case;
  end Send;

end Hw.Serial;
