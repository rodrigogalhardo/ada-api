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

--****c* Stm32.Timer/Stm32.Timer
--
--  NAME
--    Stm32.Timer -- Manages the timers of the stm32.
--  COPYRIGHT
--    (c) 2014 by Julien Brette & Julien Romero
--  SYNOPSIS
--    with Stm32.Timer;
--  DESCRIPTION
--    Manages the timers of the stm32.
--  AUTHOR
--    Julien Brette & Julien Romero
--  USES
--    Interfaces, Stm32.GPIO, Stm32.NVIC
--
--*****

package Stm32.Timer is

--****t* Stm32.Timer/Timer_Number
--
--  NAME
--    Timer_Number -- The number of the timer.
--  USAGE
--    An Integer between 1 and 14 (included).
--
--*****

  type Timer_Number is new Integer range 1 .. 14;

--****t* Stm32.Timer/Timer_Channel_Number
--
--  NAME
--    Timer_Channel_Number -- The number of a timer channel.
--  USAGE
--    An integer between 1 and 4 (included).
--
--*****

  type Timer_Channel_Number is new Integer range 1 .. 4;

--****d* Stm32.Timer/AF_Timer
--
--  NAME
--    AF_Timer -- An array to find the alternate function of a timer.
--  USAGE
--    This is an array that makes the correspondance between a timer number and an alternate function. The value are Alternate_Function.
--  SEE ALSO
--    Timer_Number, Stm32.GPIO/Alternate_Function
--
--*****

  AF_Timer : constant array (Timer_Number) of Alternate_Function :=
    (AF_TIM1, AF_TIM2, AF_TIM3, AF_TIM4, AF_TIM5,
     AF_TIM1, AF_TIM1, -- There is no PIN for TIM6 and TIM7
     AF_TIM8, AF_TIM9, AF_TIM10, AF_TIM11,
     AF_TIM12, AF_TIM13, AF_TIM14);

--****d* Stm32.Timer/IRQ_Timer
--
--  NAME
--    IRQ_Timer -- An array to find the interrupt of a timer.
--  USAGE
--    This is an array of IRQn_Type that makes the correspondance between a timer number and an interrupt.
--  SEE ALSO
--    Timer_Number, Stm32.NVIC/IRQn_Type
--
--*****

  IRQ_Timer : constant array (Timer_Number) of IRQn_Type :=
    (TIM1_BRK_TIM9_IRQn, TIM2_IRQn, TIM3_IRQn, TIM4_IRQn,
     TIM5_IRQn, TIM6_DAC_IRQn, TIM7_IRQn, TIM8_BRK_TIM12_IRQn,
     TIM1_BRK_TIM9_IRQn, TIM1_UP_TIM10_IRQn, TIM1_TRG_COM_TIM11_IRQn,
     TIM8_BRK_TIM12_IRQn, TIM8_UP_TIM13_IRQn, TIM8_TRG_COM_TIM14_IRQn);

