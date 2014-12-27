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

--****c* Stm32.GPIO/Stm32.GPIO
--
--  NAME
--    Stm32.GPIO -- Functions to manage GPIO.
--  COPYRIGHT
--    (c) 2014 by Julien Brette & Julien Romero
--  SYNOPSIS
--    with Stm32.GPIO;
--  DESCRIPTION
--    Thanks to this package, you can use basic GPIO on the card.
--  AUTHOR
--    Julien Brette & Julien Romero
--  USES
--    Stm32.RCC
--*****

package Stm32.GPIO is

--****t* Stm32.GPIO/GPIO_Type
--
--  NAME
--    GPIO_Type -- Names of the GPIOs.
--  USAGE
--    Choose between GPIOA, GPIOB,..., GPIOI.
--  SEE ALSO
--    Stm32.RCC/AHB1_Periph
--
--*****

  subtype GPIO_Type is AHB1_Periph range GPIOA .. GPIOI;

--****t* Stm32.GPIO/GPIO_Mode
--
--  NAME
--    GPIO_Mode -- Mode of a GPIO.
--  USAGE
--    Choose between Mode_In, Mode_Out, Alternate & Analog.
--
--*****

  type GPIO_Mode is (Mode_In, Mode_Out, Alternate, Analog);
  for GPIO_Mode use
    (Mode_In   => 0,
     Mode_Out  => 1,
     Alternate => 2,
     Analog    => 3);
  for GPIO_Mode'Size use 8;

--****t* Stm32.GPIO/GPIO_Output_Type
--
--  NAME
--    GPIO_Output_Type -- The type of an output GPIO.
--  USAGE
--    Choose between PP (Pull/Push) & OD (Open Drain).
--
--*****

  type GPIO_Output_Type is (PP, OD);
  for GPIO_Output_Type use
    (PP => 0,
     OD => 1);
  for GPIO_Output_Type'Size use 8;

--****t* Stm32.GPIO/GPIO_Speed
--
--  NAME
--    GPIO_Speed -- The speed of a GPIO.
--  USAGE
--    Choose between Speed_2MHz, Speed_25MHz, Speed_50MHz & Speed_100MHz.
--
--*****

  type GPIO_Speed is (Speed_2MHz, Speed_25MHz, Speed_50MHz, Speed_100MHz);
  for GPIO_Speed use
    (Speed_2MHz   => 0,
     Speed_25MHz  => 1,
     Speed_50MHz  => 2,
     Speed_100MHz => 3);
  for GPIO_Speed'Size use 8;

--****t* Stm32.GPIO/GPIO_PuPd
--
--  NAME
--    GPIO_PuPd -- The pull of a GPIO.
--  USAGE
--    Choose between No_Pull, Pull_Up & Pull_Down.
--
--*****

  type GPIO_PuPd is (No_Pull, Pull_Up, Pull_Down);
  for GPIO_PuPd use
    (No_Pull   => 0,
     Pull_Up   => 1,
     Pull_Down => 2);
  for GPIO_PuPd'Size use 8;

--****t* Stm32.GPIO/GPIO_Bit_Action
--
--  NAME
--    GPIO_Bit_Action -- The action bit of a GPIO.
--  USAGE
--    Choose between Reset & Set.
--
--*****

  type GPIO_Bit_Action is (Reset, Set);
  for GPIO_Bit_Action use
    (Reset => 0,
     Set   => 1);
  for GPIO_Bit_Action'Size use 16;

--****t* Stm32.GPIO/Pin_Number
--
--  NAME
--    Pin_Number -- The number of the used Pin.
--  USAGE
--    An integer between 0 & 15.
--
--*****

  type Pin_Number is new Integer range 0 .. 15;

--****t* Stm32.GPIO/Pin_Mask
--
--  NAME
--    Pin_Mask -- Define a mask for the pins.
--  USAGE
--    An array of size 16 (0..15) of Booleans used to indicate which pins are used.
--  SEE ALSO
--    GPIO_Pins
--
--*****

  type Pin_Mask is array (Pin_Number) of Boolean;
  pragma Pack (Pin_Mask);

--****t* Stm32.GPIO/GPIO_Pins
--
--  NAME
--    GPIO_Pins -- A record containing the mask of the pins.
--  USAGE
--    Define Mask in the record with a Pin_Mask.
--  EXAMPLE
--    Pins : GPIO_Pins := (Mask => (others => False));
--
--*****

  type GPIO_Pins is record
    Mask : Pin_Mask;
  end record;
  for GPIO_Pins use record
    Mask at 0 range 0 .. 15;
  end record;
  for GPIO_Pins'Size use 32;

