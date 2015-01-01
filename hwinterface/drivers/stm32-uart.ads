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

with Interfaces; use Interfaces;
with Stm32.Defines; use Stm32.Defines;
with Stm32.DMA; use Stm32.DMA;
with Stm32.GPIO; use Stm32.GPIO;
with Stm32.NVIC; use Stm32.NVIC;
with System;

--****c* Stm32.UART/Stm32.UART
--
--  NAME
--    Stm32.UART -- Manages UART for the stm.
--  COPYRIGHT
--    (c) 2014 by Julien Brette & Julien Romero
--  SYNOPSIS
--    with Stm32.UART;
--  DESCRIPTION
--    Manages UART for the stm32.
--  AUTHOR
--    Julien Brette & Julien Romero
--  USES
--    Interfaces, Stm32.Defines, Stm32.DMA, Stm32.GPIO, Stm32.NVIC, System
--
--*****

package Stm32.UART is

--****t* Stm32.UART/UART_Number
--
--  NAME
--    UART_Number -- The number of the UART.
--  USAGE
--    An Integer between 1 and 6 (included) representing the number of the UART.
--
--*****

  type UART_Number is new Integer range 1 .. 6;

--****d* Stm32.UART/AF_UART
--
--  NAME
--    AF_UART -- An array representing the UART alternate functions.
--  USAGE
--    This array gives the alternate function corresponding to an uart_number.
--  It is an array of Alternate_Function and its index is an UART_Number.
--  SEE ALSO
--    Stm32.GPIO/Alternate_Function
--
--*****

  AF_UART : constant array (UART_Number) of Alternate_Function :=
    (AF_USART1, AF_USART2, AF_USART3, AF_UART4, AF_UART5, AF_USART6);

