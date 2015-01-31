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

package body Stm32.ADC is

  Periph : constant array (ADC_Number) of Stm_Periph :=
    (ADC1, ADC2, ADC3);

  type ADC_TypeDef is new Unsigned_32;

  ADCs : constant array (ADC_Number) of ADC_TypeDef :=
    (ADC1_BASE, ADC2_BASE, ADC3_BASE);

  type DMA_Config is record
    Stream : DMA_Stream_Type;
    Channel : DMA_Channel_Type;
  end record;

  Streams : constant array (ADC_Number) of DMA_Config :=
    (((2, 0), Channel_0), ((2, 2), Channel_1), ((2, 1), Channel_2));

  -------------
  -- IMPORTS --
  -------------

  procedure ADC_DeInit;
  pragma Import (C, ADC_DeInit, "ADC_DeInit");

  procedure ADC_Init (ADC : ADC_TypeDef; Params : access ADC_Params);
  pragma Import (C, ADC_Init, "ADC_Init");

  procedure ADC_CommonInit (Params : access ADC_Common_Params);
  pragma Import (C, ADC_CommonInit, "ADC_CommonInit");

  procedure ADC_Cmd (ADC : ADC_TypeDef; State : FunctionalState);
  pragma Import (C, ADC_Cmd, "ADC_Cmd");

  procedure ADC_RegularChannelConfig (ADC : ADC_TypeDef;
                                      Channel : ADC_Channel_Number;
                                      Rank : Rank_Type;
                                      Sample_Time : Sample_Time_Type);
  pragma Import (C, ADC_RegularChannelConfig, "ADC_RegularChannelConfig");

  procedure ADC_SoftwareStartConv (ADC : ADC_TypeDef);
  pragma Import (C, ADC_SoftwareStartConv, "ADC_SoftwareStartConv");

  procedure ADC_DMACmd (ADC: ADC_TypeDef; State : FunctionalState);
  pragma Import (C, ADC_DMACmd, "ADC_DMACmd");

  procedure ADC_DMARequestAfterLastTransferCmd (ADC : ADC_TypeDef;
                                                State : FunctionalState);
  pragma Import (C, ADC_DMARequestAfterLastTransferCmd,
      "ADC_DMARequestAfterLastTransferCmd");

  procedure ITConfig (ADC : ADC_TypeDef;
                      IT  : ADC_IT;
                      State : FunctionalState);
  pragma Import (C, ITConfig, "ADC_ITConfig");

  ----------------------
  -- PUBLIC FUNCTIONS --
  ----------------------

  --------------
  -- ADC_Init --
  --------------

  procedure ADC_Init (ADC : ADC_Number; Params : ADC_Params) is
    P : aliased ADC_Params := Params;
  begin
    RCC_PeriphClockCmd (Periph (ADC), Enable);
    ADC_Init (ADCs (ADC), P'Access);
  end ADC_Init;

  ---------------------
  -- ADC_Init_Common --
  ---------------------

  procedure ADC_Init_Common (Params : ADC_Common_Params) is
    P : aliased ADC_Common_Params := Params;
  begin
    RCC_PeriphClockCmd (Stm32.RCC.ADC, Enable);
    ADC_DeInit;
    ADC_CommonInit(P'Access);
  end ADC_Init_Common;

  -------------------
  -- Configure_ADC --
  -------------------

  procedure Configure_ADC (ADC : ADC_Number; State : FunctionalState) is
  begin
    ADC_Cmd (ADCs (ADC), State);
  end Configure_ADC;

  -----------------------
  -- Configure_ADC_DMA --
  -----------------------

  procedure Configure_ADC_DMA (ADC : ADC_Number; State : FunctionalState) is
  begin
    ADC_DMACmd (ADCs (ADC), State);
    ADC_DMARequestAfterLastTransferCmd (ADCs (ADC), State);
  end Configure_ADC_DMA;

  ----------------------------
  -- Regular_Channel_Config --
  ----------------------------

  procedure Regular_Channel_Config (ADC : ADC_Number;
                                    Channel : ADC_Channel_Number;
                                    Rank : Rank_Type;
                                    Sample_Time : Sample_Time_Type) is
  begin
    ADC_RegularChannelConfig (ADCs (ADC), Channel, Rank, Sample_Time);
  end Regular_Channel_Config;

  ----------------
  -- Start_Conv --
  ----------------

  procedure Start_Conv (ADC : ADC_Number) is
  begin
    ADC_SoftwareStartConv (ADCs (ADC));
  end Start_Conv;

  -----------------------
  -- ADC_Data_Register --
  -----------------------

  function ADC_Data_Register (ADC : ADC_Number) return System.Address is
  begin
    return System'To_Address (ADCs (ADC) + 16#4C#);
  end ADC_Data_Register;

  ----------------
  -- DMA_Stream --
  ----------------

  function DMA_Stream (ADC : ADC_Number) return DMA_Stream_Type is
  begin
    return Streams (ADC).Stream;
  end DMA_Stream;

  function DMA_Channel (ADC : ADC_Number) return DMA_Channel_Type is
  begin
    return Streams (ADC).Channel;
  end DMA_Channel;

  -----------------------
  -- ADC_GetFlagStatus --
  -----------------------

  function ADC_GetFlagStatus (ADC : ADC_Number;
                              Flag : ADC_Flag) return Boolean is
    type Bit_Index is range 0..7;
    type Bool8 is array (Bit_Index) of Boolean;
    pragma Pack (Bool8);
    for Bool8'Size use 8;
    SR_Register : Bool8;
    for SR_Register'Address use System'To_Address(16#40012000# +
        (ADC_Number'Pos(ADC) - 1) * 16#0100#);
  begin
      if (SR_Register(ADC_Flag'Pos(Flag))) then
          return True;
      else
          return False;
      end if;
  end ADC_GetFlagStatus;

  procedure ADC_ClearFlag (ADC : ADC_Number;
                              Flag : ADC_Flag) is
    type Bit_Index is range 0..7;
    type Bool8 is array (Bit_Index) of Boolean;
    pragma Pack (Bool8);
    for Bool8'Size use 8;
    SR_Register : Bool8;
    for SR_Register'Address use System'To_Address(16#40012000# +
        (ADC_Number'Pos(ADC) - 1) * 16#0100#);
  begin
      SR_Register(ADC_Flag'Pos(Flag)) := False;
  end ADC_ClearFlag;

  function ADC_GetConversionValue (ADC : ADC_Number) return Unsigned_16 is
    DR_Register : Unsigned_16;
    for DR_Register'Address use System'To_Address(16#40012000# +
        (ADC_Number'Pos(ADC) - 1) * 16#0100# + 16#004C#);
  begin
    return DR_Register;
  end ADC_GetConversionValue;

  procedure ADC_ITConfig (ADC    : ADC_Number;
                          IT : ADC_IT;
                          State : FunctionalState) is
  begin
    ITConfig(ADCs(ADC), IT, State);
  end ADC_ITConfig;
end Stm32.ADC;
