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
with Hw.UART;
pragma Elaborate_All (Hw.UART);
with Interfaces; use Interfaces;
with Stm32.USB;
pragma Elaborate_All (Stm32.USB);

package body Hw.Serial.Zigbee is

  ----------------------
  -- PUBLIC FUNCTIONS --
  ----------------------

  ----------
  -- Read --
  ----------

  function Read return Character is
  begin
    return Hw.UART.Read (Hw.UART.Zigbee);
  end Read;

  -----------
  -- Flush --
  -----------

  procedure Flush is
  begin
    Hw.UART.Flush (Hw.UART.Zigbee);
  end Flush;

  ----------
  -- Send --
  ----------

  procedure Send (S : String) is
  begin
    Hw.UART.Send (Hw.UART.Zigbee, S);
  end Send;

  -----------------------
  -- PRIVATE FUNCTIONS --
  -----------------------

  -------------
  -- Log_USB --
  -------------

  procedure Log_USB (Msg : String) is
    function Hash (S : String) return Character is
      H : Unsigned_8 := 0;
    begin
      for I in S'Range loop
        H := H - Character'Pos (S (I));
      end loop;
      return Character'Val (H);
    end Hash;
    Bytes : constant String := Character'Val (Msg'Length)
        & Character'Val (0) & Msg;
  begin
    Stm32.USB.Send ("l" & Bytes & Hash (Bytes));
  end Log_USB;

  -----------
  -- Check --
  -----------

  function Checked_Send (S : String; Response : String;
                         D : Time_Span := To_Time_Span (0.0)) return Boolean is
    function Check_Char (Expected : Character) return Boolean is
      C : Character;
      Timeout : Boolean;
    begin
      loop
        Hw.UART.Wait (Hw.UART.Zigbee, C, Timeout);
        exit when C = Expected;
        exit when Timeout;
      end loop;
      if Timeout then
        Log_USB ("No '" & Expected & "'");
      elsif C /= Expected then
        Log_USB ("Get " & C & " instead of '" & Expected & "'");
      else
        return True;
      end if;
      return False;
    end Check_Char;
  begin
    Hw.UART.Send (Hw.UART.Zigbee, S);
    delay until Clock + D;
    for I in Response'Range loop
      if not Check_Char (Response (I)) then
        return False;
      end if;
    end loop;
    return True;
  end Checked_Send;

  ----------
  -- Init --
  ----------

  procedure Init is
    CR : constant Character := Character'Val (13);
  begin
    loop
      delay until Clock + To_Time_Span (1.1);
      if Checked_Send ("+++", "OK" & CR, To_Time_Span (1.1)) and then
         Checked_Send ("ATAP2" & CR, "OK" & CR) and then
         Checked_Send ("ATAP" & CR, "2" & CR) and then
         Checked_Send ("ATCN" & CR, "OK" & CR) then
        Log_USB ("Zigbee config OK.");
        return;
      end if;
    end loop;
--    Log_USB ("Unable to configure Zibee :(");
  end Init;

begin
  Init;
end Hw.Serial.Zigbee;
