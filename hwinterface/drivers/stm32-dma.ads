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

package Stm32.DMA is

  type DMA_Stream_Type is record
    DMA : Integer range 1 .. 2;
    Stream : Integer range 0 .. 7;
  end record;

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

  type Dir_Type is (Peripheral_To_Memory, Memory_To_Peripheral,
                    Memory_To_Memory);
  for Dir_Type'Size use 32;
  for Dir_Type use (
    Peripheral_To_Memory => 16#00000000#,
    Memory_To_Peripheral => 16#00000040#,
    Memory_To_Memory     => 16#00000080#);

  type Peripheral_Inc_Type is (Disable, Enable);
  for Peripheral_Inc_Type'Size use 32;
  for Peripheral_Inc_Type use (
    Disable => 16#00000000#,
    Enable  => 16#00000200#);

  type Memory_Inc_Type is (Disable, Enable);
  for Memory_Inc_Type'Size use 32;
  for Memory_Inc_Type use (
    Disable => 16#00000000#,
    Enable  => 16#00000400#);

  type Peripheral_Data_Size_Type is (Byte, Half_Word, Word);
  for Peripheral_Data_Size_Type'Size use 32;
  for Peripheral_Data_Size_Type use (
    Byte      => 16#00000000#,
    Half_Word => 16#00000800#,
    Word      => 16#00001000#);

  type Memory_Data_Size_Type is (Byte, Half_Word, Word);
  for Memory_Data_Size_Type'Size use 32;
  for Memory_Data_Size_Type use (
    Byte      => 16#00000000#,
    Half_Word => 16#00002000#,
    Word      => 16#00004000#);

  type DMA_Mode_Type is (Normal, Circular);
  for DMA_Mode_Type'Size use 32;
  for DMA_Mode_Type use (
    Normal   => 16#00000000#,
    Circular => 16#00000100#);

  type Priority_Type is (Low, Medium, High, Very_High);
  for Priority_Type'Size use 32;
  for Priority_Type use (
    Low       => 16#00000000#,
    Medium    => 16#00010000#,
    High      => 16#00020000#,
    Very_High => 16#00030000#);

  type FIFO_Mode_Type is (Disable, Enable);
  for FIFO_Mode_Type'Size use 32;
  for FIFO_Mode_Type use (
    Disable => 16#00000000#,
    Enable  => 16#00000004#);

  type Threshold_Type is (One_Quarter, Half, Three_Quarters, Full);
  for Threshold_Type'Size use 32;
  for Threshold_Type use (
    One_Quarter    => 16#00000000#,
    Half           => 16#00000001#,
    Three_Quarters => 16#00000002#,
    Full           => 16#00000003#);

  type Memory_Burst_Type is (Single, Inc_4, Inc_8, Inc_16);
  for Memory_Burst_Type'Size use 32;
  for Memory_Burst_Type use (
    Single => 16#00000000#,
    Inc_4  => 16#00800000#,
    Inc_8  => 16#01000000#,
    Inc_16 => 16#01800000#);

  type Peripheral_Burst_Type is (Single, Inc_4, Inc_8, Inc_16);
  for Peripheral_Burst_Type'Size use 32;
  for Peripheral_Burst_Type use (
    Single => 16#00000000#,
    Inc_4  => 16#00200000#,
    Inc_8  => 16#00400000#,
    Inc_16 => 16#00600000#);

  type DMA_Interrupt_Flag is (Transfer_Error, Half_Transfer_Complete,
                              Transfer_Complete, FIFO_Error);
  for DMA_Interrupt_Flag'Size use 32;
  for DMA_Interrupt_Flag use
    (Transfer_Error         => 16#00000004#,
     Half_Transfer_Complete => 16#00000008#,
     Transfer_Complete      => 16#00000010#,
     FIFO_Error             => 16#00000080#);

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

  function IRQ (DMA : DMA_Stream_Type) return IRQn_Type;

  procedure DMA_Init (DMA : DMA_Stream_Type; Params : DMA_Params);

  procedure Configure_DMA (DMA : DMA_Stream_Type; State: FunctionalState);

  procedure Start_Transfer (DMA : DMA_Stream_Type;
                            Memory_Address : Address;
                            Size : Integer);

  function Is_Enable (DMA : DMA_Stream_Type) return Boolean;

  procedure Configure_Interrupt (DMA : DMA_Stream_Type;
                                 Flag : DMA_Interrupt_Flag;
                                 State : FunctionalState);

  function Get_Interrupt_Flag (DMA : DMA_Stream_Type;
                               Flag : DMA_Interrupt_Flag)
      return Boolean;

  procedure Clear_Interrupt_Flag (DMA : DMA_Stream_Type;
                                  Flag : DMA_Interrupt_Flag);

end Stm32.DMA;
