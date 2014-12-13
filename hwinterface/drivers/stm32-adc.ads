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
with System;

package Stm32.ADC is

  type ADC_Number is new Integer range 1 .. 3;

  type ADC_Channel_Number is new Integer range 1 .. 18;

  type Resolution_Type is (Resolution_12b, Resolution_10b,
                           Resolution_8b, Resolution_6b);
  for Resolution_Type'Size use 32;
  for Resolution_Type use (
    Resolution_12b => 16#00000000#,
    Resolution_10b => 16#10000000#,
    Resolution_8b  => 16#20000000#,
    Resolution_6b  => 16#30000000#);

  type External_Trigger_Edge_Type is (None, Rising, Falling, Rising_Falling);
  for External_Trigger_Edge_Type'Size use 32;
  for External_Trigger_Edge_Type use (
    None           => 16#00000000#,
    Rising         => 16#10000000#,
    Falling        => 16#20000000#,
    Rising_Falling => 16#30000000#);

  type External_Trigger_Source_Type is (T1_CC1, T1_CC2, T1_CC3, T2_CC2,
                                        T2_CC3, T2_CC4, T2_TRGO, T3_CC1,
                                        T3_TRGO, T4_CC4, T5_CC1, T5_CC2,
                                        T5_CC3, T8_CC1, T8_TRGO, Ext_IT11);
  for External_Trigger_Source_Type'Size use 32;
  for External_Trigger_Source_Type use (
    T1_CC1   => 16#00000000#,
    T1_CC2   => 16#01000000#,
    T1_CC3   => 16#02000000#,
    T2_CC2   => 16#03000000#,
    T2_CC3   => 16#04000000#,
    T2_CC4   => 16#05000000#,
    T2_TRGO  => 16#06000000#,
    T3_CC1   => 16#07000000#,
    T3_TRGO  => 16#08000000#,
    T4_CC4   => 16#09000000#,
    T5_CC1   => 16#0A000000#,
    T5_CC2   => 16#0B000000#,
    T5_CC3   => 16#0C000000#,
    T8_CC1   => 16#0D000000#,
    T8_TRGO  => 16#0E000000#,
    Ext_IT11 => 16#0F000000#);

  type Data_Align_Type is (Right, Left);
  for Data_Align_Type'Size use 32;
  for Data_Align_Type use (
    Right => 16#00000000#,
    Left  => 16#00000800#);

  type Nbr_Of_Conversion_Type is new Unsigned_8 range 1 .. 8;

  type Mode_Type is (Mode_Independent, DualMode_RegSimult_InjecSimult,
                     DualMode_RegSimult_AlterTrig, DualMode_InjecSimult,
                     DualMode_RegSimult, DualMode_Interl,
                     DualMode_AlterTrig, TripleMode_RegSimult_InjecSimult,
                     TripleMode_RegSimult_AlterTrig, TripleMode_InjecSimult,
                     TripleMode_RegSimult, TripleMode_Interl,
                     TripleMode_AlterTrig);
  for Mode_Type'Size use 32;
  for Mode_Type use (
    Mode_Independent                 => 16#00000000#,
    DualMode_RegSimult_InjecSimult   => 16#00000001#,
    DualMode_RegSimult_AlterTrig     => 16#00000002#,
    DualMode_InjecSimult             => 16#00000005#,
    DualMode_RegSimult               => 16#00000006#,
    DualMode_Interl                  => 16#00000007#,
    DualMode_AlterTrig               => 16#00000009#,
    TripleMode_RegSimult_InjecSimult => 16#00000011#,
    TripleMode_RegSimult_AlterTrig   => 16#00000012#,
    TripleMode_InjecSimult           => 16#00000015#,
    TripleMode_RegSimult             => 16#00000016#,
    TripleMode_Interl                => 16#00000017#,
    TripleMode_AlterTrig             => 16#00000019#);

  type Prescaler_Type is (Div_2, Div_4, Div_6, Div_8);
  for Prescaler_Type'Size use 32;
  for Prescaler_Type use (
    Div_2 => 16#00000000#,
    Div_4 => 16#00010000#,
    Div_6 => 16#00020000#,
    Div_8 => 16#00030000#);

  type DMA_Mode_Type is (Disabled, Mode_1, Mode_2, Mode_3);
  for DMA_Mode_Type'Size use 32;
  for DMA_Mode_Type use (
    Disabled => 16#00000000#,
    Mode_1   => 16#00004000#,
    Mode_2   => 16#00008000#,
    Mode_3   => 16#0000C000#);

  type Two_Sampling_Delay_Type is (Delay_5Cycles, Delay_6Cycles,
                                   Delay_7Cycles, Delay_8Cycles,
                                   Delay_9Cycles, Delay_10Cycles,
                                   Delay_11Cycles, Delay_12Cycles,
                                   Delay_13Cycles, Delay_14Cycles,
                                   Delay_15Cycles, Delay_16Cycles,
                                   Delay_17Cycles, Delay_18Cycles,
                                   Delay_19Cycles, Delay_20Cycles);
  for Two_Sampling_Delay_Type'Size use 32;
  for Two_Sampling_Delay_Type use (
    Delay_5Cycles  => 16#00000000#,
    Delay_6Cycles  => 16#00000100#,
    Delay_7Cycles  => 16#00000200#,
    Delay_8Cycles  => 16#00000300#,
    Delay_9Cycles  => 16#00000400#,
    Delay_10Cycles => 16#00000500#,
    Delay_11Cycles => 16#00000600#,
    Delay_12Cycles => 16#00000700#,
    Delay_13Cycles => 16#00000800#,
    Delay_14Cycles => 16#00000900#,
    Delay_15Cycles => 16#00000A00#,
    Delay_16Cycles => 16#00000B00#,
    Delay_17Cycles => 16#00000C00#,
    Delay_18Cycles => 16#00000D00#,
    Delay_19Cycles => 16#00000E00#,
    Delay_20Cycles => 16#00000F00#);

  type Rank_Type is new Integer range 1 .. 16;

  type Sample_Time_Type is (Sample_Time_3Cycles, Sample_Time_15Cycles,
                            Sample_Time_28Cycles, Sample_Time_56Cycles,
                            Sample_Time_84Cycles, Sample_Time_112Cycles,
                            Sample_Time_144Cycles, Sample_Time_480Cycles);
  for Sample_Time_Type'Size use 8;
  for Sample_Time_Type use (
    Sample_Time_3Cycles   => 16#00#,
    Sample_Time_15Cycles  => 16#01#,
    Sample_Time_28Cycles  => 16#02#,
    Sample_Time_56Cycles  => 16#03#,
    Sample_Time_84Cycles  => 16#04#,
    Sample_Time_112Cycles => 16#05#,
    Sample_Time_144Cycles => 16#06#,
    Sample_Time_480Cycles => 16#07#);

  type ADC_Params is record
    Resolution : Resolution_Type;
    Scan_Conv_Mode : FunctionalState;
    Continuous_Conv_Mode : FunctionalState;
    External_Trig_Conv_Edge : External_Trigger_Edge_Type;
    External_Trig_Conv : External_Trigger_Source_Type;
    Data_Align : Data_Align_Type;
    Nbr_Of_Conversion : Nbr_Of_Conversion_Type;
  end record;

  type ADC_Common_Params is record
    Mode : Mode_Type;
    Prescaler : Prescaler_Type;
    DMA_Access_Mode : DMA_Mode_Type;
    Two_Sampling_Delay : Two_Sampling_Delay_Type;
  end record;

  procedure ADC_Init (ADC : ADC_Number; Params : ADC_Params);

  procedure ADC_Init_Common (Params : ADC_Common_Params);

  procedure Configure_ADC (ADC : ADC_Number; State : FunctionalState);

  procedure Configure_ADC_DMA (ADC : ADC_Number; State : FunctionalState);

  procedure Regular_Channel_Config (ADC : ADC_Number;
                                    Channel : ADC_Channel_Number;
                                    Rank : Rank_Type;
                                    Sample_Time : Sample_Time_Type);

  procedure Start_Conv (ADC : ADC_Number);

  function ADC_Data_Register (ADC : ADC_Number) return System.Address;

  function DMA_Stream (ADC : ADC_Number) return DMA_Stream_Type;

  function DMA_Channel (ADC : ADC_Number) return DMA_Channel_Type;

end Stm32.ADC;
