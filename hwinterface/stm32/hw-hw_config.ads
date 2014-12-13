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

with Common.Types; use Common.Types;
with Config; use Config;
with Hw.Led;
with Hw.UART;
with Interfaces; use Interfaces;
with Stm32.ADC; use Stm32.ADC;
with Stm32.GPIO; use Stm32.GPIO;
with Stm32.I2C; use Stm32.I2C;
with Stm32.RCC; use Stm32.RCC;
with Stm32.Timer; use Stm32.Timer;

-- Note: Don't call this Hw.Config to avoid conflicts with Config.
package Hw.Hw_Config is

  Main_Leds : constant array (Hw.Led.Board_Led_Type) of Pin_Type :=
    (Camera => (GPIOD, 12),             -- Green
     Error => (GPIOD, 13),              -- Red
     Moving => (GPIOD, 14),             -- Yellow
     Heartbeat => (GPIOD, 15),          -- Blue
     Low_Battery_Digital => (GPIOD, 0), -- Blue
     Color => (GPIOD, 1),               -- Yellow
     Low_Battery_Engines => (GPIOD, 2), -- Red
     TBD => (GPIOD, 3));                -- Green

  type I2C_Module is record
    I2C : I2C_Number;
    SDA : Pin_Type;
    SCL : Pin_Type;
  end record;

  IOExpander : constant I2C_Module :=
    (I2C => 1,
     SDA => (GPIOB, 9),
     SCL => (GPIOB, 8));
  IOExpander_Address : constant Unsigned_7 := 16#20#;

  Top_Led_Pin : constant Pin_Type := (GPIOD, 11);
  Top_Switch_Pin : constant Pin_Type := (GPIOD, 10);
  Color_Button_Pin : constant Pin_Type := (GPIOC, 4);
  Start_Button_Pin : constant Pin_Type := (GPIOC, 5);
  Top_Color_Led_Pin : constant Pin_Type := (GPIOB, 2);

  -- First wheel encoder
  type Wheel_Counter_Type is record
    Timer : Timer_Number;
    Pin1 : Pin_Type;
    Pin2 : Pin_Type;
  end record;

  Timer_Wheel : constant array (0 .. 1) of Wheel_Counter_Type :=
    (0 => (3, (GPIOB, 4), (GPIOB, 5)),
     1 => (1, (GPIOE, 9), (GPIOE, 11)));

  Timer_Pliers : constant Wheel_Counter_Type :=
    (4, (GPIOB, 6), (GPIOB, 7));

  -- Counter timer
  Timer_Counter : constant Timer_Number := 7;
  Timer_Counter_Period : constant := (Clock_Speed/2)/Counter_Freq - 1;
  Timer_Counter_Priority : constant := 12;

  -- AX12
  Bus_1_UART : aliased Hw.UART.UART_Desc := (
    UART_Tx => 2,
    UART_Rx => 2,
    Tx => (GPIOA, 2),
    Rx => (GPIOA, 3),
    En => (GPIOA, 1),
    Use_En => True,
    Tx_PP => False);

  -- Zigbee
  Zigbee_UART : aliased Hw.UART.UART_Desc := (
    UART_Tx => 4,
    UART_Rx => 4,
    Tx => (GPIOC, 10),
    Rx => (GPIOC, 11),
    En => (GPIOH, 15),
    Use_En => False,
    Tx_PP => False);

  -- Camera
  Camera_UART : aliased Hw.UART.UART_Desc := (
    UART_Tx => 3,
    UART_Rx => 3,
    Tx => (GPIOD, 8),
    Rx => (GPIOD, 9),
    En => (GPIOH, 15),
    Use_En => False,
    Tx_PP => True);

  -- Lidar
  Lidar_UART : aliased Hw.UART.UART_Desc := (
    UART_Tx => 6,
    UART_Rx => 6,
    Tx => (GPIOH, 15),
    Rx => (GPIOC, 7),
    En => (GPIOH, 15),
    Use_En => False,
    Tx_PP => False);

  -- Pin to force:
  type Force_Type is record
    Pin : Pin_Type;
    Value : Boolean;
  end record;

  Force : constant array (Integer range <>) of Force_Type :=
    (((GPIOD, 4), False), ((GPIOE, 3), True));

  -- PWMs
  type Engine_Config_Type is record
    Channel : Timer_Channel_Number;
    Pin : Pin_Type;
    In_A : Pin_Type;
    In_B : Pin_Type;
  end record;

  type Engines_Config_Type is record
    Timer : Timer_Number;
    Timer_Prescaler : Unsigned_16;
    Timer_Period : Unsigned_32;
    Left_Config : Engine_Config_Type;
    Right_Config : Engine_Config_Type;
  end record;

  Prescaler : constant := (Clock_Speed/2)/PWM_Freq/Max_PWM - 1;
  PWM_Config : constant array (Engine_Kind) of Engines_Config_Type :=
    (Primary =>
      (Timer => 2,
       Timer_Prescaler => Prescaler,
       Timer_Period => Max_PWM,
       Left_Config =>
         (Channel => 3,
          Pin => (GPIOB, 10),
          In_A => (GPIOB, 15),
          In_B => (GPIOB, 13)),
       Right_Config =>
         (Channel => 4,
          Pin => (GPIOB, 11),
          In_A => (GPIOB, 12),
          In_B => (GPIOB, 14))),
     Secondary =>
      (Timer => 8,
       Timer_Prescaler => Prescaler,
       Timer_Period => Max_PWM,
       Left_Config =>
         (Channel => 1,
          Pin => (GPIOC, 6),
          In_A => (GPIOC, 8),
          In_B => (GPIOC, 12)),
       Right_Config =>
         (Channel => 2,
          Pin => (GPIOH, 15),
          In_A => (GPIOH, 15),
          In_B => (GPIOH, 15))));

  -- ADC
  type ADC_Config is record
    Pin : Pin_Type;
    Channel : ADC_Channel_Number;
  end record;

  Main_ADC : constant ADC_Number := 1;
  ADC_Channel : constant array (Channel_Type) of ADC_Config :=
    (Logical => ((GPIOA, 4), 4),
     Engines => ((GPIOA, 5), 5));
--     Sensor_1 => ((GPIOB, 1), 9));
--     Sensor_2 => ((GPIOB, 1), 9));
--     Sensor_3 => ((GPIOC, 1), 11),
--     Sensor_4 => ((GPIOC, 2), 12));

  -- Button
  User_Button_Pin : constant Pin_Type := (GPIOA, 0);

  -- Paintings
  Paintings_Left : constant Pin_Type := (GPIOD, 7);
  Paintings_Right : constant Pin_Type := (GPIOB, 1);

  -- New_Sharp
  New_Sharp_1_Pin : constant Pin_Type := (GPIOC, 2);
  New_Sharp_2_Pin : constant Pin_Type := (GPIOC, 1);
  New_Sharp_3_Pin : constant Pin_Type := (GPIOD, 6);

  -- This guy is inverted.
  New_Sharp_Inverted_Pin : constant Pin_Type := (GPIOB, 0);

  Funny_Action_Pin : constant Pin_Type := (GPIOD, 6);

end Hw.Hw_Config;