--****t* Stm32.GPIO/GPIO_Params
--
--  NAME
--    GPIO_Params -- The parameters of a GPIO.
--  USAGE
--    Define the following fields of the record :
--      * Pins        of type  GPIO_Pins        , by default (Mask => (others => False));
--      * Mode        of type  GPIO_Mode        , by default Mode_In;
--      * Speed       of type  GPIO_Speed       , by default Speed_2MHz;
--      * Output_Type of type  GPIO_Output_Type , by default PP;
--      * PuPd        of type  GPIO_PuPd        , by default No_Pull;
--  EXAMPLE
--    GPIO_Params := (Pins        => (Mask => (1|3 => True, others => False)),
--                   Mode        => Mode_In,
--                   Speed       => Speed_100MHz,
--                   Output_Type => PP,
--                   PuPd        => Pull_Up);
--  SEE ALSO
--    GPIO_Pins, GPIO_Mode, GPIO_Speed, GPIO_Output_Type, GPIO_PuPd
--
--*****

  type GPIO_Params is record
    Pins        : GPIO_Pins := (Mask => (others => False));
    Mode        : GPIO_Mode := Mode_In;
    Speed       : GPIO_Speed := Speed_2MHz;
    Output_Type : GPIO_Output_Type := PP;
    PuPd        : GPIO_PuPd := No_Pull;
  end record;

