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

package Stm32.UART is
  type UART_Number is new Integer range 1 .. 6;

  AF_UART : constant array (UART_Number) of Alternate_Function :=
    (AF_USART1, AF_USART2, AF_USART3, AF_UART4, AF_UART5, AF_USART6);

  type Word_Length_Type is (Length_8, Length_9);
  for Word_Length_Type'Size use 16;
  for Word_Length_Type use (
    Length_8 => 16#0000#,
    Length_9 => 16#1000#);

  type Stop_Type is (Stop_1, Stop_0_5, Stop_2, Stop_1_5);
  for Stop_Type'Size use 16;
  for Stop_Type use (
    Stop_1   => 16#0000#,
    Stop_0_5 => 16#1000#,
    Stop_2   => 16#2000#,
    Stop_1_5 => 16#3000#);

  type Parity_Type is (No_Parity, Odd_Parity, Even_Parity);
  for Parity_Type'Size use 16;
  for Parity_Type use (
    No_Parity   => 16#0000#,
    Odd_Parity  => 16#0400#,
    Even_Parity => 16#0600#);

  type UART_Mode_Type is (Mode_None, Mode_Rx, Mode_Tx, Mode_Both);
  for UART_Mode_Type'Size use 16;
  for UART_Mode_Type use (
    Mode_None => 16#0000#,
    Mode_Rx   => 16#0004#,
    Mode_Tx   => 16#0008#,
    Mode_Both => 16#000C#);

  type Flow_Control_Type is (None, RTS, CTS, RTS_CTS);
  for Flow_Control_Type'Size use 16;
  for Flow_Control_Type use (
    None    => 16#0000#,
    RTS     => 16#0100#,
    CTS     => 16#0200#,
    RTS_CTS => 16#0300#);

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

  type DMA_Req_Type is (Rx, Tx);
  for DMA_Req_Type'Size use 16;
  for DMA_Req_Type use (
    Rx => 16#0040#,
    Tx => 16#0080#);

  type UART_Params is record
    Baud_Rate : Unsigned_32;
    Word_Length : Word_Length_Type;
    Stop_Bit : Stop_Type;
    Parity : Parity_Type;
    Mode : UART_Mode_Type;
    Flow_Control : Flow_Control_Type;
  end record;

  IRQ : constant array (UART_Number) of IRQn_Type :=
    (USART1_IRQn, USART2_IRQn, USART3_IRQn,
     UART4_IRQn, UART5_IRQn, USART6_IRQn);

  procedure UART_Init (UART : UART_Number;
                       Params : UART_Params);

  procedure Configure_Pins (UART : UART_Number; Tx : Pin_Type; Rx : Pin_Type; Tx_PP : Boolean := False);

  procedure Configure_Interrupt (UART : UART_Number;
                                 Flag : UART_Flag_Type;
                                 State : FunctionalState);

  function Get_Flag_Status (UART : UART_Number;
                            Flag : UART_Flag_Type) return Boolean;

  procedure Clear_Flag (UART : UART_Number;
                        Flag : UART_Flag_Type);

  function Get_Interrupt_Flag_Status (UART : UART_Number;
                                      Flag : UART_Flag_Type) return Boolean;

  procedure Clear_Interrupt_Flag (UART : UART_Number;
                                  Flag : UART_Flag_Type);

  procedure Setup_DMA (UART : UART_Number; Req : DMA_Req_Type;
                       State : FunctionalState);

  function DMA_Channel (UART : UART_Number) return DMA_Channel_Type;

  function DMA_Stream (UART : UART_Number; Req : DMA_Req_Type)
      return DMA_Stream_Type;

  function Data_Register_Address (UART : UART_Number) return System.Address;

  procedure Send_Data (UART : UART_Number;
                       Data : Unsigned_16);

  function Receive_Data (UART : UART_Number) return Unsigned_16;

end Stm32.UART;
