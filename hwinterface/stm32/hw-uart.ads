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

--****c* Hw.UART/Hw.UART
--
--  NAME
--    Hw.UART -- Package for Analog to Digital Converter.
--  COPYRIGHT
--    (c) 2014 by Julien Brette & Julien Romero
--  SYNOPSIS
--    with Hw.UART;
--  DESCRIPTION
--    Advanced functions for UART, with predefined peripherals. It will use the
--  following GPIO pins :
--    * PA2 for AX12 Tx
--    * PA3 for AX12 Rx
--    * PA1 for AX12 Enable
--    * PC10 for Zigbee Tx
--    * PC11 for Zigbee Rx
--    * PD8 for Camera Tx.
--    * PD9 for Camera Rx.
--    * PC7 for Lidar.
--    * PD4, forced Low.
--    * PE3, forced High.
--  It will also use the following uart :
--    * 2 for AX12
--    * 4 for Zigbee
--    * 3 for Camera
--    * 6 for Lidar
--  Conclusion : take care when you use this package ! For more information, see
--  Hw.Hw_Config.
--  AUTHOR
--    Julien Brette & Julien Romero
--  USES
--    Stm32.GPIO, Stm32.UART
--*****

package Hw.UART is

--****t* Hw.UART/UART_Line
--
--  NAME
--    UART_Line -- The different personal UART peripherals.
--  USAGE
--    Choose between :
--      * AX_1 for AX12
--      * Zigbee for Zigbee
--      * Camera for the camera
--      * Lidar for the Lidar
--
--*****

  type UART_Line is (Ax_1, Zigbee, Camera, Lidar);

--****t* Hw.UART/UART_Desc
--
--  NAME
--    UART_Desc -- Description of an UART peripheral.
--  USAGE
--    This type is used inside the .adb to initialize the different peripherals.
--  If you want to add one, add it in the hw-hw_config.ads and at the end of the
--  hw-uart.adb.
--  You must define the following fields of the record :
--    * UART_Tx : The UART number of the transmission, of type UART_Number.
--    * UART_Rx : The UART number of the reception, of type UART_Number.
--    * Tx : The transmission pin, of type Pin_Type.
--    * Rx : The recption pin, of type Pin_Type.
--    * En : The enable pin, of type Pin_Type.
--    * Use_En : Activation of enable pin, of type Boolean.
--    * Tx_PP : Activation of Push/Pull on transmission pin, of type Boolean.
--  SEE ALSO
--    Stm32.UART/UART_Number, Stm32.GPIO/Pin_Type
--
--*****

  type UART_Desc is record
    UART_Tx : UART_Number;
    UART_Rx : UART_Number;
    Tx      : Pin_Type;
    Rx      : Pin_Type;
    En      : Pin_Type;
    Use_En  : Boolean;
    Tx_PP   : Boolean;
  end record;

--****f* Hw.UART/Send
--
--  NAME
--    Send -- Send a message on uart.
--  SYNOPSIS
--    Send(UART,S);
--  FUNCTION
--    Send a string on the given uart line.
--  INPUTS
--    UART - The uart peripheral, of type UART_Line.
--    S    - The String to send.
--  SEE ALSO
--   UART_Line
--
--*****

  procedure Send (UART : UART_Line; S : String);

--****f* Hw.UART/Read
--
--  NAME
--    Read -- Read a char on uart.
--  SYNOPSIS
--    C := Read(UART);
--  FUNCTION
--    Read a Character on the given UART.
--  INPUTS
--    UART - The uart peripharal to read, of type UART_Line.
--  RESULT
--    C - The Character read.
--  SEE ALSO
--    UART_Line
--
--*****

  function Read (UART : UART_Line) return Character;

--****f* Hw.UART/Wait
--
--  NAME
--    Wait -- Wait and read a character on uart for 0.1 second.
--  SYNOPSIS
--    Wait(UART, C, Timeout);
--  FUNCTION
--    Read a Character on the given uart. If there is nothing to read for 0.1
--  second, the function return that the reading failed.
--  INPUTS
--    UART    - The uart line, of type UART_Line.
--    C       - An out Character that contains the read Character.
--    Timeout - An out Boolean to say if the reading succeeded.
--  SEE ALSO
--    UART_Line
--
--*****

  procedure Wait (UART : UART_Line; C : out Character; Timeout : out Boolean);

--****f* Hw.UART/Flush
--
--  NAME
--    Flush -- Flush uart.
--  SYNOPSIS
--    Flush(UART);
--  FUNCTION
--    Flush a given uart.
--  INPUTS
--    UART - The uart line, of type UART_Line.
--  SEE ALSO
--    UART_Line
--
--*****

  procedure Flush (UART : UART_Line);

end Hw.UART;