--****t* Stm32.GPIO/Alternate_Function
--
--  NAME
--    Alternate_Function -- Describes the alternate functions.
--  USAGE
--    Choose between :
--    AF_RTC_50Hz : RTC_50Hz Alternate Function mapping
--    AF_MCO : MCO (MCO1 and MCO2) Alternate Function mapping
--    AF_TAMPER : TAMPER (TAMPER_1 and TAMPER_2) Alternate Function mapping
--    AF_SWJ : SWJ (SWD and JTAG) Alternate Function mapping
--    AF_TRACE : TRACE Alternate Function mapping
--    AF_TIM1 : TIM1 Alternate Function mapping
--    AF_TIM2 : TIM2 Alternate Function mapping
--    AF_TIM3 : TIM3 Alternate Function mapping
--    AF_TIM4 : TIM4 Alternate Function mapping
--    AF_TIM5 : TIM5 Alternate Function mapping
--    AF_TIM8 : TIM8 Alternate Function mapping
--    AF_TIM9 : TIM9 Alternate Function mapping
--    AF_TIM10 : TIM10 Alternate Function mapping
--    AF_TIM11 : TIM11 Alternate Function mapping
--    AF_I2C1 : I2C1 Alternate Function mapping
--    AF_I2C2 : I2C2 Alternate Function mapping
--    AF_I2C3 : I2C3 Alternate Function mapping
--    AF_SPI1 : SPI1 Alternate Function mapping
--    AF_SPI2 : SPI2/I2S2 Alternate Function mapping
--    AF_SPI3 : SPI3/I2S3 Alternate Function mapping
--    AF_USART1 : USART1 Alternate Function mapping
--    AF_USART2 : USART2 Alternate Function mapping
--    AF_USART3 : USART3 Alternate Function mapping
--    AF_I2S3ext : I2S3ext Alternate Function mapping
--    AF_UART4 : UART4 Alternate Function mapping
--    AF_UART5 : UART5 Alternate Function mapping
--    AF_USART6 : USART6 Alternate Function mapping
--    AF_CAN1 : CAN1 Alternate Function mapping
--    AF_CAN2 : CAN2 Alternate Function mapping
--    AF_TIM12 : TIM12 Alternate Function mapping
--    AF_TIM13 : TIM13 Alternate Function mapping
--    AF_TIM14 : TIM14 Alternate Function mapping
--    AF_OTG_FS : OTG_FS Alternate Function mapping
--    AF_OTG_HS : OTG_HS Alternate Function mapping
--    AF_ETH : ETHERNET Alternate Function mapping
--    AF_FSMC : FSMC Alternate Function mapping
--    AF_OTG_HS_FS : OTG HS configured in FS, Alternate Function mapping
--    AF_SDIO : SDIO Alternate Function mapping
--    AF_DCMI : DCMI Alternate Function mapping
--    AF_EVENTOUT : EVENTOUT Alternate Function mapping
--
--*****
  type Alternate_Function is (
    -- AF 0 selection
    AF_RTC_50Hz,     --RTC_50Hz Alternate Function mapping /
    AF_MCO,          --MCO (MCO1 and MCO2) Alternate Function mapping /
    AF_TAMPER,       --TAMPER (TAMPER_1 and TAMPER_2) Alternate Function mapping /
    AF_SWJ,          --SWJ (SWD and JTAG) Alternate Function mapping /
    AF_TRACE,        --TRACE Alternate Function mapping /
    -- AF 1 selection
    AF_TIM1,         --TIM1 Alternate Function mapping /
    AF_TIM2,         --TIM2 Alternate Function mapping /
    -- AF 2 selection
    AF_TIM3,         --TIM3 Alternate Function mapping /
    AF_TIM4,         --TIM4 Alternate Function mapping /
    AF_TIM5,         --TIM5 Alternate Function mapping /
    -- AF 3 selection
    AF_TIM8,         --TIM8 Alternate Function mapping /
    AF_TIM9,         --TIM9 Alternate Function mapping /
    AF_TIM10,        --TIM10 Alternate Function mapping /
    AF_TIM11,        --TIM11 Alternate Function mapping /
    -- AF 4 selection
    AF_I2C1,         --I2C1 Alternate Function mapping /
    AF_I2C2,         --I2C2 Alternate Function mapping /
    AF_I2C3,         --I2C3 Alternate Function mapping /
    -- AF 5 selection
    AF_SPI1,         --SPI1 Alternate Function mapping /
    AF_SPI2,         --SPI2/I2S2 Alternate Function mapping /
    -- AF 6 selection
    AF_SPI3,         --SPI3/I2S3 Alternate Function mapping /
    -- AF 7 selection
    AF_USART1,       --USART1 Alternate Function mapping /
    AF_USART2,       --USART2 Alternate Function mapping /
    AF_USART3,       --USART3 Alternate Function mapping /
    AF_I2S3ext,      --I2S3ext Alternate Function mapping /
    -- AF 8 selection
    AF_UART4,        --UART4 Alternate Function mapping /
    AF_UART5,        --UART5 Alternate Function mapping /
    AF_USART6,       --USART6 Alternate Function mapping /
    -- AF 9 selection
    AF_CAN1,         --CAN1 Alternate Function mapping /
    AF_CAN2,         --CAN2 Alternate Function mapping /
    AF_TIM12,        --TIM12 Alternate Function mapping /
    AF_TIM13,        --TIM13 Alternate Function mapping /
    AF_TIM14,        --TIM14 Alternate Function mapping /
    -- AF 10 selection
    AF_OTG_FS,       --OTG_FS Alternate Function mapping /
    AF_OTG_HS,       --OTG_HS Alternate Function mapping /
    -- AF 11 selection
    AF_ETH,          --ETHERNET Alternate Function mapping /
    -- AF 12 selection
    AF_FSMC,         --FSMC Alternate Function mapping /
    AF_OTG_HS_FS,    --OTG HS configured in FS, Alternate Function mapping /
    AF_SDIO,         --SDIO Alternate Function mapping /
    -- AF 13 selection
    AF_DCMI,         --DCMI Alternate Function mapping /
    -- AF 15 selection
    AF_EVENTOUT);    --EVENTOUT Alternate Function mapping /

--****t* Stm32.GPIO/Pin_Type
--
--  NAME
--    Pin_Type -- Describes a type
--  USAGE
--    A record composed of two fields :
--      * Port of type GPIO_Type : the GPIO port
--      * Pin of type Pin_Number : the number of the pin
--  SEE ALSO
--    GPIO_Type, Pin_Number
--*****

  type Pin_Type is record
    Port : GPIO_Type;
    Pin  : Pin_Number;
  end record;

--****f* Stm32.GPIO/DeInit_GPIO
--
--  NAME
--    DeInit_GPIO -- Reset all parameters a a GPIO
--  SYNOPSIS
--    DeInit_GPIO (GPIO);
--  Function
--    Put all the parameters of the given GPIO the their initial value.
--  INPUTS
--    GPIO  - The GPIO to reset, of type GPIO_Type
--  SEE ALSO
--    GPIO_Type
--
--*****

  procedure DeInit_GPIO (GPIO : GPIO_Type);

