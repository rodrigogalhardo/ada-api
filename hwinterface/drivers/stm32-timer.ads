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
with Stm32.GPIO; use Stm32.GPIO;
with Stm32.NVIC; use Stm32.NVIC;

package Stm32.Timer is

  type Timer_Number is new Integer range 1 .. 14;

  type Timer_Channel_Number is new Integer range 1 .. 4;

  AF_Timer : constant array (Timer_Number) of Alternate_Function :=
    (AF_TIM1, AF_TIM2, AF_TIM3, AF_TIM4, AF_TIM5,
     AF_TIM1, AF_TIM1, -- There is no PIN for TIM6 and TIM7
     AF_TIM8, AF_TIM9, AF_TIM10, AF_TIM11,
     AF_TIM12, AF_TIM13, AF_TIM14);

  IRQ_Timer : constant array (Timer_Number) of IRQn_Type :=
    (TIM1_BRK_TIM9_IRQn, TIM2_IRQn, TIM3_IRQn, TIM4_IRQn,
     TIM5_IRQn, TIM6_DAC_IRQn, TIM7_IRQn, TIM8_BRK_TIM12_IRQn,
     TIM1_BRK_TIM9_IRQn, TIM1_UP_TIM10_IRQn, TIM1_TRG_COM_TIM11_IRQn,
     TIM8_BRK_TIM12_IRQn, TIM8_UP_TIM13_IRQn, TIM8_TRG_COM_TIM14_IRQn);

  type Counter_Mode_Type is (Up, Down, CenterAligned1, CenterAligned2,
                             CenterAligned3);
  for Counter_Mode_Type use
    (Up => 16#0000#, Down => 16#0010#, CenterAligned1 => 16#0020#,
     CenterAligned2 => 16#0040#, CenterAligned3 => 16#0060#);
  for Counter_Mode_Type'Size use 16;

  type Clock_Division_Type is (Div_1, Div_2, Div_4);
  for Clock_Division_Type use (Div_1 => 0, Div_2 => 16#0100#, Div_4 => 16#0200#);
  for Clock_Division_Type'Size use 16;

  type Timer_Params is record
    Prescaler : Unsigned_16;
    Counter_Mode : Counter_Mode_Type;
    Period : Unsigned_32;
    Clock_Division : Clock_Division_Type;
    Repetition_Counter : Unsigned_8;
  end record;
  for Timer_Params'Size use 88;

  type Timer_Interrupt_Source is
    (Disable, Update, CC1, CC2, CC3,
     CC4, COM, Trigger, Break);
  for Timer_Interrupt_Source use
    (Disable => 16#0000#,
     Update  => 16#0001#,
     CC1     => 16#0002#,
     CC2     => 16#0004#,
     CC3     => 16#0008#,
     CC4     => 16#0010#,
     COM     => 16#0020#,
     Trigger => 16#0040#,
     Break   => 16#0080#);
  for Timer_Interrupt_Source'Size use 16;

  type Encoder_Mode_Type is (TI1, TI2, TI12);
  for Encoder_Mode_Type use
    (TI1  => 1,
     TI2  => 2,
     TI12 => 3);
  for Encoder_Mode_Type'Size use 16;

  type ICPolarity_Type is (Rising, Falling, Both_Edge);
  for ICPolarity_Type use
    (Rising   => 16#0000#,
     Falling  => 16#0002#,
     Both_Edge => 16#000A#);
  for ICPolarity_Type'Size use 16;

  type OC_Mode is (Timing, Active, Inactive, Toggle, PWM1, PWM2);
  for OC_Mode use (Timing => 16#0000#,
                   Active => 16#0010#,
                   Inactive => 16#0020#,
                   Toggle => 16#0030#,
                   PWM1 => 16#0060#,
                   PWM2 => 16#0070#);
  for OC_Mode'Size use 16;

  type OC_State_Type is (Disable, Enable);
  for OC_State_Type use (Disable => 0, Enable => 1);
  for OC_State_Type'Size use 16;

  type OC_N_State_Type is (Disable, Enable);
  for OC_N_State_Type use (Disable => 0, Enable => 4);
  for OC_N_State_Type'Size use 16;

  type OC_Polarity_Type is (High, Low);
  for OC_Polarity_Type use (High => 0, Low => 2);
  for OC_Polarity_Type'Size use 16;

  type OC_N_Polarity_Type is (High, Low);
  for OC_N_Polarity_Type use (High => 0, Low => 8);
  for OC_N_Polarity_Type'Size use 16;

  type OC_Idle_State is (Reset, Set);
  for OC_Idle_State use (Reset => 0, Set => 16#0100#);
  for OC_Idle_State'Size use 16;

  type OC_N_Idle_State is (Reset, Set);
  for OC_N_Idle_State use (Reset => 0, Set => 16#0200#);
  for OC_N_Idle_State'Size use 16;

  type Output_Channel_Params is record
    Mode : OC_Mode := Timing;
    Output_State : OC_State_Type := Disable;
    Output_N_State : OC_N_State_Type := Disable;
    Pulse : Unsigned_32 := 0;
    Polarity : OC_Polarity_Type := High;
    N_Polarity : OC_N_Polarity_Type := High;
    Idle_State : OC_Idle_State := Reset;
    N_Idle_State : OC_N_Idle_State := Reset;
  end record;

  procedure Reset_Timer (Timer : Timer_Number);

  procedure Init_Timer (Timer : Timer_Number;
                        Params : Timer_Params;
                        Interrupt : Timer_Interrupt_Source;
                        Priority : IRQ_Priority);

  procedure Clear_Interrupt (Timer : Timer_Number;
                             Interrupt : Timer_Interrupt_Source);

  procedure Setup_Encoder (Timer : Timer_Number;
                           Encoder_Mode : Encoder_Mode_Type;
                           IC1_Polarity : ICPolarity_Type;
                           IC2_Polarity : ICPolarity_Type);

  procedure Setup_Output_Channel (Timer : Timer_Number;
                                  Channel : Timer_Channel_Number;
                                  Params : Output_Channel_Params);

  procedure Configure_Encoder_Pins (Timer : Timer_Number; Pin1 : Pin_Type;
                                    Pin2 : Pin_Type);

  procedure Configure_Output_Pin (Timer : Timer_Number; Pin : Pin_Type);

  function Get_Counter (Timer : Timer_Number) return Unsigned_32;

  procedure Set_Compare (Timer : Timer_Number;
                         Channel : Timer_Channel_Number;
                         Value : Unsigned_32);
end Stm32.Timer;