--****t* Stm32.UART/Word_Length_Type
--
--  NAME
--    Word_Length_Type -- The length of an UART word.
--  USAGE
--    Choose between Length_8 and Length_9 for words if length 8 or 9.
--
--*****

  type Word_Length_Type is (Length_8, Length_9);
  for Word_Length_Type'Size use 16;
  for Word_Length_Type use (
    Length_8 => 16#0000#,
    Length_9 => 16#1000#);

--****t* Stm32.UART/Stop_Type
--
--  NAME
--    Stop_Type
--  USAGE
--    Choose between Stop_1 for a stop bit of length 1, Stop_0_5 for a length of
--  0.5, Stop_2 for a length of 2 and Stop_1_5 for a length of 1.5.
--
--*****

  type Stop_Type is (Stop_1, Stop_0_5, Stop_2, Stop_1_5);
  for Stop_Type'Size use 16;
  for Stop_Type use (
    Stop_1   => 16#0000#,
    Stop_0_5 => 16#1000#,
    Stop_2   => 16#2000#,
    Stop_1_5 => 16#3000#);

--****t* Stm32.UART/Parity_Type
--
--  NAME
--    Parity_Type -- Indicates the bit of parity.
--  USAGE
--    Choose between No_Parity for no bit of parity, Odd_Parity for an odd bit of
--  parity and Even_Parity for an even bit of parity.
--
--*****

  type Parity_Type is (No_Parity, Odd_Parity, Even_Parity);
  for Parity_Type'Size use 16;
  for Parity_Type use (
    No_Parity   => 16#0000#,
    Odd_Parity  => 16#0400#,
    Even_Parity => 16#0600#);

--****t* Stm32.UART/UART_Mode_Type
--
--  NAME
--    UART_Mode_Type -- The mode of the UART.
--  USAGE
--    Choose between Mode_None for no mode, Mode_Rx for reception mode, Mode_Tx
--  for transmission mode and Mode_Both for both reception and transmission mode.
--
--*****

  type UART_Mode_Type is (Mode_None, Mode_Rx, Mode_Tx, Mode_Both);
  for UART_Mode_Type'Size use 16;
  for UART_Mode_Type use (
    Mode_None => 16#0000#,
    Mode_Rx   => 16#0004#,
    Mode_Tx   => 16#0008#,
    Mode_Both => 16#000C#);

--****t* Stm32.UART/Flow_Control_Type
--
--  NAME
--    Flow_Control_Type -- Kind of flow control.
--  USAGE
--    Choose between None if you want no control, RTS for a Ready To Send
--  control, CTS for a Clear To Send control and RTS_CTS for both of them.
--
--*****

  type Flow_Control_Type is (None, RTS, CTS, RTS_CTS);
  for Flow_Control_Type'Size use 16;
  for Flow_Control_Type use (
    None    => 16#0000#,
    RTS     => 16#0100#,
    CTS     => 16#0200#,
    RTS_CTS => 16#0300#);

--****t* Stm32.UART/UART_Flag_Type
--
--  NAME
--    UART_Flag_Type -- The uart flags.
--  USAGE
--    Choose between :
--      * CTS : for the change of CTS
--      * LBD : LIN Break detection flag.
--      * TXE : Indicates that the send register is empty.
--      * TC  : Indicates that the transmission ended.
--      * RXNE: Indicates that datas have been received and are ready to be read.
--      * IDLE: Idle Line detection flag.
--      * ORE : OverRun Error flag.
--      * NE  : Noise Error flag.
--      * FE  : Framing Error flag.
--      * PE  : Parity Error flag.
--
--*****

  type UART_Flag_Type is (PE, FE, NE, ORE, IDLE, RXNE,
                          TC, TXE, LBD, CTS);
  for UART_Flag_Type'Size use 16;
  for UART_Flag_Type use (
    PE   => 16#0001#,
    FE   => 16#0002#,
    NE   => 16#0004#,
    ORE  => 16#0008#,
    IDLE => 16#0010#,
    RXNE => 16#0020#,
    TC   => 16#0040#,
    TXE  => 16#0080#,
    LBD  => 16#0100#,
    CTS  => 16#0200#);

--****t* Stm32.UART/DMA_Req_Type
--
--  NAME
--    DMA_Req_Type -- Reception or transmission DMA.
--  USAGE
--    Choose between :
--      * Rx for a DMA in reception
--      * Tx for a DMA in transmission
--
--*****

  type DMA_Req_Type is (Rx, Tx);
  for DMA_Req_Type'Size use 16;
  for DMA_Req_Type use (
    Rx => 16#0040#,
    Tx => 16#0080#);

--****t* Stm32.UART/UART_Params
--
--  NAME
--    UART_Params -- A record representing the parameters of the UART module.
--  USAGE
--    Define the following fields of the record :
--      * Baud_Rate   : The UART Baudrate, of type Unsigned_32.
--      * Word_Length : The length of the words, of type Word_Length_Type.
--      * Stop_Bit    : The length of the stop bit, of type Stop_Type.
--      * Parity      : The parity bit of the UART, of type Parity_Type.
--      * Mode        : The mode of the UART, of type UART_Mode_Type.
--      * Flow_Control: The flow control, of type Flow_Control_Type.
--  SEE ALSO
--    Word_Length_Type, Stop_Type, Parity_Type, UART_Mode_Type, Flow_Control_Type
--
--*****

  type UART_Params is record
    Baud_Rate : Unsigned_32;
    Word_Length : Word_Length_Type;
    Stop_Bit : Stop_Type;
    Parity : Parity_Type;
    Mode : UART_Mode_Type;
    Flow_Control : Flow_Control_Type;
  end record;

--****d* Stm32.UART/IRQ
--
--  NAME
--    IRQ -- An array giving the interrupt corresponding to an uart.
--  USAGE
--    This is an array of IRQn_Type. It gives the interrupt corresponding to an
--  uart (in index), of type UART_Number.
--  SEE ALSO
--    IRQn_Type, UART_Number
--
--*****

  IRQ : constant array (UART_Number) of IRQn_Type :=
    (USART1_IRQn, USART2_IRQn, USART3_IRQn,
     UART4_IRQn, UART5_IRQn, USART6_IRQn);

--****f* Stm32.UART/UART_Init
--
--  NAME
--    UART_Init -- Initialize an uart.
--  SYNOPSIS
--    UART_Init(UART, Params);
--  FUNCTION
--    Initialize the given uart with the given parameters.
--  INPUTS
--    UART   - The uart number to initialize, of type UART_Number.
--    Params - The parameters of the uart, of type UART_Params.
--  SEE ALSO
--    UART_Number, UART_Params
--
--*****

  procedure UART_Init (UART : UART_Number;
                       Params : UART_Params);

--****f* Stm32.UART/Configure_Pins
--
--  NAME
--    Configure_Pin -- Configure pins for uart.
--  SYNOPSIS
--    Configure_Pin(UART, Tx, Rx, Tx_PP);
--  FUNCTION
--    Configure the given pins to receive an uart communication.
--  INPUTS
--    UART   - The number of the uart to initialize, of type UART_Number.
--    Tx     - The transmission pin, of type Pin_Type.
--    Rx     - The reception pin, of type Pin_Type.
--    Tx_PP  - A Boolean to indicate if the transmission pin is in Push/Pull,
--  False by default.
--  SEE ALSO
--    UART_Number,Stm32.GPIO/Pin_Type
--
--*****

  procedure Configure_Pins (UART : UART_Number; Tx : Pin_Type; Rx : Pin_Type; Tx_PP : Boolean := False);

--****f* Stm32.UART/Configure_Interrupt
--
--  NAME
--    Configure_Interrupt -- Configure an UART with an interrupt.
--  SYNOPSIS
--    Configure_Interrupt(UART, Flag, State);
--  FUNCTION
--    Configure an interrupt to work (or not) with the given UART.
--  INPUTS
--    UART  - The number of the UART to use, of type UART_Number.
--    Flag  - The flag on which the interrupt will react, of type UART_Flag_Type
--    State - Activate or desactivate the uart, of type FunctionalState.
--  SEE ALSO
--    UART_Number, UART_Flag_Type, Stm32.Defines/FunctionalState
--
--*****

  procedure Configure_Interrupt (UART : UART_Number;
                                 Flag : UART_Flag_Type;
                                 State : FunctionalState);

--****f* Stm32.UART/Get_Flag_Status
--
--  NAME
--    Get_Flag_Status -- Get the status of a flag.
--  SYNOPSIS
--    value := Get_Flag_Status(UART, Flag);
--  FUNCTION
--    Get the state of the given flag for the given uart.
--  INPUTS
--    UART - The UART to use, of type UART_Number.
--    Flag - The flag to get the status, of type UART_Flag_Type.
--  RESULT
--    value - A Boolean representing the status of the flag.
--  SEE ALSO
--    UART_Number, UART_Flag_Type
--
--*****

  function Get_Flag_Status (UART : UART_Number;
                            Flag : UART_Flag_Type) return Boolean;

--****f* Stm32.UART/Clear_Flag
--
--  NAME
--    Clear_Flag -- Clear a uart flag.
--  SYNOPSIS
--    Clear_Flag(UART, Flag);
--  FUNCTION
--    Clear the given flag of the given UART.
--  INPUTS
--    UART - The uart to use, of type UART_Number.
--    Flag - The flag to clear, of type UART_Flag_Type.
--  SEE ALSO
--    UART_Number, UART_Flag_Type
--
--*****

  procedure Clear_Flag (UART : UART_Number;
                        Flag : UART_Flag_Type);

--****f* Stm32.UART/Get_Interrupt_Flag_Status
--
--  NAME
--    Get_Interrupt_Flag_Status -- Get the status of the interruption of a flag
--  SYNOPSIS
--    value := Get_Interrupt_Flag_Status(UART, Flag);
--  FUNCTION
--    Get the status of the interruption linked to a flag, to know for example
--  if this flag called the interrupt.
--  INPUTS
--    UART - The number of the uart, of type UART_Number
--    Flag - The flag of the interrupt, of type UART_Flag_Type
--  RESULT
--    value - A Boolean representing the status of the interrupt of a flag.
--  SEE ALSO
--    UART_Number, UART_Flag_Type
--
--*****

  function Get_Interrupt_Flag_Status (UART : UART_Number;
                                      Flag : UART_Flag_Type) return Boolean;

--****f* Stm32.UART/Clear_Interrupt_Flag
--
--  NAME
--    Clear_Interrupt_Flag -- Clear the flag of the interrupt linked to a flag.
--  SYNOPSIS
--    Clear_Interrupt_Flag(UART, Flag);
--  FUNCTION
--    Clear the flag of the interrupt linked to the given flag of the given
--  uart.
--  INPUTS
--    UART - The number of the UART, of type UART_Number
--    Flag - The flag of the interrupt to clear, of type UART_Flag_Type.
--  SEE ALSO
--    UART_Number, UART_Flag_Type
--
--*****

  procedure Clear_Interrupt_Flag (UART : UART_Number;
                                  Flag : UART_Flag_Type);

--****f* Stm32.UART/Setup_DMA
--
--  NAME
--    Setup_DMA -- Controls the DMA requests activations.
--  SYNOPSIS
--    Setup_DMA(UART, Req, State);
--  FUNCTION
--    Activate or desactivate the USART DMA request for the given UART and for
--  the given request type.
--  INPUTS
--    UART  - The Number of the UART, of type UART_Number
--    Req   - The request type, of type DMA_Req_Type
--    State - The state of the DMA, of type FunctionalState.
--  SEE ALSO
--    UART_Number, DMA_Req_Type, Stm32.Defines/FunctionalState
--
--*****

  procedure Setup_DMA (UART : UART_Number; Req : DMA_Req_Type;
                       State : FunctionalState);

--****f* Stm32.UART/DMA_Channel
--
--  NAME
--    DMA_Channel -- Gives the DMA channel of an uart.
--  SYNOPSIS
--    channel := DMA_Channel(UART);
--  FUNCTION
--    Gives the DMA channel of a given UART.
--  INPUTS
--    UART - The number of the UART, of type UART_Number.
--  RESULT
--    channel - The DMA channel of the uart, of type DMA_Channel_Type
--  SEE ALSO
--    UART_Number, Stm32.DMA/DMA_Channel_Type
--
--*****

  function DMA_Channel (UART : UART_Number) return DMA_Channel_Type;

--****f* Stm32.UART/DMA_Stream_Type
--
--  NAME
--    DMA_Stream_Type -- Gives the stream of an uart for a specific request.
--  SYNOPSIS
--    stream := DMA_Stream(UART, Req);
--  FUNCTION
--    Gives the stream used by the given uart for the given request.
--  INPUTS
--    UART - The number of the uart, of type UART_Number.
--    Req  - The request type, of type DMA_Req_Type.
--  RESULT
--    stream - The stream of the DMA, of type DMA_Stream_Type
--  SEE ALSO
--    UART_Number, DMA_Req_Type, Stm32.DMA/DMA_Stream_Type
--
--*****

  function DMA_Stream (UART : UART_Number; Req : DMA_Req_Type)
      return DMA_Stream_Type;

--****f* Stm32.UART/Data_Register_Address
--
--  NAME
--    Data_Register_Address -- Gives the data register address of an uart.
--  SYNOPSIS
--    address := Data_Register_Address(UART);
--  FUNCTION
--    Gives the data register address of the given UART.
--  INPUTS
--    UART - The uart number, of type UART_Number
--  RESULT
--    address - The address of the uart, of type System.Address.
--  SEE ALSO
--    UART_Number, System.Address
--
--*****

  function Data_Register_Address (UART : UART_Number) return System.Address;

--****f* Stm32.UART/Send_Data
--
--  NAME
--    Send_Data -- Send datas in the UART.
--  SYNOPSIS
--    Send_Data(UART, Data);
--  FUNCTION
--    Sends datas on the given UART.
--  INPUTS
--    UART - The uart on which the datas are sent, of type UART_Number.
--    Data - The data to send, of type Unsigned_16.
--  SEE ALSO
--    UART_Number
--
--*****

  procedure Send_Data (UART : UART_Number;
                       Data : Unsigned_16);

--****f* Stm32.UART/Receive_Data
--
--  NAME
--    Receive_Data -- Receive datas on the uart.
--  SYNOPSIS
--    value := Receive_Data(UART);
--  FUNCTION
--    Receives datas of the given UART.
--  INPUTS
--    UART - The uart on which the datas are received, of type UART_Number.
--  RESULT
--    value - the datas received, of type Unsigned_16.
--  SEE ALSO
--    UART_Number
--
--*****

  function Receive_Data (UART : UART_Number) return Unsigned_16;

end Stm32.UART;