--****f* Stm32.GPIO/Config_GPIO
--
--  NAME
--    Config_GPIO -- Configure a GPIO
--  SYNOPSIS
--    Config_GPIO (GPIO, Params);
--  FUNCTION
--    Configure the given GPIO with the given parameters.
--  INPUTS
--    GPIO   - The GPIO to configure, of type GPIO_Type
--    Params - The parameters to apply to the GPIO, of type GPIO_Params
--  EXAMPLE
--    Params : GPIO_Params := (Pins => (Mask => (1|3 => True, others => False)),
--    Mode        => Mode_In,
--    Speed       => Speed_100MHz,
--    Output_Type => PP,
--    PuPd        => Pull_Up);
--    Config_GPIO (GPIOA, Params);
--  SEE ALSO
--    GPIO_Type, GPIO_Params
--
--*****

  procedure Config_GPIO (GPIO : GPIO_Type; Params : GPIO_Params);

--****f* Stm32.GPIO/Config_GPIO_AF
--
--  NAME
--    Config_GPIO_AF -- Configure a pin to an alternate mode
--  SYNOPSIS
--    Config_GPIO_AF (GPIO, Pin, AF);
--  FUNCTION
--    Configure the given pin to the given alternate function.
--  INPUTS
--    GPIO    - the gpio of the pin being configured, of type GPIO_Type
--    Pin     - the number of the pin being configured, of type Pin_Number
--    AF      - the alternate function of the pin, of type Alternate_Function
--  SEE ALSO
--    GPIO_Type, Pin_Number, Alternate_Function
--
--*****

  procedure Config_GPIO_AF (GPIO : GPIO_Type; Pin : Pin_Number;
                            AF : Alternate_Function);

--****f* Stm32.GPIO/Setup_In_Pin
--
--  NAME
--    Setup_In_Pin -- Setup a pin in input mode.
--  SYNOPSIS
--    Setup_In_Pin (Pin);
--  FUNCTION
--    Configure the given pin in input mode. By default, the speed is 100MHz, the pin is in push/pull mode and in pull-up.
--  INPUTS
--    Pin   - The pin to configure, of type Pin_Type
--  SEE ALSO
--    Pin_Type
--
--*****

  procedure Setup_In_Pin (Pin : Pin_Type);

--****f* Stm32.GPIO/Setup_Out_Pin
--
--  NAME
--    Setup_Out_Pin -- Setup a pin in output mode
--  SYNOPSIS
--    Setup_Out_Pin (Pin);
--  FUNCTION
--    Configure the given pin in input mode. By default, the speed is 100MHz, the pin is in push/pull mode and in pull-up.
--  INPUTS
--    Pin   - The pin to configure, of type Pin_Type
--  SEE ALSO
--    Pin_Type
--
--*****

  procedure Setup_Out_Pin (Pin : Pin_Type);

--****f* Stm32.GPIO/Read_Pin
--
--  NAME
--    Read_Pin -- Read the value on the pin.
--  SYNOPSIS
--    value := Read_Pin (Pin);
--  FUNCTION
--    Read the logical value received on the given pin.
--  INPUTS
--    Pin   - The pin to read, of type Pin_Type
--  RESULT
--    value - A Boolean representing the value of the pin.
--  SEE ALSO
--    Pin_Type
--
--*****

  function Read_Pin (Pin : Pin_Type) return Boolean;

--****f* Stm32.GPIO/Set_Pin
--
--  NAME
--    Set_Pin -- Set the value of a pin.
--  SYNOPSIS
--    Set_Pin(Pin, Value);
--  FUNCTION
--    Set the logical value of a pin to the given value.
--  INPUTS
--    Pin     - The pin to write, of type Pin_Type
--    Value   - The value to set, of type Boolean
--  SEE ALSO
--    Pin_Type
--*****

  procedure Set_Pin (Pin : Pin_Type; Value : Boolean);

--****f* Stm32.GPIO/Toggle_Pin
--
--  NAME
--    Toggle_Pin -- Toggle the value of a pin
--  SYNOPSIS
--    Toggle_Pin(Pin);
--  FUNCTION
--    Toggle the value of the given pin.
--  INPUTS
--    Pin   - The pin to toggle, of type Pin_Type
--  SEE ALSO
--    Pin_Type
--
--*****

  procedure Toggle_Pin (Pin : Pin_Type);
end Stm32.GPIO;
