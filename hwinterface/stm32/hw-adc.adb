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

with Ada.Real_Time; use Ada.Real_Time;
with Current_Bot;
with Hw.Button;
with Hw.Digital_Servo;
with Hw.Hw_Config; use Hw.Hw_Config;
with Leds;
with Logging;
with Stm32.ADC; use Stm32.ADC;
pragma Elaborate_All (Stm32.ADC);
with Stm32.Defines; use Stm32.Defines;
with Stm32.DMA; use Stm32.DMA;
pragma Elaborate_All (Stm32.DMA);
with Stm32.GPIO; use Stm32.GPIO;
pragma Elaborate_All (Stm32.GPIO);

package body Hw.ADC is

  Values : Adc_Values;

  type Mean_Array_Type is array (0 .. 100) of Unsigned_32;

  type Mean_Type is record
    Values : Mean_Array_Type := (others => 0);
    Sum : Unsigned_32 := 0;
    Current : Integer := 0;
  end record;

  Means : array (Channel_Type) of Mean_Type;

  subtype Battery_Channel_Type is Channel_Type range Logical .. Engines;

  Battery_Leds : constant array (Battery_Channel_Type) of Common.Types.Led_Type :=
      (Logical => Common.Types.Low_Battery_Digital,
       Engines => Common.Types.Low_Battery_Engines);

  Engines_Threshold : constant array (Own_Bot_Type) of Unsigned_16 :=
      (Small => 2150, Big => 2140);
  Battery_Threshold : constant array (Battery_Channel_Type) of Unsigned_16 :=
      (Logical => 3360,
       Engines => Engines_Threshold (Current_Bot));

  Battery_Low_Time : array (Battery_Channel_Type) of Time :=
      (others => Time_First);

  --------------------
  -- Setup_Hardware --
  --------------------

  procedure Setup_Hardware is
    Common : constant ADC_Common_Params := (
      Mode => Mode_Independent,
      Prescaler => Div_2,
      DMA_Access_Mode => Disabled,
      Two_Sampling_Delay => Delay_20Cycles);
    Params : constant ADC_Params := (
      Resolution => Resolution_12b,
      Scan_Conv_Mode => Enable,
      Continuous_Conv_Mode => Enable,
      External_Trig_Conv_Edge => None,
      External_Trig_Conv => T1_CC1,
      Data_Align => Right,
      Nbr_Of_Conversion => ADC_Channel'Length);
    DMA : constant DMA_Params := (
      Channel => DMA_Channel (Main_ADC),
      Peripheral_Base_Addr => ADC_Data_Register (Main_ADC),
      Memory_Base_Addr => Values'Address,
      Dir => Peripheral_To_Memory,
      Buffer_Size => ADC_Channel'Length,
      Peripheral_Inc => Disable,
      Memory_Inc => Enable,
      Peripheral_Data_Size => Half_Word,
      Memory_Data_Size => Half_Word,
      Mode => Circular,
      Priority => Low,
      FIFO_Mode => Disable,
      FIFO_Threshold => One_Quarter,
      Memory_Burst => Single,
      Peripheral_Burst => Single);

    GPIO : GPIO_Params := (
      Pins => (Mask => (others => False)),
      Mode => Analog,
      Speed => Speed_2MHz,
      Output_Type => PP,
      PuPd => No_Pull);
    Stream : constant DMA_Stream_Type := DMA_Stream (Main_ADC);
  begin
    DMA_Init (Stream, DMA);

    ADC_Init_Common (Common);
    ADC_Init (1, Params);
    for I in Channel_Type loop
      GPIO.Pins.Mask (ADC_Channel (I).Pin.Pin) := True;
      Config_GPIO (ADC_Channel (I).Pin.Port, GPIO);
      GPIO.Pins.Mask (ADC_Channel (I).Pin.Pin) := False;
      Regular_Channel_Config (Main_ADC, ADC_Channel (I).Channel,
                              Channel_Type'Pos (I) + 1,
                              Sample_Time_56Cycles);
    end loop;

    Configure_ADC_DMA (Main_ADC, Enable);
    Configure_ADC (Main_ADC, Enable);
    Configure_DMA (Stream, Enable);
    Start_Conv (Main_ADC);
  end Setup_Hardware;

  -------------------
  -- Check_Battery --
  -------------------

  procedure Check_Battery (Bat : Battery_Channel_Type) is
    Invalid : Boolean;
  begin
    if Bat = Engines then
      Invalid := not Hw.Button.Red_Button and Get_Value (Bat) > Battery_Threshold (Bat);
    else
      Invalid := Get_Value (Bat) < Battery_Threshold (Bat);
    end if;
    if Invalid then
      Leds.Led_On (Battery_Leds (Bat));
      if Battery_Low_Time (Bat) + To_Time_Span (15.0) < Clock then
        if Bat = Engines then
          Logging.Log ("Engine battery low!");
        else
          Logging.Log ("Logic battery low!");
        end if;
        Hw.Digital_Servo.Set_Reg (254, 25, 1);
        Battery_Low_Time (Bat) := Clock;
      end if;
    else
      Leds.Led_Off (Battery_Leds (Bat));
    end if;
  end Check_Battery;

  ----------------------
  -- PUBLIC FUNCTIONS --
  ----------------------

  --------------------
  -- Refresh_Values --
  --------------------

  procedure Refresh_Values is
    V : Unsigned_32;
  begin
    for I in Channel_Type loop
      V := Unsigned_32 (Values (I));
      Means (I).Sum := Means (I).Sum + V - Means (I).Values (Means (I).Current);
      Means (I).Values (Means (I).Current) := V;
      Means (I).Current := Means (I).Current + 1;
      if Means (I).Current > Mean_Array_Type'Last then
        Means (I).Current := Mean_Array_Type'First;
      end if;
    end loop;

    -- Check the battery state.
    for I in Battery_Channel_Type loop
      Check_Battery (I);
    end loop;
  end Refresh_Values;

  ---------------
  -- Get_Value --
  ---------------

  function Get_Value (Channel : Channel_Type) return Unsigned_16 is
  begin
    return Unsigned_16 (Means (Channel).Sum / Mean_Array_Type'Length);
  end Get_Value;

  -------------
  -- Get_All --
  -------------

  function Get_All return Adc_Values is
    V : Adc_Values;
  begin
    for I in Channel_Type loop
      V (I) := Get_Value (I);
    end loop;
    return V;
  end Get_All;

begin
  Setup_Hardware;
end Hw.ADC;
