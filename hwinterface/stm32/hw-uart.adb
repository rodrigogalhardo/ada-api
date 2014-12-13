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

with Interfaces; use Interfaces;
with Ada.Real_Time; use Ada.Real_Time;
with Stm32.Defines; use Stm32.Defines;
with Stm32.DMA; use Stm32.DMA;
pragma Elaborate_All (Stm32.DMA);
with Stm32.NVIC; use Stm32.NVIC;
with Hw.Hw_Config; use Hw.Hw_Config;
with System; use System;
with Stack_Size;

package body Hw.UART is

  subtype Queue_Type is String (1 .. 2048);

  type UART_Desc_Access is access all UART_Desc;

  procedure Setup_UART (UART : UART_Number; Tx_Pin : Pin_Type;
                        Rx_Pin : Pin_Type; Speed : Integer;
                        Use_En : Boolean; Tx_PP : Boolean);

  protected type UART_Type (UART : UART_Desc_Access) is
    pragma Interrupt_Priority (Max_Interrupt_Priority);
    procedure Initialize (Speed : Integer);

    entry Wait (C : out Character; Canceled : out Boolean);
    procedure Send (S : String);
    procedure Flush;

    procedure Set_Timeout (T : Time);
    procedure Check_Timeout;
  private
    procedure Start_DMA_Transfer;
    procedure UART_Interrupt_Handler;
    pragma Attach_Handler (UART_Interrupt_Handler,
                           Stm32.UART.IRQ (UART.UART_Rx));
    procedure DMA_Interrupt_Handler;
    pragma Attach_Handler (DMA_Interrupt_Handler,
                           Stm32.DMA.IRQ (DMA_Stream (UART.UART_Tx, Tx)));

    Rx_Not_Empty : Boolean := False;
    Rx_Read : Integer := 1;
    Rx_Write : Integer := 1;
    Rx_Queue : Queue_Type;

    Tx_Not_Empty : Boolean := False;
    Tx_Read : Integer := 1;
    Tx_Write : Integer := 1;
    Tx_Queue : Queue_Type;

    Timeout : Time;
  end UART_Type;

  Serial_1 : aliased UART_Type (Bus_1_UART'Access);
  Serial_Zigbee : aliased UART_Type (Zigbee_UART'Access);
  Serial_Camera : aliased UART_Type (Camera_UART'Access);
  Serial_Lidar : aliased UART_Type (Lidar_UART'Access);

  type UART_Type_Access is access all UART_Type;

  UARTs : constant array (UART_Line) of UART_Type_Access :=
    (Ax_1 => Serial_1'Access, Zigbee => Serial_Zigbee'Access,
     Camera => Serial_Camera'Access, Lidar => Serial_Lidar'Access);

  task Timeout_Checker_Task is
    pragma Priority (15);
    pragma Storage_Size (4 * Stack_Size.Default_Stack_Size);
  end Timeout_Checker_Task;

  ---------------
  -- UART_Type --
  ---------------

  protected body UART_Type is

    --------------------------
    -- UART_Type.Initialize --
    --------------------------

    procedure Initialize (Speed : Integer) is
    begin
      Setup_UART (UART.UART_Tx, UART.Tx, UART.Rx, Speed, UART.Use_En, UART.Tx_PP);
      Setup_UART (UART.UART_Rx, UART.Tx, UART.Rx, Speed, UART.Use_En, UART.Tx_PP);
      if UART.Use_En then
        Setup_Out_Pin (UART.En);
      end if;
    end Initialize;

    --------------------
    -- UART_Type.Wait --
    --------------------

    entry Wait (C : out Character; Canceled : out Boolean) when Rx_Not_Empty is
    begin
      C := Rx_Queue (Rx_Read);
      -- Clock > Timeout, Rx_Not_Empty will be set to True.
      -- Here, we have to verify that there really is something to read.
      if Rx_Read /= Rx_Write then
        Rx_Read := Rx_Read + 1;
        if Rx_Read > Rx_Queue'Last then
          Rx_Read := Rx_Queue'First;
        end if;
        Canceled := False;
      else
        Canceled := True;
      end if;
      Rx_Not_Empty := Rx_Read /= Rx_Write;
    end Wait;

    --------------------
    -- UART_Type.Send --
    --------------------

    procedure Send (S : String) is
      DMA : constant DMA_Stream_Type := DMA_Stream (UART.UART_Tx, Tx);
    begin
      for I in S'Range loop
        Tx_Queue (Tx_Write) := S (I);
        Tx_Write := Tx_Write + 1;
        if Tx_Write > Tx_Queue'Last then
          Tx_Write := Tx_Queue'First;
        end if;
      end loop;
      Tx_Not_Empty := Tx_Read /= Tx_Write;
      if not Is_Enable (DMA) then
        Start_DMA_Transfer;
      end if;
    end Send;

    ---------------------
    -- UART_Type.Flush --
    ---------------------

    procedure Flush is
    begin
      Rx_Read := Rx_Write;
      Rx_Not_Empty := Rx_Read /= Rx_Write;
    end Flush;

    ---------------------------
    -- UART_Type.Set_Timeout --
    ---------------------------

    procedure Set_Timeout (T : Time) is
    begin
      Timeout := T;
    end Set_Timeout;

    -----------------------------
    -- UART_Type.Check_Timeout --
    -----------------------------

    procedure Check_Timeout is
    begin
      if Clock > Timeout then
        Rx_Not_Empty := True;
      end if;
    end Check_Timeout;

    ------------------------
    -- Start_DMA_Transfer --
    ------------------------

    procedure Start_DMA_Transfer is
      Size : Integer := Tx_Write - Tx_Read;
    begin
      if Size < 0 then
        Size := Tx_Queue'Last + 1 - Tx_Read;
      end if;
      if Size /= 0 then
        if UART.Use_En then
          Set_Pin (UART.En, False);
        end if;
        Start_Transfer (DMA_Stream (UART.UART_Tx, Tx),
                        Tx_Queue (Tx_Read)'Address, Size);
        Tx_Read := Tx_Read + Size;
        if Tx_Read > Tx_Queue'Last then
          Tx_Read := Tx_Queue'First;
        end if;
        Tx_Not_Empty := Tx_Read /= Tx_Write;
      elsif UART.Use_En then
        Set_Pin (UART.En, False);
      end if;
    end Start_DMA_Transfer;

    ----------------------------------------
    -- UART_Type.UART_Interrupt_Handler --
    ----------------------------------------

    procedure UART_Interrupt_Handler is
      Rx : constant Boolean := Get_Interrupt_Flag_Status (UART.UART_Rx, RXNE);
      Transfer_Complete : constant Boolean :=
          Get_Interrupt_Flag_Status (UART.UART_Rx, TC);
      C : Unsigned_16;
    begin
      -- Is there something to read ?
      if Rx then
        C := Stm32.UART.Receive_Data (UART.UART_Rx);
        Rx_Queue (Rx_Write) := Character'Val (C);
        Rx_Write := Rx_Write + 1;
        if Rx_Write > Rx_Queue'Last then
          Rx_Write := Rx_Queue'First;
        end if;
        Rx_Not_Empty := Rx_Read /= Rx_Write;
      end if;
      if Transfer_Complete then
        if UART.Use_En then
          Set_Pin (UART.En, True);
        end if;
        Clear_Interrupt_Flag (UART.UART_Rx, TC);
      end if;

      if Get_Flag_Status (UART.UART_Rx, ORE) then
--        Led_On (Error);
        null;
      end if;
    end UART_Interrupt_Handler;

    --------------------------
    -- DMA_Interrupt_Hander --
    --------------------------

    procedure DMA_Interrupt_Handler is
      DMA : constant DMA_Stream_Type := DMA_Stream (UART.UART_Tx, Tx);
    begin
      if Get_Interrupt_Flag (DMA, Transfer_Error) then
--        Led_On (Error);
        null;
      end if;
      if Get_Interrupt_Flag (DMA, Transfer_Complete) then
        while Is_Enable (DMA) loop
--          Led_On (Error);
          null;
        end loop;
        Clear_Interrupt_Flag (DMA, Transfer_Complete);
        -- Is there something else to send ?
        Start_DMA_Transfer;

      end if;
    end DMA_Interrupt_Handler;

  end UART_Type;

  --------------------------
  -- Timeout_Checker_Task --
  --------------------------

  task body Timeout_Checker_Task is
  begin
    loop
      for I in UART_Line loop
        UARTs (I).Check_Timeout;
      end loop;
      delay until Clock + To_Time_Span (0.1);
    end loop;
  end Timeout_Checker_Task;

  ----------------
  -- Setup_UART --
  ----------------

  procedure Setup_UART (UART : UART_Number; Tx_Pin : Pin_Type;
                        Rx_Pin : Pin_Type; Speed : Integer;
                        Use_En : Boolean; Tx_PP : Boolean) is
    Params : constant UART_Params := (
        Baud_Rate    => Unsigned_32 (Speed),
        Word_Length  => Length_8,
        Stop_Bit     => Stop_1,
        Parity       => No_Parity,
        Mode         => Mode_Both,
        Flow_Control => None);
    DMA : constant DMA_Params := (
        Channel => DMA_Channel (UART),
        Peripheral_Base_Addr => Data_Register_Address (UART),
        Memory_Base_Addr => Null_Address,
        Dir => Memory_To_Peripheral,
        Buffer_Size => 0,
        Peripheral_Inc => Disable,
        Memory_Inc => Enable,
        Peripheral_Data_Size => Byte,
        Memory_Data_Size => Byte,
        Mode => Normal,
        Priority => Very_High,
        FIFO_Mode => Disable,
        FIFO_Threshold => One_Quarter,
        Memory_Burst => Single,
        Peripheral_Burst => Single);
    Stream : constant DMA_Stream_Type := DMA_Stream (UART, Tx);
  begin
    Configure_Pins (UART, Tx_Pin, Rx_Pin, Tx_PP);
    UART_Init (UART, Params);
    DMA_Init (Stream, DMA);
    Setup_DMA (UART, Tx, Enable);

    Configure_Interrupt (UART, RXNE, Enable);
    Configure_Interrupt (UART, ORE, Enable);
    if Use_En then
      Configure_Interrupt (UART, TC, Enable);
    end if;
    Configure_Interrupt (Stream, Transfer_Complete, Enable);
    Configure_Interrupt (Stream, Transfer_Error, Enable);

    NVIC_Init (Stm32.UART.IRQ (UART), 1);
    NVIC_Init (Stm32.DMA.IRQ (Stream), 1);
  end Setup_UART;

  ----------------------
  -- PUBLIC FUNCTIONS --
  ----------------------

  ----------
  -- Send --
  ----------

  procedure Send (UART : UART_Line; S : String) is
  begin
    UARTs (UART).Send (S);
  end Send;

  ----------
  -- Read --
  ----------

  function Read (UART : UART_Line) return Character is
    C : Character;
    Canceled : Boolean;
    pragma Warnings (Off, Canceled);
  begin
    UARTs (UART).Set_Timeout (Time_Last);
    UARTs (UART).Wait (C, Canceled);
    return C;
  end Read;

  ----------
  -- Wait --
  ----------

  procedure Wait (UART : UART_Line; C : out Character; Timeout : out Boolean) is
  begin
    UARTs (UART).Set_Timeout (Clock + To_Time_Span (0.1));
    UARTs (UART).Wait (C, Timeout);
  end Wait;

  -----------
  -- Flush --
  -----------

  procedure Flush (UART : UART_Line) is
  begin
    UARTs (UART).Flush;
  end Flush;

begin
  for I in Force'Range loop
    Setup_Out_Pin (Force (I).Pin);
    Set_Pin (Force (I).Pin, Force (I).Value);
  end loop;

  UARTs (Ax_1).Initialize (117647);
  UARTs (Zigbee).Initialize (111111);
  UARTs (Camera).Initialize (115200);
  UARTs (Lidar).Initialize (115200);
end Hw.UART;