--****t* Stm32.Timer/Counter_Mode_Type
--
--  NAME
--    Counter_Mode_Type -- The counter mode of a timer.
--  USAGE
--    Choose a counter mode between :
--      * Up : Counts increasingly.
--      * Down : Counts decreasingly.
--      * CenterAligned1 : Center aligned 1 mode (Up/Down counting) : update interrupt flag when counts down
--      * CenterAligned2 : Center aligned 2 mode (Up/Down counting) : update interrupt flag when counts up
--      * CenterAligned3 : Center aligned 3 mode (Up/Down counting) : update interrupt flag when counts up and down.
--
--*****

  type Counter_Mode_Type is (Up, Down, CenterAligned1, CenterAligned2,
                             CenterAligned3);
  for Counter_Mode_Type use
    (Up => 16#0000#, Down => 16#0010#, CenterAligned1 => 16#0020#,
     CenterAligned2 => 16#0040#, CenterAligned3 => 16#0060#);
  for Counter_Mode_Type'Size use 16;

--****t* Stm32.Timer/Clock_Division_Type
--
--  NAME
--    Clock_Division_Type -- The division of the clock.
--  USAGE
--    Choose between :
--      * Div_1 : No division of the clock (division by one).
--      * Div_2 : Divides by 2 the clock.
--      * Div_4 : Divides by 4 the clock.
--
--*****

  type Clock_Division_Type is (Div_1, Div_2, Div_4);
  for Clock_Division_Type use (Div_1 => 0, Div_2 => 16#0100#, Div_4 => 16#0200#);
  for Clock_Division_Type'Size use 16;

--****t* Stm32.Timer/Timer_Params
--
--  NAME
--    Timer_Params -- The parameters of a timer.
--  USAGE
--    Define the following parameters of the record :
--      * Prescaler : An Unsigned_16 representing the on the fly counter clock
--frequency division.
--      * Counter_Mode : The counter mode of the timer, of type Counter_Mode.
--      * Period : An Unsigned_32 representing the period of the counter.
--      * Clock_Division : The clock division, of type Clock_Division_Type.
--      * Repetition_Counter : An Unsigned_8 configuring the repetition counter (only available on the TIM1).
--  SEE ALSO
--    Counter_Mode_Type, Clock_Division_Type
--
--*****

  type Timer_Params is record
    Prescaler : Unsigned_16;
    Counter_Mode : Counter_Mode_Type;
    Period : Unsigned_32;
    Clock_Division : Clock_Division_Type;
    Repetition_Counter : Unsigned_8;
  end record;
  for Timer_Params'Size use 88;

--****t* Stm32.Timer/Timer_Interrupt_Source
--
--  NAME
--    Timer_Interrupt_Source -- The source of the timer interrupt.
--  USAGE
--    Choose between the following sources :
--      * Disable : No source.
--      * Update : Update of the timer.
--      * CC1 : Compare value of Channel1
--      * CC2 : Compare value of Channel2
--      * CC3 : Compare value of Channel3
--      * CC4 : Compare value of Channel4
--      * COM : Communication event.
--      * Trigger : Trigger event.
--      * Break : a Break input.
--
--*****

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

--****t* Stm32.Timer/Encoder_Mode_Type
--
--  NAME
--    Encoder_Mode_Type -- The mode of an encoder.
--  USAGE
--    Choose between :
--      * TI1 : Use the input connected to TI1 pin.
--      * TI2 : Use the input clock connected to TI2 pin.
--      * TI12 : Use both inputs connected to TI1 pin and TI2 pin.
--
--*****

  type Encoder_Mode_Type is (TI1, TI2, TI12);
  for Encoder_Mode_Type use
    (TI1  => 1,
     TI2  => 2,
     TI12 => 3);
  for Encoder_Mode_Type'Size use 16;

--****t* Stm32.Timer/ICPolarity_Type
--
--  NAME
--    ICPolarity_Type -- Change of the counter event.
--  USAGE
--     Choose between :
--      * Rising : Change on rising edge.
--      * Falling : Change on falling edge.
--      * Both_Edge : Change on both rising and falling edge.
--
--*****

  type ICPolarity_Type is (Rising, Falling, Both_Edge);
  for ICPolarity_Type use
    (Rising   => 16#0000#,
     Falling  => 16#0002#,
     Both_Edge => 16#000A#);
  for ICPolarity_Type'Size use 16;

--****t* Stm32.Timer/OC_Mode
--
--  NAME
--    OC_Mode -- The mode of an Output Channel
--  USAGE
--     Choose between :
--      * Timing : Generates an timing base. No effect on the outputs.
--      * Active : Set the output high when counter is equal to compare value.
--      * Inactive : Set the output low when counter is equal to compare value.
--      * Toggle : Toggle the output when counter is equal to compare value.
--      * PWM1 : PWM mode 1. In up-counting, the channel is active as long as the counter is less than the compare value, otherwise it is inactive. In down-counting, the channel is inactive as long as the counter is more than the compare value, otherwise it is active.
--      * PWM2 : PWM mode 2. In up-counting, the channel is inactive as long as the counter is less than the compare value, otherwise it is active. In down-counting, the channel is active as long as the counter is more than the compare value, otherwise it is inactive.
--
--*****

  type OC_Mode is (Timing, Active, Inactive, Toggle, PWM1, PWM2);
  for OC_Mode use (Timing => 16#0000#,
                   Active => 16#0010#,
                   Inactive => 16#0020#,
                   Toggle => 16#0030#,
                   PWM1 => 16#0060#,
                   PWM2 => 16#0070#);
  for OC_Mode'Size use 16;

--****t* Stm32.Timer/OC_State_Type
--
--  NAME
--    OC_State_Type -- Complementary Output state of a channel.
--  USAGE
--     Choose between :
--      * Disable : Disable complementary output.
--      * Enable : Enable complementary output.
--
--*****

  type OC_State_Type is (Disable, Enable);
  for OC_State_Type use (Disable => 0, Enable => 1);
  for OC_State_Type'Size use 16;

--****t* Stm32.Timer/OC_N_State_Type
--
--  NAME
--    OC_N_State_Type -- Complementary Output N state of a channel.
--  USAGE
--     Choose between :
--      * Disable : Disable complementary output N.
--      * Enable : Enable complementary output N.
--
--*****

  type OC_N_State_Type is (Disable, Enable);
  for OC_N_State_Type use (Disable => 0, Enable => 4);
  for OC_N_State_Type'Size use 16;

--****t* Stm32.Timer/OC_Polarity_Type
--
--  NAME
--    OC_Polarity_Type -- The polarity of the complementary output of a channel.
--  USAGE
--     Choose between :
--      * High : High polarity.
--      * Low : Low polarity.
--
--*****

  type OC_Polarity_Type is (High, Low);
  for OC_Polarity_Type use (High => 0, Low => 2);
  for OC_Polarity_Type'Size use 16;

--****t* Stm32.Timer/OC_N_Polarity_Type
--
--  NAME
--    OC_N_Polarity_Type -- Polarity of the complementary output N of a channel.
--  USAGE
--     Choose between :
--      * High : High polarity.
--      * Low : Low polarity.
--
--*****

  type OC_N_Polarity_Type is (High, Low);
  for OC_N_Polarity_Type use (High => 0, Low => 8);
  for OC_N_Polarity_Type'Size use 16;

--****t* Stm32.Timer/OC_Idle_State
--
--  NAME
--    OC_Idle_State -- The idle state of a complementary output of a channel.
--  USAGE
--     Choose between :
--      * Reset : Disable the output.
--      * Set : Set the output to the polarity value.
--
--*****

  type OC_Idle_State is (Reset, Set);
  for OC_Idle_State use (Reset => 0, Set => 16#0100#);
  for OC_Idle_State'Size use 16;

--****t* Stm32.Timer/OC_N_Idle_State
--
--  NAME
--    OC_N_Idle_State -- The idle state of  a complementary output N of a channel.
--  USAGE
--     Choose between :
--      * Reset : Disable the output.
--      * Set : Set the output to the polarity value.
--
--*****

  type OC_N_Idle_State is (Reset, Set);
  for OC_N_Idle_State use (Reset => 0, Set => 16#0200#);
  for OC_N_Idle_State'Size use 16;

--****t* Stm32.Timer/Output_Channel_Params
--
--  NAME
--    Output_Channel_Params -- Parameters of the output channel.
--  USAGE
--    Define the following fields of this record :
--      * Mode : The mode of the output channel,of type OC_Mode, Timing by default.
--      * Output_State : Complementary Output state, of type OC_State_Type, Disable by default.
--      * Output_N_State : Complementary Output N state, of type OC_N_State_Type, Disable by default.
--      * Pulse : An Unsigned_32 representing the pulse length in the one pulse mode, 0 by default.
--      * Polarity : Polarity of a complementary output, of type OC_Polarity_Type, High by default.
--      * N_Polarity : Polarity of a complementary output N, of type OC_N_Polarity_Type, High by default.
--      * Idle_State : Idle state of the complementary output, of type OC_Idle_State, Reset by default.
--      * N_Idle_State : Idle state of the complementary output N,of type OC_N_Idle_State, Reset by default.
--  SEE ALSO
--    OC_Mode, OC_State_Type, OC_N_State_Type, OC_Polarity_Type, OC_N_Polarity_Type, OC_Idle_State, OC_N_Idle_State
--
--*****

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

--****f* Stm32.Timer/Reset_Timer
--
--  NAME
--    Reset_Timer -- Reset a timer.
--  SYNOPSIS
--    Reset_Timer(Timer);
--  FUNCTION
--    Reset the given timer.
--  INPUTS
--    Timer - The number of the timer to reset, of type Timer_Number.
--  SEE ALSO
--    Timer_Number
--
--*****

  procedure Reset_Timer (Timer : Timer_Number);

--****f* Stm32.Timer/Init_Timer
--
--  NAME
--    Init_Timer -- Initialize a timer.
--  SYNOPSIS
--    Init_Timer(Timer, Params, Interrupt, Priority);
--  FUNCTION
--    Initialize a timer with the given parameters, with a choosen interrupt source and a given priority.
--  INPUTS
--    Timer  - The timer to initialize, of type Timer_Number.
--    Params - The parameters of the timer, of type Timer_Params.
--    Interrupt - The interrupt source, of type Timer_Interrupt_Source.
--    Priority - The priority of the interrupt, of type IRQ_Priority.
--  SEE ALSO
--    Timer_Number, Timer_Params, Timer_Interrupt_Source, Stm32.NVIC/IRQ_Priority
--
--*****

  procedure Init_Timer (Timer : Timer_Number;
                        Params : Timer_Params;
                        Interrupt : Timer_Interrupt_Source;
                        Priority : IRQ_Priority);

--****f* Stm32.Timer/Clear_Interrupt
--
--  NAME
--    Clear_Interrupt -- Clear the interrupt of a timer.
--  SYNOPSIS
--    Clear_Interrupt(Timer, Interrupt);
--  FUNCTION
--    Clear the given interrupt of the given timer.
--  INPUTS
--    Timer - The number of the timer, of type Timer_Number.
--    Interrupt - The souce of the interrupt to clear, of type Timer_Interrupt_Source.
--  SEE ALSO
--    Timer_Number, Timer_Interrupt_Source
--
--*****

  procedure Clear_Interrupt (Timer : Timer_Number;
                             Interrupt : Timer_Interrupt_Source);

--****f* Stm32.Timer/Setup_Encoder
--
--  NAME
--    Setup_Encoder -- Setup the encoder of a timer.
--  SYNOPSIS
--    Setup_Encoder(Timer, Encoder_Mode, IC1_Polarity, IC2_Polarity);
--  FUNCTION
--    Setup the encoder of a timer with the given parameters.
--  INPUTS
--    Timer - The number of the timer, of type Timer_Number.
--    Encoder_Mode - The mode of the encoder, of type Encoder_Mode_Type.
--    IC1_Polarity - The counter event of TI1, of type ICPolarity_Type.
--    IC2_Polarity - The counter event of TI2, of type ICPolarity_Type.
--  SEE ALSO
--    Timer_Number, Encoder_Mode_Type, ICPolarity_Type
--
--*****

  procedure Setup_Encoder (Timer : Timer_Number;
                           Encoder_Mode : Encoder_Mode_Type;
                           IC1_Polarity : ICPolarity_Type;
                           IC2_Polarity : ICPolarity_Type);

--****f* Stm32.Timer/Setup_Output_Channel
--
--  NAME
--    Setup_Output_Channel -- Setup the output channel of a timer.
--  SYNOPSIS
--    Setup_Output_Channel(Timer, Channel, Params);
--  FUNCTION
--    Setup the output channel of a given timer with the given parameters.
--  INPUTS
--    Timer - The number of the timer, of type Timer_Number.
--    Channel - The channel to setup, of type Timer_Channel_Number.
--    Params - The parameters of the channel, of type Output_Channel_Params.
--  SEE ALSO
--    Timer_Number, Timer_Channel_Number, Output_Channel_Params
--
--*****

  procedure Setup_Output_Channel (Timer : Timer_Number;
                                  Channel : Timer_Channel_Number;
                                  Params : Output_Channel_Params);

--****f* Stm32.Timer/Configure_Encoder_Pins
--
--  NAME
--    Configure_Encoder_Pins -- Configure the pins of an encoder.
--  SYNOPSIS
--    Configure_Encoder_Pins(Timer, Pin1, Pin2);
--  FUNCTION
--    Configure the pins of a an encoder of a timer.
--  INPUTS
--    Timer - The timer number, of type Timer_Number.
--    Pin1 - The first pin, of type Pin_Type.
--    Pin2 - The second pin, of type Pin_Type.
--  SEE ALSO
--    Timer_Number, Stm32.GPIO/Pin_Type
--
--*****

  procedure Configure_Encoder_Pins (Timer : Timer_Number; Pin1 : Pin_Type;
                                    Pin2 : Pin_Type);

--****f* Stm32.Timer/Configure_Output_Pin
--
--  NAME
--    Configure_Output_Pin -- Configure an output pin for the timer.
--  SYNOPSIS
--    Configure_Output_Pin(Timer, Pin);
--  FUNCTION
--    Configure a pin to be a timer output pin.
--  INPUTS
--    Timer - The timer number, of type Timer_Number.
--    Pin - The output pin, of type Pin_Type.
--  SEE ALSO
--    Timer_Number, Stm32.GPIO/Pin_Type
--
--*****

  procedure Configure_Output_Pin (Timer : Timer_Number; Pin : Pin_Type);

--****f* Stm32.Timer/Get_Counter
--
--  NAME
--    Get_Counter -- Get the counter of a timer.
--  SYNOPSIS
--    Counter := Get_Counter(Timer);
--  FUNTION
--    Get the value of the counter of a given timer.
--  INPUTS
--    Timer_Number - The timer of the counter, of type Timer_Number.
--  RESULT
--    Counter - An Unsigned_32 representing the value of the counter.
--  SEE ALSO
--    Timer_Number
--
--*****

  function Get_Counter (Timer : Timer_Number) return Unsigned_32;

--****f* Stm32.Timer/Set_Compare
--
--  NAME
--    Set_Compare -- Set the value of the compare value of a channel.
--  SYNOPSIS
--    Set_Compare(Timer, Channel, Value);
--  FUNCTION
--    Set the compare value of the given channel for a given timer.
--  INPUTS
--    Timer - The number of the timer, of type Timer_Number.
--    Channel - The number of the channel, of type Timer_Channel_Number.
--    Value - An Unsigned_32 that represents the value of the compare value.
--  SEE ALSO
--    Timer_Number, Timer_Channel_Number
--
--*****

  procedure Set_Compare (Timer : Timer_Number;
                         Channel : Timer_Channel_Number;
                         Value : Unsigned_32);
end Stm32.Timer;
