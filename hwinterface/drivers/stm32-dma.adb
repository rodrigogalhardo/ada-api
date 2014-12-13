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

package body Stm32.DMA is

  Periph : constant array (1 .. 2) of Stm_Periph :=
    (1 => DMA1,
     2 => DMA2);

  type DMA_TypeDef is new Unsigned_32;

  DMAs : constant array (1 .. 2, 0 .. 7) of DMA_TypeDef :=
    (1 => (DMA1_Stream0_BASE, DMA1_Stream1_BASE,
           DMA1_Stream2_BASE, DMA1_Stream3_BASE,
           DMA1_Stream4_BASE, DMA1_Stream5_BASE,
           DMA1_Stream6_BASE, DMA1_Stream7_BASE),
     2 => (DMA2_Stream0_BASE, DMA2_Stream1_BASE,
           DMA2_Stream2_BASE, DMA2_Stream3_BASE,
           DMA2_Stream4_BASE, DMA2_Stream5_BASE,
           DMA2_Stream6_BASE, DMA2_Stream7_BASE));

  IRQs : constant array (1 .. 2, 0 .. 7) of IRQn_Type :=
    (1 => (DMA1_Stream0_IRQn, DMA1_Stream1_IRQn,
           DMA1_Stream2_IRQn, DMA1_Stream3_IRQn,
           DMA1_Stream4_IRQn, DMA1_Stream5_IRQn,
           DMA1_Stream6_IRQn, DMA1_Stream7_IRQn),
     2 => (DMA2_Stream0_IRQn, DMA2_Stream1_IRQn,
           DMA2_Stream2_IRQn, DMA2_Stream3_IRQn,
           DMA2_Stream4_IRQn, DMA2_Stream5_IRQn,
           DMA2_Stream6_IRQn, DMA2_Stream7_IRQn));

  DMA_ITs : constant array (0 .. 7, DMA_Interrupt_Flag) of Unsigned_32 :=
    (0 => (
      Transfer_Error =>         16#10002008#,
      Half_Transfer_Complete => 16#10004010#,
      Transfer_Complete =>      16#10008020#,
      FIFO_Error =>             16#90000001#),
     1 => (
      Transfer_Error =>         16#10002200#,
      Half_Transfer_Complete => 16#10004400#,
      Transfer_Complete =>      16#10008800#,
      FIFO_Error =>             16#90000040#),
     2 => (
      Transfer_Error =>         16#10082000#,
      Half_Transfer_Complete => 16#10104000#,
      Transfer_Complete =>      16#10208000#,
      FIFO_Error =>             16#90010000#),
     3 => (
      Transfer_Error =>         16#12002000#,
      Half_Transfer_Complete => 16#14004000#,
      Transfer_Complete =>      16#18008000#,
      FIFO_Error =>             16#90400000#),
     4 => (
      Transfer_Error =>         16#20002008#,
      Half_Transfer_Complete => 16#20004010#,
      Transfer_Complete =>      16#20008020#,
      FIFO_Error =>             16#A0000001#),
     5 => (
      Transfer_Error =>         16#20002200#,
      Half_Transfer_Complete => 16#20004400#,
      Transfer_Complete =>      16#20008800#,
      FIFO_Error =>             16#A0000040#),
     6 => (
      Transfer_Error =>         16#20082000#,
      Half_Transfer_Complete => 16#20104000#,
      Transfer_Complete =>      16#20208000#,
      FIFO_Error =>             16#A0010000#),
     7 => (
      Transfer_Error =>         16#22002000#,
      Half_Transfer_Complete => 16#24004000#,
      Transfer_Complete =>      16#28008000#,
      FIFO_Error =>             16#A0400000#));

  -------------
  -- Imports --
  -------------

  procedure DMA_DeInit (DMA : DMA_TypeDef);
  pragma Import (C, DMA_DeInit, "DMA_DeInit");

  procedure DMA_Init (DMA : DMA_TypeDef; Params : access DMA_Params);
  pragma Import (C, DMA_Init, "DMA_Init");

  procedure DMA_Cmd (DMA : DMA_TypeDef; State : FunctionalState);
  pragma Import (C, DMA_Cmd, "DMA_Cmd");

  procedure DMA_SetCurrDataCounter (DMA : DMA_TypeDef; Counter : Unsigned_16);
  pragma Import (C, DMA_SetCurrDataCounter, "DMA_SetCurrDataCounter");

  function DMA_GetCmdStatus (DMA : DMA_TypeDef) return FunctionalState;
  pragma Import (C, DMA_GetCmdStatus, "DMA_GetCmdStatus");

  procedure DMA_ITConfig (DMA : DMA_TypeDef; Flag : DMA_Interrupt_Flag;
                          State : FunctionalState);
  pragma Import (C, DMA_ITConfig, "DMA_ITConfig");

  function DMA_GetITStatus (DMA : DMA_TypeDef; Flag : Unsigned_32)
      return FunctionalState;
  pragma Import (C, DMA_GetITStatus, "DMA_GetITStatus");

  procedure DMA_ClearITPendingBit (DMA : DMA_TypeDef; Flag : Unsigned_32);
  pragma Import (C, DMA_ClearITPendingBit, "DMA_ClearITPendingBit");

  ----------------------
  -- PUBLIC FUNCTIONS --
  ----------------------

  ---------
  -- IRQ --
  ---------

  function IRQ (DMA : DMA_Stream_Type) return IRQn_Type is
  begin
    return IRQs (DMA.DMA, DMA.Stream);
  end IRQ;

  --------------
  -- DMA_Init --
  --------------

  procedure DMA_Init (DMA : DMA_Stream_Type; Params : DMA_Params) is
    P : aliased DMA_Params := Params;
    D : constant DMA_TypeDef := DMAs (DMA.DMA, DMA.Stream);
  begin
    RCC_PeriphClockCmd (Periph (DMA.DMA), Enable);
    DMA_DeInit (D);
    DMA_Init (D, P'Access);
  end DMA_Init;

  -------------------
  -- Configure_DMA --
  -------------------

  procedure Configure_DMA (DMA : DMA_Stream_Type; State : FunctionalState) is
  begin
    DMA_Cmd (DMAs (DMA.DMA, DMA.Stream), State);
  end Configure_DMA;

  --------------------
  -- Start_Transfer --
  --------------------

  procedure Start_Transfer (DMA : DMA_Stream_Type;
                            Memory_Address : Address;
                            Size : Integer) is
    M0AR : Address;
    for M0AR'Address use System'To_Address (DMAs (DMA.DMA, DMA.Stream) + 12);
  begin
    DMA_SetCurrDataCounter (DMAs (DMA.DMA, DMA.Stream), Unsigned_16 (Size));
    M0AR := Memory_Address;
    Configure_DMA (DMA, Enable);
  end Start_Transfer;

  function Is_Enable (DMA : DMA_Stream_Type) return Boolean is
  begin
    return DMA_GetCmdStatus (DMAs (DMA.DMA, DMA.Stream)) /= Disable;
  end Is_Enable;

  -------------------------
  -- Configure_Interrupt --
  -------------------------

  procedure Configure_Interrupt (DMA : DMA_Stream_Type;
                                 Flag : DMA_Interrupt_Flag;
                                 State : FunctionalState) is
  begin
    DMA_ITConfig (DMAs (DMA.DMA, DMA.Stream), Flag, State);
  end Configure_Interrupt;

  ------------------------
  -- Get_Interrupt_Flag --
  ------------------------

  function Get_Interrupt_Flag (DMA : DMA_Stream_Type;
                               Flag : DMA_Interrupt_Flag)
      return Boolean is
    DMA_IT : constant Unsigned_32 := DMA_ITs (DMA.Stream, Flag);
  begin
    return DMA_GetITStatus (DMAs (DMA.DMA, DMA.Stream), DMA_IT) /= Disable;
  end Get_Interrupt_Flag;

  --------------------------
  -- Clear_Interrupt_Flag --
  --------------------------

  procedure Clear_Interrupt_Flag (DMA : DMA_Stream_Type;
                                  Flag : DMA_Interrupt_Flag) is
    DMA_IT : constant Unsigned_32 := DMA_ITs (DMA.Stream, Flag);
  begin
    DMA_ClearITPendingBit (DMAs (DMA.DMA, DMA.Stream), DMA_IT);
  end Clear_Interrupt_Flag;

end Stm32.DMA;
