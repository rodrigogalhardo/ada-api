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

with Stm32.RCC; use Stm32.RCC;

package body Stm32.UART is

  type UART_TypeDef is new Unsigned_32;

  UARTs : constant array (UART_Number) of UART_TypeDef :=
    (USART1_BASE, USART2_BASE, USART3_BASE,
     UART4_BASE, UART5_BASE, USART6_BASE);

  Periph : constant array (UART_Number) of Stm_Periph :=
    (USART1, USART2, USART3, UART4, UART5, USART6);

  USART_IT : constant array (UART_Flag_Type) of Unsigned_16 := (
    PE   => 16#0028#,
    FE   => 16#0160#,
    NE   => 16#0260#,
    ORE  => 16#0360#,
    IDLE => 16#0424#,
    RXNE => 16#0525#,
    TC   => 16#0626#,
    TXE  => 16#0727#,
    LBD  => 16#0846#,
    CTS  => 16#096A#);

  UART_Channel : constant array (UART_Number) of DMA_Channel_Type :=
    (Channel_4, Channel_4, Channel_4, Channel_4, Channel_4, Channel_5);

  UART_Stream : constant array (UART_Number, DMA_Req_Type)
      of DMA_Stream_Type :=
    ((Rx => (2, 2), Tx => (2, 7)), (Rx => (1, 5), Tx => (1, 6)),
     (Rx => (1, 1), Tx => (1, 3)), (Rx => (1, 2), Tx => (1, 4)),
     (Rx => (1, 0), Tx => (1, 7)), (Rx => (2, 1), Tx => (2, 6)));

  -------------
  -- Imports --
  -------------

  procedure USART_DeInit (UART : UART_TypeDef);
  pragma Import (C, USART_DeInit, "USART_DeInit");

  procedure USART_Init (UART : UART_TypeDef; Params : access UART_Params);
  pragma Import (C, USART_Init, "USART_Init");

  procedure USART_ITConfig (UART : UART_TypeDef;
                            Interrupt : Unsigned_16;
                            State : FunctionalState);
  pragma Import (C, USART_ITConfig, "USART_ITConfig");

  procedure USART_Cmd (UART : UART_TypeDef; State : FunctionalState);
  pragma Import (C, USART_Cmd, "USART_Cmd");

  function USART_GetFlagStatus (UART : UART_TypeDef; Flag : UART_Flag_Type)
      return Integer;
  pragma Import (C, USART_GetFlagStatus, "USART_GetFlagStatus");

  procedure USART_ClearFlag (UART : UART_TypeDef; Flag : UART_Flag_Type);
  pragma Import (C, USART_ClearFlag, "USART_ClearFlag");

  function USART_GetITStatus (UART : UART_TypeDef; Flag : Unsigned_16)
      return Integer;
  pragma Import (C, USART_GetITStatus, "USART_GetITStatus");

  procedure USART_ClearITPendingBit (UART : UART_TypeDef; Flag : Unsigned_16);
  pragma Import (C, USART_ClearITPendingBit, "USART_ClearITPendingBit");

  procedure USART_DMACmd (UART : UART_TypeDef; Req : DMA_Req_Type;
                          State : FunctionalState);
  pragma Import (C, USART_DMACmd, "USART_DMACmd");

  procedure USART_SendData (UART : UART_TypeDef; Value : Unsigned_16);
  pragma Import (C, USART_SendData, "USART_SendData");

  function USART_ReceiveData (UART : UART_TypeDef) return Unsigned_16;
  pragma Import (C, USART_ReceiveData, "USART_ReceiveData");

  ----------------------
  -- PUBLIC FUNCTIONS --
  ----------------------

  ---------------
  -- UART_Init --
  ---------------

  procedure UART_Init (UART : UART_Number;
                       Params : UART_Params) is
    P : aliased UART_Params := Params;
    U : constant UART_TypeDef := UARTs (UART);
  begin
    RCC_PeriphClockCmd (Periph (UART), Enable);
    USART_DeInit (U);
    USART_Init (U, P'Access);
    USART_Cmd (U, Enable);
  end UART_Init;

  --------------------
  -- Configure_Pins --
  --------------------

  procedure Configure_Pins (UART : UART_Number; Tx : Pin_Type;
                            Rx : Pin_Type; Tx_PP : Boolean := False) is
    GPIO : GPIO_Params;
  begin
    GPIO := (Pins        => (Mask => (others => False)),
             Mode        => Alternate,
             Speed       => Speed_50MHz,
             Output_Type => OD,
             PuPd        => Pull_Up);
    if Tx_PP then
      GPIO.Output_Type := PP;
    end if;
    GPIO.Pins.Mask (Tx.Pin) := True;
    Config_GPIO (Tx.Port, GPIO);
    Config_GPIO_AF (Tx.Port, Tx.Pin, AF_UART (UART));

    GPIO := (Pins        => (Mask => (others => False)),
             Mode        => Alternate,
             Speed       => Speed_50MHz,
             Output_Type => PP,
             PuPd        => Pull_Up);
    GPIO.Pins.Mask (Rx.Pin) := True;
    Config_GPIO (Rx.Port, GPIO);
    Config_GPIO_AF (Rx.Port, Rx.Pin, AF_UART (UART));
  end Configure_Pins;

  -------------------------
  -- Configure_Interrupt --
  -------------------------

  procedure Configure_Interrupt (UART : UART_Number;
                                 Flag : UART_Flag_Type;
                                 State : FunctionalState) is
  begin
    USART_ITConfig (UARTs (UART), USART_IT (Flag), State);
  end Configure_Interrupt;

  ---------------------
  -- Get_Flag_Status --
  ---------------------

  function Get_Flag_Status (UART : UART_Number;
                            Flag : UART_Flag_Type) return Boolean is
  begin
    return USART_GetFlagStatus (UARTs (UART), Flag) /= 0;
  end Get_Flag_Status;

  ----------------
  -- Clear_Flag --
  ----------------

  procedure Clear_Flag (UART : UART_Number;
                        Flag : UART_Flag_Type) is
  begin
    USART_ClearFlag (UARTs (UART), Flag);
  end Clear_Flag;

  -------------------------------
  -- Get_Interrupt_Flag_Status --
  -------------------------------

  function Get_Interrupt_Flag_Status (UART : UART_Number;
                                      Flag : UART_Flag_Type) return Boolean is
  begin
    return USART_GetITStatus (UARTs (UART), USART_IT (Flag)) /= 0;
  end Get_Interrupt_Flag_Status;

  --------------------------
  -- Clear_Interrupt_Flag --
  --------------------------

  procedure Clear_Interrupt_Flag (UART : UART_Number;
                                  Flag : UART_Flag_Type) is
  begin
    USART_ClearITPendingBit (UARTs (UART), USART_IT (Flag));
  end Clear_Interrupt_Flag;

  ---------------
  -- Setup_DMA --
  ---------------

  procedure Setup_DMA (UART : UART_Number; Req : DMA_Req_Type;
                       State : FunctionalState) is
  begin
    USART_DMACmd (UARTs (UART), Req, State);
  end Setup_DMA;

  -----------------
  -- DMA_Channel --
  -----------------

  function DMA_Channel (UART : UART_Number) return DMA_Channel_Type is
  begin
    return UART_Channel (UART);
  end DMA_Channel;

  ----------------
  -- DMA_Stream --
  ----------------

  function DMA_Stream (UART : UART_Number; Req : DMA_Req_Type)
      return DMA_Stream_Type is
  begin
    return UART_Stream (UART, Req);
  end DMA_Stream;

  ---------------------------
  -- Data_Register_Address --
  ---------------------------

  function Data_Register_Address (UART : UART_Number) return System.Address is
    U : constant UART_TypeDef := UARTs (UART);
  begin
    return System'To_Address (U + 4);
  end Data_Register_Address;

  ---------------
  -- Send_Data --
  ---------------

  procedure Send_Data (UART : UART_Number;
                       Data : Unsigned_16) is
  begin
    USART_SendData (UARTs (UART), Data);
  end Send_Data;

  ------------------
  -- Receive_Data --
  ------------------

  function Receive_Data (UART : UART_Number) return Unsigned_16 is
  begin
    return USART_ReceiveData (UARTs (UART));
  end Receive_Data;

end Stm32.UART;
