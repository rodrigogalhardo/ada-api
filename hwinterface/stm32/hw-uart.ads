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

with Stm32.GPIO; use Stm32.GPIO;
pragma Elaborate_All (Stm32.GPIO);
with Stm32.UART; use Stm32.UART;
pragma Elaborate_All (Stm32.UART);

package Hw.UART is

  type UART_Line is (Ax_1, Zigbee, Camera, Lidar);

  type UART_Desc is record
    UART_Tx : UART_Number;
    UART_Rx : UART_Number;
    Tx      : Pin_Type;
    Rx      : Pin_Type;
    En      : Pin_Type;
    Use_En  : Boolean;
    Tx_PP   : Boolean;
  end record;

  procedure Send (UART : UART_Line; S : String);
  function Read (UART : UART_Line) return Character;
  procedure Wait (UART : UART_Line; C : out Character; Timeout : out Boolean);
  procedure Flush (UART : UART_Line);

end Hw.UART;
