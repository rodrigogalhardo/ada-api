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
with Stm32.NVIC; use Stm32.NVIC;
with System; use System;

--****c* Stm32.DMA/Stm32.DMA
--
--  NAME
--    Stm32.DMA -- Package to manage DMA tranfers.
--  COPYRIGHT
--    (c) 2014 by Julien Brette & Julien Romero
--  SYNOPSIS
--    with Stm32.DMA;
--  DESCRIPTION
--    Tools to use the DMA modules of the stm32.
--  AUTHOR
--    Julien Brette & Julien Romero
--  USES
--    Interfaces, Stm32.Defines, Stm32.NVIC, System
--
--*****

package Stm32.DMA is

--****t* Stm32.DMA/DMA_Stream_Type
--
--  NAME
--    DMA_Stream_Type -- Defines a stream.
--  USAGE
--    This is a record with two fields :
--      * DMA : The DMA number, an Integer between 1 and 2 (included).
--      * Stream : The stream number, an Integer between 0 and 7 (included).
--
--*****

  type DMA_Stream_Type is record
    DMA : Integer range 1 .. 2;
    Stream : Integer range 0 .. 7;
  end record;

--****t* Stm32.DMA/DMA_Channel_Type
--
--  NAME
--    DMA_Channel_Type -- The channel of a DMA stream.
--  USAGE
--    Choose between :
--      * Channel_0 : For the channel 0 of a stream.
--      * Channel_1 : For the channel 1 of a stream.
--      * Channel_2 : For the channel 2 of a stream.
--      * Channel_3 : For the channel 3 of a stream.
--      * Channel_4 : For the channel 4 of a stream.
--      * Channel_5 : For the channel 5 of a stream.
--      * Channel_6 : For the channel 6 of a stream.
--      * Channel_7 : For the channel 7 of a stream.
--
--*****

  type DMA_Channel_Type is (
    Channel_0, Channel_1, Channel_2, Channel_3,
    Channel_4, Channel_5, Channel_6, Channel_7);
  for DMA_Channel_Type'Size use 32;
  for DMA_Channel_Type use (
    Channel_0 => 16#00000000#,
    Channel_1 => 16#02000000#,
    Channel_2 => 16#04000000#,
    Channel_3 => 16#06000000#,
    Channel_4 => 16#08000000#,
    Channel_5 => 16#0A000000#,
    Channel_6 => 16#0C000000#,
    Channel_7 => 16#0E000000#);

--****t* Stm32.DMA/Dir_Type
--
--  NAME
--    Dir_Type -- The transfert mode of a DMA.
--  USAGE
--    Choose between :
--      * Peripheral_To_Memory : Peripheral to memory transfert.
--      * Memory_To_Peripheral : Memory to peripheral transfert.
--      * Memory_To_Memory : Memory to memory transfert.
--
--*****

  type Dir_Type is (Peripheral_To_Memory, Memory_To_Peripheral,
                    Memory_To_Memory);
  for Dir_Type'Size use 32;
  for Dir_Type use (
    Peripheral_To_Memory => 16#00000000#,
    Memory_To_Peripheral => 16#00000040#,
    Memory_To_Memory     => 16#00000080#);

--****t* Stm32.DMA/Peripheral_Inc_Type
--
--  NAME
--    Peripheral_Inc_Type -- Automatically increments the peripheral address after transfert.
--  USAGE
--    Choose between :
--      * Disable : Disable the auto-increment.
--      * Enable : Enable the auto-increment.
--
--*****

  type Peripheral_Inc_Type is (Disable, Enable);
  for Peripheral_Inc_Type'Size use 32;
  for Peripheral_Inc_Type use (
    Disable => 16#00000000#,
    Enable  => 16#00000200#);

--****t* Stm32.DMA/Memory_Inc_Type
--
--  NAME
--    Memory_Inc_Type -- Automatically increments the memory address after transfert.
--  USAGE
--    Choose between :
--      * Disable : Disable the auto-increment.
--      * Enable : Enable the auto-increment.
--
--*****

  type Memory_Inc_Type is (Disable, Enable);
  for Memory_Inc_Type'Size use 32;
  for Memory_Inc_Type use (
    Disable => 16#00000000#,
    Enable  => 16#00000400#);

--****t* Stm32.DMA/Peripheral_Data_Size_Type.
--
--  NAME
--    Peripheral_Data_Size_Type -- Data width for a peripheral.
--  USAGE
--    Choose between :
--      * Byte : 8bits datas.
--      * Half_Word : 16bits datas.
--      * Word : 32bits datas.
--
--*****

  type Peripheral_Data_Size_Type is (Byte, Half_Word, Word);
  for Peripheral_Data_Size_Type'Size use 32;
  for Peripheral_Data_Size_Type use (
    Byte      => 16#00000000#,
    Half_Word => 16#00000800#,
    Word      => 16#00001000#);

--****t* Stm32.DMA/Memory_Data_Size_Type.
--
--  NAME
--    Memory_Data_Size_Type -- Data width for memory.
--  USAGE
--    Choose between :
--      * Byte : 8bits datas.
--      * Half_Word : 16bits datas.
--      * Word : 32bits datas.
--
--*****

  type Memory_Data_Size_Type is (Byte, Half_Word, Word);
  for Memory_Data_Size_Type'Size use 32;
  for Memory_Data_Size_Type use (
    Byte      => 16#00000000#,
    Half_Word => 16#00002000#,
    Word      => 16#00004000#);

--****t* Stm32.DMA/DMA_Mode_Type
--
--  NAME
--    DMA_Mode_Type -- The transfert type of the DMA.
--  USAGE
--    Choose between :
--      * Normal : Once the dma has done the given transfert size, the stream is disabled.
--      * Circular : For a circular buffer and continious datas flows.
--
--*****

  type DMA_Mode_Type is (Normal, Circular);
  for DMA_Mode_Type'Size use 32;
  for DMA_Mode_Type use (
    Normal   => 16#00000000#,
    Circular => 16#00000100#);

--****t* Stm32.DMA/Priority_Type
--
--  NAME
--    Priority_Type -- The priority of a stream.
--  USAGE
--    Choose between :
--      * Low : A low priority.
--      * Medium : A medium priority.
--      * High : A high priority.
--      * Very_High : A very high priority.
--
--*****

  type Priority_Type is (Low, Medium, High, Very_High);
  for Priority_Type'Size use 32;
  for Priority_Type use (
    Low       => 16#00000000#,
    Medium    => 16#00010000#,
    High      => 16#00020000#,
    Very_High => 16#00030000#);

--****t* Stm32.DMA/FIFO_Mode_Type
--
--  NAME
--    FIFO_Mode_Type -- The FIFO Mode activation status.
--  USAGE
--    Choose between :
--      * Disable : disable the fifo mode.
--      * Enable : Enable the fifo mode.
--
--*****

  type FIFO_Mode_Type is (Disable, Enable);
  for FIFO_Mode_Type'Size use 32;
  for FIFO_Mode_Type use (
    Disable => 16#00000000#,
    Enable  => 16#00000004#);

--****t* Stm32.DMA/Threshold_Type
--
--  NAME
--     Threshold_Type -- The threshold level of a fifo.
--  USAGE
--    Choose between :
--      * One_Quarter : A 1/4 fifo.
--      * Half : A 1/2 fifo.
--      * Three_Quarters : A 3/4 fifo.
--      * Full : A Full FIFO.
--
--*****

  type Threshold_Type is (One_Quarter, Half, Three_Quarters, Full);
  for Threshold_Type'Size use 32;
  for Threshold_Type use (
    One_Quarter    => 16#00000000#,
    Half           => 16#00000001#,
    Three_Quarters => 16#00000002#,
    Full           => 16#00000003#);

--****t* Stm32.DMA/Memory_Burst_Type
--
--  NAME
--    Memory_Burst_Type -- Memory burst transfert.
--  USAGE
--    It must correspond to the FIFO threshold in FIFO mode. Choose between :
--      * Single : transfer of a single word, corresponds to 1/4 of the fifo.
--      * Inc_4 : transfer of two words, corresponds to 1/2 of the fifo.
--      * Inc_8 : transfer of three words, corresponds to 3/4 of the fifo.
--      * Inc_16 : transfer of four words, corresponds to the full fifo.
--
--*****

  type Memory_Burst_Type is (Single, Inc_4, Inc_8, Inc_16);
  for Memory_Burst_Type'Size use 32;
  for Memory_Burst_Type use (
    Single => 16#00000000#,
    Inc_4  => 16#00800000#,
    Inc_8  => 16#01000000#,
    Inc_16 => 16#01800000#);

--****t* Stm32.DMA/Peripheral_Burst_Type
--
--  NAME
--    Peripheral_Burst_Type -- Peripheral burst transfert.
--  USAGE
--    It must correspond to the FIFO threshold in FIFO mode. Choose between :
--      * Single : transfer of a single word, corresponds to 1/4 of the fifo.
--      * Inc_4 : transfer of two words, corresponds to 1/2 of the fifo.
--      * Inc_8 : transfer of three words, corresponds to 3/4 of the fifo.
--      * Inc_16 : transfer of four words, corresponds to the full fifo.
--
--*****

  type Peripheral_Burst_Type is (Single, Inc_4, Inc_8, Inc_16);
  for Peripheral_Burst_Type'Size use 32;
  for Peripheral_Burst_Type use (
    Single => 16#00000000#,
    Inc_4  => 16#00200000#,
    Inc_8  => 16#00400000#,
    Inc_16 => 16#00600000#);

--****t* Stm32.DMA/DMA_Interrupt_Flag
--
--  NAME
--    DMA_Interrupt_Flag -- The DMA interrupt flags.
--  USAGE
--    Choose between :
--      * Transfer_Error : When a transfer error occurs.
--      * Half_Transfer_Complete : When half the transfer is achieved.
--      * Transfer_Complete : When the transfert is totally achieved.
--      * FIFO_Error : When there is an error with the FIFO.
--
--*****

  type DMA_Interrupt_Flag is (Transfer_Error, Half_Transfer_Complete,
                              Transfer_Complete, FIFO_Error);
  for DMA_Interrupt_Flag'Size use 32;
  for DMA_Interrupt_Flag use
    (Transfer_Error         => 16#00000004#,
     Half_Transfer_Complete => 16#00000008#,
     Transfer_Complete      => 16#00000010#,
     FIFO_Error             => 16#00000080#);

--****t* Stm32.DMA/DMA_Params
--
--  NAME
--    DMA_Params -- The parameters of a DMA.
--  USAGE
--    Define the following fields of the record :
--      * Channel : The channel of the stream, of type DMA_Channel_Type.
--      * Peripheral_Base_Addr : The base address of the peripheral, of type Address.
--      * Memory_Base_Addr : The base address of the memory, of type Address.
--      * Dir : The transfert mode, of type Dir_Type.
--      * Buffer_Size : An Unsigned_32 representing the size of the buffer.
--      * Peripheral_Inc : The kind of peripheral address increment, of type Peripheral_Inc_Type.
--      * Memory_Inc : The kinf of memory address increment, of type Peripheral_Inc_Type.
--      * Peripheral_Data_Size : The size of the peripheral datas, of type Peripheral_Data_Size_Type.
--      * Memory_Data_Size : The size of the memory datas, of type Memory_Data_Size_Type.
--      * Mode : The transfert type of the DMA, of type DMA_Mode_Type.
--      * Priority : The priority of a stream, of type Priority_Type.
--      * FIFO_Mode : Activation of the FIFO mode, of type FIFO_Mode_Type.
--      * FIFO_Threshold : The threshold of the fifo, of type Threshold_Type.
--      * Memory_Burst : The kind of memory burst, of type Memory_Burst_Type.
--      * Peripheral_Burst : The kind of peripheral burst, of type Peripheral_Burst_Type.
--  SEE ALSO
--    DMA_Channel_Type, Address, System/Dir_Type, Dir_Type, Peripheral_Inc_Type, Memory_Inc_Type, Peripheral_Data_Size_Type, Memory_Data_Size_Type, DMA_Mode_Type, Priority_Type, FIFO_Mode_Type, Threshold_Type, Memory_Burst_Type, Peripheral_Burst_Type
--
--*****

  type DMA_Params is record
    Channel : DMA_Channel_Type;
    Peripheral_Base_Addr : Address;
    Memory_Base_Addr : Address;
    Dir : Dir_Type;
    Buffer_Size : Unsigned_32;
    Peripheral_Inc : Peripheral_Inc_Type;
    Memory_Inc : Memory_Inc_Type;
    Peripheral_Data_Size : Peripheral_Data_Size_Type;
    Memory_Data_Size : Memory_Data_Size_Type;
    Mode : DMA_Mode_Type;
    Priority : Priority_Type;
    FIFO_Mode : FIFO_Mode_Type;
    FIFO_Threshold : Threshold_Type;
    Memory_Burst : Memory_Burst_Type;
    Peripheral_Burst : Peripheral_Burst_Type;
  end record;

--****f* Stm32.DMA/IRQ
--
--  NAME
--    IRQ -- Gives the interrupt of a DMA stream.
--  SYNOPSIS
--    IRQn := IRQ(DMA);
--  FUNCTION
--    Gives the interrupt of a given DMA stream.
--  INPUTS
--    DMA - The DMA stream, of type DMA_Stream_Type.
--  RESULT
--    IRQn - The interrupt, of type IRQn_Type.
--  SEE ALSO
--    DMA_Stream_Type, Stm32.NVIC/IRQn_Type.
--
--*****

  function IRQ (DMA : DMA_Stream_Type) return IRQn_Type;

--****f* Stm32.DMA/DMA_Init
--
--  NAME
--    DMA_Init -- Initializes a DMA stream.
--  SYNOPSIS
--    DMA_Init(DMA, Params);
--  FUNCTION
--    Initializes the DMA stream with the given parameters.
--  INPUTS
--    DMA - The DMA stream, of type DMA_Stream_Type.
--    Params - The parameters of the stream, of type DMA_Params.
--  SEE ALSO
--    DMA_Stream_Type, DMA_Params
--
--*****

  procedure DMA_Init (DMA : DMA_Stream_Type; Params : DMA_Params);

--****f* Stm32.DMA/Configure_DMA
--
--  NAME
--    Configure_DMA -- Enables or disables a DMA stream.
--  SYNOPSIS
--    Configure_DMA(DMA, State);
--  FUNCTION
--    Enables or disables a DMA stream.
--  INPUTS
--    DMA - The DMA stream, of type DMA_Stream_Type.
--    State - The state of the stream, of type FunctionalState.
--  SEE ALSO
--    DMA_Stream_Type, Stm32.Defines/FunctionalState
--
--*****

  procedure Configure_DMA (DMA : DMA_Stream_Type; State: FunctionalState);

--****f* Stm32.DMA/Start_Transfer
--
--  NAME
--    Start_Transfer - Start a DMA transfer.
--  SYNOPSIS
--    Start_Transfer(DMA, Memory_Address, Size);
--  FUNCTION
--    Start a transfer with the stream to a given address for a given size.
--  INPUTS
--    DMA - The DMA Stream, of type DMA_Stream_Type
--    Memory_Address - The new destination address, of type Address.
--    Size - An Integer representing the new size of the buffer.
--  SEE ALSO
--    DMA_Stream_Type, System/Address
--  
--*****

  procedure Start_Transfer (DMA : DMA_Stream_Type;
                            Memory_Address : Address;
                            Size : Integer);

--****f* Stm32.DMA/Is_Enable
--
--  NAME
--    Is_Enable -- Says if the DMA stream is currently enabled.
--  SYNOPSIS
--    Value := Is_Enable(DMA);
--  FUNCTION
--    Says whether a DMA stream is enabled or not.
--  INPUTS
--    DMA - The DMA stream, of type DMA_Stream_Type.
--  RESULT
--    Value - A Boolean representing if the stream is enabled or not.
--  SEE ALSO
--    DMA__Stream_Type
--
--*****

  function Is_Enable (DMA : DMA_Stream_Type) return Boolean;

--****f* Stm32.DMA/Configure_Interrupt
--
--  NAME
--    Configure_Interrupt -- Configures the interrupt for a stream.
--  SYNOPSIS
--    Configure_Interrupt(DMA, Flag, State);
--  FUNCTION
--    Activates or desactivates an interrupt for a DMA stream.
--  INPUTS
--    DMA - The DMA stream, of type DMA_Stream_Type.
--    Flag - The flag on which the interrupt triggers, of type DMA_Interrupt_Flag.
--    State - Enable or disable the interrupt, of type FunctionalState.
--  SEE ALSO
--    DMA_Stream_Type, DMA_Interrupt_Flag, Stm32.Defines/FunctionalState
--
--*****


  procedure Configure_Interrupt (DMA : DMA_Stream_Type;
                                 Flag : DMA_Interrupt_Flag;
                                 State : FunctionalState);

--****f* Stm32.DMA/Get_Interrupt_Flag
--
--  NAME
--    Get_Interrupt_Flag -- Gets the status of the flag of an interrupt.
--  SYNOPSIS
--    Value := Get_Interrupt_Flag(DMA, Flag);
--  FUNCTION
--    Gets the status of the flag linked to an interrupt.
--  INPUTS
--    DMA - The DMA stream, of type DMA_Stream_Type.
--    Flag - The flag to get, of type DMA_Interrupt_Flag.
--  RESULT
--    Value - A Boolean representing the value of the flag.
--  SEE ALSO
--    DMA_Stream_Type, DMA_Interrupt_Flag
--
--*****

  function Get_Interrupt_Flag (DMA : DMA_Stream_Type;
                               Flag : DMA_Interrupt_Flag)
      return Boolean;

--****f* Stm32.DMA/Clear_Interrupt_Flag
--
--  NAME
--    Clear_Interrupt_Flag -- Clear the flag of the interrupt.
--  SYNOPSIS
--    Clear_Interrupt_Flag(DMA, Flag);
--  FUNCTION
--    Clear the flag of the interrupt linked to the given flag.
--  INPUTS
--    DMA - The DMA stream, of type DMA_Stream_Type
--    Flag - The flag to clear, of type DMA_Interrupt_Flag.
--  SEE ALSO
--    DMA_Stream_Type, DMA_Interrupt_Flag
--
--*****

  procedure Clear_Interrupt_Flag (DMA : DMA_Stream_Type;
                                  Flag : DMA_Interrupt_Flag);

end Stm32.DMA;
