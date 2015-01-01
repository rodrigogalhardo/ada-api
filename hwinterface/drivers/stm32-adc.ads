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

--****c* Stm32.ADC/Stm32.ADC
--
--  NAME
--    Stm32.ADC -- Package for Analog to Digital Converter.
--  COPYRIGHT
--    (c) 2014 by Julien Brette & Julien Romero
--  SYNOPSIS
--    with Stm32.ADC;
--  DESCRIPTION
--    Thanks to this package, you can manage analog to numeric conversions.
--  AUTHOR
--    Julien Brette & Julien Romero
--  USES
--    Interfaces, Stm32.Defines, Stm32.DMA, System
--*****

package Stm32.ADC is

--****t* Stm32.ADC/ADC_Number
--
--  NAME
--    ADC_Number -- The number of the ADC peripheral.
--  USAGE
--    An Integer between 1 and 3 (included).
--
--*****

  type ADC_Number is new Integer range 1 .. 3;

--****t* Stm32.ADC/ADC_Channel_Number
--
--  NAME
--    ADC_Channel_Number -- The number of an ADC channel.
--  USAGE
--    An integer between 1 and 18 (included).
--
--*****

  type ADC_Channel_Number is new Integer range 1 .. 18;

--****t* Stm32.ADC/Resolution_Type
--
--  NAME
--    Resolution_Type -- The ADC resolution dual mode.
--  USAGE
--    Choose between the following resolutions :
--      * Resolution_12b : A 12 bits resolution.
--      * Resolution_10b : A 10 bits resolution.
--      * Resolution_8b : A 8 bits resolution.
--      * Resolution_6b : A 6 bits resolution.
--
--*****

  type Resolution_Type is (Resolution_12b, Resolution_10b,
                           Resolution_8b, Resolution_6b);
  for Resolution_Type'Size use 32;
  for Resolution_Type use (
    Resolution_12b => 16#00000000#,
    Resolution_10b => 16#10000000#,
    Resolution_8b  => 16#20000000#,
    Resolution_6b  => 16#30000000#);

--****t* Stm32.ADC/External_Trigger_Edge_Type
--
--  NAME
--    External_Trigger_Edge_Type -- The external trigger edge.
--  USAGE
--    Choose between :
--      * None : Disables the trigger.
--      * Rising : Triggers on rising edge.
--      * Falling : Triggers on falling edge.
--      * Rising_Falling : Triggers on both rising and falling edge.
--
--*****

  type External_Trigger_Edge_Type is (None, Rising, Falling, Rising_Falling);
  for External_Trigger_Edge_Type'Size use 32;
  for External_Trigger_Edge_Type use (
    None           => 16#00000000#,
    Rising         => 16#10000000#,
    Falling        => 16#20000000#,
    Rising_Falling => 16#30000000#);

--****t* Stm32.ADC/External_Trigger_Source_Type
--
--  NAME
--    External_Trigger_Source_Type -- The external event used to trigger the start of conversion of a regular group.
--  USAGE
--    Choose between :
--      * T1_CC1 : Timer 1 channel 1 signal
--      * T1_CC2 : Timer 1 channel 2 signal
--      * T1_CC3 : Timer 1 channel 3 signal
--      * T1_CC4 : Timer 1 channel 4 signal
--      * T2_TRGO : Timer 2 TRGO signal
--      * T3_CC1 : Timer 3 channel 1 signal
--      * T4_CC4 : Timer 4 channel 4 signal
--      * T5_CC1 : Timer 5 channel 1 signal
--      * T5_CC2 : Timer 5 channel 2 signal
--      * T5_CC3 : Timer 5 channel 3 signal
--      * T8_CC1 : Timer 8 channel 1 signal
--      * T8_TRGO : Timer 8 TRGO signal.
--      * Ext_IT11 : External pin event.
--
--*****

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

--****t* Stm32.ADC/Data_Align_Type
--
--  NAME
--    Data_Align_Type -- The data alignment.
--  USAGE
--    Choose between :
--      * Right : A right alignment.
--      * Left : A left alignment
--
--*****

  type Data_Align_Type is (Right, Left);
  for Data_Align_Type'Size use 32;
  for Data_Align_Type use (
    Right => 16#00000000#,
    Left  => 16#00000800#);

--****t* Stm32.ADC/Nbr_Of_Conversion_Type
--
--  NAME
--    Nbr_Of_Conversion_Type -- Number of ADC conversion that will be done using the sequencer for regular channel group.
--  USAGE
--    An Integer between 1 and 8 included.
--
--*****

  type Nbr_Of_Conversion_Type is new Unsigned_8 range 1 .. 8;

--****t* Stm32.ADC/Mode_Type
--
--  NAME
--    Mode_Type -- ADC mode (independent or multi mode)
--  USAGE
--    Choose between :
--      * Mode_Independent
--      * DualMode_RegSimult_InjecSimult
--      * DualMode_RegSimult_AlterTrig
--      * DualMode_InjecSimult
--      * DualMode_RegSimult
--      * DualMode_Interl
--      * DualMode_AlterTrig
--      * TripleMode_RegSimult_InjecSimult
--      * TripleMode_RegSimult_AlterTrig
--      * TripleMode_InjecSimult
--      * TripleMode_RegSimult
--      * TripleMode_Interl
--      * TripleMode_AlterTrig
--
--*****

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

--****t* Stm32.ADC/Prescaler_Type
--
--  NAME
--    Prescaler_Type -- Division of the common ADC clock.
--  USAGE
--    Choose between :
--      * Div_2 : Divises the clock by 2.
--      * Div_4 : Divises the clock by 4.
--      * Div_6 : Divises the clock by 6.
--      * Div_8 : Divises the clock by 8.
--
--*****


  type Prescaler_Type is (Div_2, Div_4, Div_6, Div_8);
  for Prescaler_Type'Size use 32;
  for Prescaler_Type use (
    Div_2 => 16#00000000#,
    Div_4 => 16#00010000#,
    Div_6 => 16#00020000#,
    Div_8 => 16#00030000#);

--****t* Stm32.ADC/DMA_Mode_Type
--
--  NAME
--    DMA_Mode_Type -- The DMA mode for multi ADC mode.
--  USAGE
--    Choose between :
--      * Disable : Disable DMA
--      * Mode_1 : A Half-word transfered for each DMA request.
--      * Mode_2 : Two half-words transfered for each DMA request.
--      * Mode_3 : A half-word transfered for each DMA request but composed of two differents conversions.
--
--*****

  type DMA_Mode_Type is (Disabled, Mode_1, Mode_2, Mode_3);
  for DMA_Mode_Type'Size use 32;
  for DMA_Mode_Type use (
    Disabled => 16#00000000#,
    Mode_1   => 16#00004000#,
    Mode_2   => 16#00008000#,
    Mode_3   => 16#0000C000#);

--****t* Stm32.ADC/Two_Sampling_Delay_Type
--
--  NAME
--    Two_Sampling_Delay_Type -- The delay between two sampling phases.
--  USAGE
--    Choose between :
--      * Delay_5Cycles
--      * Delay_6Cycles
--      * Delay_7Cycles
--      * Delay_8Cycles
--      * Delay_9Cycles
--      * Delay_10Cycles
--      * Delay_11Cycles
--      * Delay_12Cycles
--      * Delay_13Cycles
--      * Delay_14Cycles
--      * Delay_15Cycles
--      * Delay_16Cycles
--      * Delay_17Cycles
--      * Delay_18Cycles
--      * Delay_19Cycles
--      * Delay_20Cycles
--
--*****

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

--****t* Stm32.ADC/Rank_Type
--
--  NAME
--    The rank in the regular group sequencer.
--  USAGE
--    An Integer between 1 and 16.
--
--*****

  type Rank_Type is new Integer range 1 .. 16;

--****t* Stm32.ADC/Sample_Time_Type
--
--  NAME
--    Sample_Time_Type -- A sample time value.
--  USAGE
--    Choose between :
--      * Sample_Time_3Cycles
--      * Sample_Time_15Cycles
--      * Sample_Time_28Cycles
--      * Sample_Time_56Cycles
--      * Sample_Time_84Cycles
--      * Sample_Time_112Cycles
--      * Sample_Time_144Cycles
--      * Sample_Time_480Cycles
--
--*****

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

--****t* Stm32.ADC/ADC_Params
--
--  NAME
--    ADC_Params - The parameters of an ADC.
--  USAGE
--    Define the following fields of the record :
--      * Resolution : The resolution of the conversion, of type Resolution_Type
--      * Scan_Conv_Mode : Whether the conversion is performed in Scan (multichannels) or Single (one channel) mode, of type FunctionalState.
--      * Continuous_Conv_Mode : Continuous or Single mode, of type FunctionalState.
--      * External_Trig_Conv_Edge : Select external trigger edge, of type External_Trigger_Edge_Type.
--      * External_Trig_Conv : The event used to trigger, of type External_Trigger_Source_Type.
--      * Data_Align : The align of the data, of type Data_Align_Type.
--      * Nbr_Of_Conversion : The number of conversions, of type Nbr_Of_Conversion_Type.
--  SEE ALSO
--    Resolution_Type, Stm32.Defines/FunctionalState, External_Trigger_Edge_Type, External_Trigger_Source_Type, Data_Align_Type, Nbr_Of_Conversion_Type
--
--*****

  type ADC_Params is record
    Resolution : Resolution_Type;
    Scan_Conv_Mode : FunctionalState;
    Continuous_Conv_Mode : FunctionalState;
    External_Trig_Conv_Edge : External_Trigger_Edge_Type;
    External_Trig_Conv : External_Trigger_Source_Type;
    Data_Align : Data_Align_Type;
    Nbr_Of_Conversion : Nbr_Of_Conversion_Type;
  end record;

--****t* Stm32.ADC/ADC_Common_Params
--
--  NAME
--    ADC_Common_Params -- The common parameters of the ADCs.
--  USAGE
--    Define the following fields of the record :
--      * Mode : The mode of the ADC, Mode_Type.
--      * Prescaler : The clock divider, of type Prescaler_Type.
--      * DMA_Access_Mode : The DMA access mode, of type DMA_Mode_Type.
--      * Two_Sampling_Delay : The delay between two samplings, of type Two_Sampling_Delay_Type.
--  SEE ALSO
--    Mode_Type, Prescaler_Type, DMA_Mode_Type, Two_Sampling_Delay_Type
--
--*****

  type ADC_Common_Params is record
    Mode : Mode_Type;
    Prescaler : Prescaler_Type;
    DMA_Access_Mode : DMA_Mode_Type;
    Two_Sampling_Delay : Two_Sampling_Delay_Type;
  end record;

--****f* Stm32.ADC/ADC_Init
--
--  NAME
--    ADC_Init -- Initializes an ADC.
--  SYNOPSIS
--    ADC_Inti(ADC, Params);
--  FUNCTION
--    Initializes an ADC with the given parameters.
--  INPUTS
--    ADC - The ADC number, of type ADC_Number.
--    Params - The parameters of the ADC, of type ADC_Params.
--  SEE ALSO
--    ADC_Number, ADC_Params
--
--*****

  procedure ADC_Init (ADC : ADC_Number; Params : ADC_Params);

--****f* Stm32.ADC/ADC_Init_Common
--
--  NAME
--    ADC_Init_Common -- Initializes the common parameters of ADCs.
--  SYNOPSIS
--    ADC_Init_Common(Params);
--  FUNCTION
--    Initializes the common parameters of ADCs.
--  INPUTS
--    Params - The common parameters, of type ADC_Common_Params.
--  SEE ALSO
--    ADC_Common_Params
--
--*****

  procedure ADC_Init_Common (Params : ADC_Common_Params);

--****f* Stm32.ADC/Configure_ADC
--
--  NAME
--    Configure_ADC -- Enables or disables an ADC.
--  SYNOPSIS
--    Configure_ADC(ADC, State);
--  FUNCTION
--    Enables or disables the given ADC.
--  INPUTS
--    ADC - The ADC number, of type ADC_Number.
--    State - Activation of ADC, of type FunctionalState.
--  SEE ALSO
--    ADC_Number, Stm23.Defines/FunctionalState
--
--*****

  procedure Configure_ADC (ADC : ADC_Number; State : FunctionalState);

--****f* Stm32.ADC/Configure_ADC_DMA
--
--  NAME
--    Configure_ADC_DMA -- Enables or diables DMA for an ADC.
--  SYNOPSIS
--    Configure_ADC_DMA(ADC, State);
--  FUNCTION
--    Enables or disables the DMA for an ADC.
--  INPUTS
--    ADC - The ADC number, of type ADC_Number.
--    State - Activation of the DMA, of type FunctionalState.
--  SEE ALSO
--    ADC_Number, Stm32.Defines/FunctionalState
--
--*****

  procedure Configure_ADC_DMA (ADC : ADC_Number; State : FunctionalState);

--****f* Stm32.ADC/Regular_Channel_Config
--
--  NAME
--    Regular_Channel_Config -- Configures an ADC regular channel.
--  SYNOPSIS
--    Regular_Channel_Config(ADC, Channel, Rank, Sample_Time);
--  FUNCTION
--    Configures an ADC regular channel with its rank in the sequencer and its sample time.
--  INPUTS
--    ADC - The ADC number, of type ADC_Number.
--    Channel - The channel to configure, of type ADC_Channel_Number.
--    Rank - The rank in the sequencer, of type Rank_Type.
--    Sample_Time - The sample time, of type Sample_Time_Type.
--  SEE ALSO
--    ADC_Number, ADC_Channel_Number, Rank_Type, Sample_Time_Type
--
--*****

  procedure Regular_Channel_Config (ADC : ADC_Number;
                                    Channel : ADC_Channel_Number;
                                    Rank : Rank_Type;
                                    Sample_Time : Sample_Time_Type);

--****f* Stm32.ADC/Start_Conv
--
--  NAME
--    Start_Conv -- Starts the conversion of the regular channels.
--  SYNOPSIS
--    Start_Conv(ADC);
--  FUNCTION
--    Starts the conversion of the regular channels.
--  INPUTS
--    ADC - The ADC_Number, of type ADC_Number.
--  SEE ALSO
--    ADC_Number
--
--*****

  procedure Start_Conv (ADC : ADC_Number);

--****f* Stm32.ADC/ADC_Data_Register
--
--  NAME
--    ADC_Data_Register - Gives the address of the ADC data register.
--  SYNOPSIS
--    Addr := ADC_Data_Register(ADC);
--  FUNCTION
--    Gives the address of the data register of a given ADC.
--  INPUTS
--    ADC - The ADC_Number, of type ADC_Number.
--  RESULT
--    Addr - The data register address, of type System.Address.
--  SEE ALSO
--    ADC_Number, System/Address
--
--*****

  function ADC_Data_Register (ADC : ADC_Number) return System.Address;

--****f* Stm32.ADC/DMA_Stream
--
--  NAME
--    DMA_Stream - Gives the DMA stream of an ADC.
--  SYNOPSIS
--    Stream := DMA_Stream(ADC);
--  FUNCTION
--    Gives the DMA stream of a given ADC.
--  INPUTS
--    ADC - The ADC number, of type ADC_Number.
--  RESULT
--    Stream - The DMA stream of the ADC, of type DMA_Stream_Type.
--  SEE ALSO
--    ADC_Number, Stm32.DMA/DMA_Stream_Type.
--
--*****

  function DMA_Stream (ADC : ADC_Number) return DMA_Stream_Type;

--****f* Stm32.ADC/DMA_Channel
--  NAME
--    DMA_Channel -- Gives the channel of an ADC.
--  SYNOPSIS
--    Channel := DMA_Channel(ADC);
--  FUNCTION
--    Gives the DMA channel of an ADC.
--  INPUTS
--    ADC - The ADC number, of type ADC_Number.
--  RESULT
--    Channel - The DMA channel of the ADC, of type DMA_Channel_Type
--  SEE ALSO
--    ADC_Number, Stm32.DMA/DMA_Channel_Type
--
--*****

  function DMA_Channel (ADC : ADC_Number) return DMA_Channel_Type;

end Stm32.ADC;
