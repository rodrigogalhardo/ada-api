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

with Interfaces; use Interfaces;
with Stm32.Defines; use Stm32.Defines;

package body Stm32.GPIO is

  type GPIO_TypeDef is new Unsigned_32;

  GPIOs : constant array (GPIO_Type) of GPIO_TypeDef :=
    (GPIOA_BASE, GPIOB_BASE, GPIOC_BASE, GPIOD_BASE,
     GPIOE_BASE, GPIOF_BASE, GPIOG_BASE, GPIOH_BASE,
     GPIOI_BASE);

  AFs : constant array (Alternate_Function) of Unsigned_8 :=
     -- AF 0 selection
    (AF_RTC_50Hz      => 16#00#,
     AF_MCO           => 16#00#,
     AF_TAMPER        => 16#00#,
     AF_SWJ           => 16#00#,
     AF_TRACE         => 16#00#,
     -- AF 1 selection
     AF_TIM1          => 16#01#,
     AF_TIM2          => 16#01#,
     -- AF 2 selection
     AF_TIM3          => 16#02#,
     AF_TIM4          => 16#02#,
     AF_TIM5          => 16#02#,
     -- AF 3 selection
     AF_TIM8          => 16#03#,
     AF_TIM9          => 16#03#,
     AF_TIM10         => 16#03#,
     AF_TIM11         => 16#03#,
     -- AF 4 selection
     AF_I2C1          => 16#04#,
     AF_I2C2          => 16#04#,
     AF_I2C3          => 16#04#,
     -- AF 5 selection
     AF_SPI1          => 16#05#,
     AF_SPI2          => 16#05#,
     -- AF 6 selection
     AF_SPI3          => 16#06#,
     -- AF 7 selection
     AF_USART1        => 16#07#,
     AF_USART2        => 16#07#,
     AF_USART3        => 16#07#,
     AF_I2S3ext       => 16#07#,
     -- AF 8 selection
     AF_UART4         => 16#08#,
     AF_UART5         => 16#08#,
     AF_USART6        => 16#08#,
     -- AF 9 selection
     AF_CAN1          => 16#09#,
     AF_CAN2          => 16#09#,
     AF_TIM12         => 16#09#,
     AF_TIM13         => 16#09#,
     AF_TIM14         => 16#09#,
     -- AF 10 selection
     AF_OTG_FS         => 16#A#,
     AF_OTG_HS         => 16#A#,
     -- AF 11 selection
     AF_ETH             => 16#0B#,
     -- AF 12 selection
     AF_FSMC            => 16#C#,
     AF_OTG_HS_FS       => 16#C#,
     AF_SDIO            => 16#C#,
     -- AF 13 selection
     AF_DCMI          => 16#0D#,
     -- AF 15 selection
     AF_EVENTOUT      => 16#0F#);

  -------------
  -- Imports --
  -------------

  procedure GPIO_DeInit (GPIO : GPIO_TypeDef);
  pragma Import (C, GPIO_DeInit, "GPIO_DeInit");

  procedure GPIO_Init (GPIO : GPIO_TypeDef; Params : access GPIO_Params);
  pragma Import (C, GPIO_Init, "GPIO_Init");

  procedure GPIO_PinAFConfig (GPIO : GPIO_TypeDef; Pin : Unsigned_16;
                              AF : Unsigned_8);
  pragma Import (C, GPIO_PinAFConfig, "GPIO_PinAFConfig");

  function GPIO_ReadInputDataBit (GPIO : GPIO_TypeDef;
                                  Pin : Unsigned_16) return Unsigned_8;
  pragma Import (C, GPIO_ReadInputDataBit, "GPIO_ReadInputDataBit");

  function GPIO_ReadOutputDataBit (GPIO : GPIO_TypeDef;
                                   Pin : Unsigned_16) return Unsigned_8;
  pragma Import (C, GPIO_ReadOutputDataBit, "GPIO_ReadOutputDataBit");

  procedure GPIO_WriteBit (GPIO : GPIO_TypeDef; GPIO_Pin : Unsigned_16;
                           Bit_Val : GPIO_Bit_Action);
  pragma Import (C, GPIO_WriteBit, "GPIO_WriteBit");

  -----------------
  -- DeInit_GPIO --
  -----------------

  procedure DeInit_GPIO (GPIO : GPIO_Type) is
  begin
    GPIO_DeInit (GPIOs (GPIO));
  end DeInit_GPIO;

  -----------------
  -- Config_GPIO --
  -----------------

  procedure Config_GPIO (GPIO : GPIO_Type; Params : GPIO_Params) is
    P : aliased GPIO_Params := Params;
  begin
    RCC_PeriphClockCmd (GPIO, Enable);
    GPIO_Init (GPIOs (GPIO), P'Access);
  end Config_GPIO;

  ---------------
  -- Config_AF --
  ---------------

  procedure Config_GPIO_AF (GPIO : GPIO_Type; Pin : Pin_Number;
                            AF : Alternate_Function) is
  begin
    GPIO_PinAFConfig (GPIOs (GPIO), Unsigned_16 (Pin), AFs (AF));
  end Config_GPIO_AF;

  -------------------
  -- Setup_In_Pin --
  -------------------

  procedure Setup_In_Pin (Pin : Pin_Type) is
    GPIO : GPIO_Params;
  begin
    GPIO := (Pins        => (Mask => (others => False)),
             Mode        => Mode_In,
             Speed       => Speed_100MHz,
             Output_Type => PP,
             PuPd        => Pull_Up);
    GPIO.Pins.Mask (Pin.Pin) := True;
    Config_GPIO (Pin.Port, GPIO);
  end Setup_In_Pin;

  -------------------
  -- Setup_Out_Pin --
  -------------------

  procedure Setup_Out_Pin (Pin : Pin_Type) is
    GPIO : GPIO_Params;
  begin
    GPIO := (Pins        => (Mask => (others => False)),
             Mode        => Mode_Out,
             Speed       => Speed_100MHz,
             Output_Type => PP,
             PuPd        => Pull_Up);
    GPIO.Pins.Mask (Pin.Pin) := True;
    Config_GPIO (Pin.Port, GPIO);
  end Setup_Out_Pin;

  --------------
  -- Read_Pin --
  --------------

  function Read_Pin (Pin: Pin_Type) return Boolean is
  begin
    return GPIO_ReadInputDataBit (GPIOs (Pin.Port),
                                  2 ** Natural (Pin.Pin)) /= 0;
  end Read_Pin;

  -------------
  -- Set_Pin --
  -------------

  procedure Set_Pin (Pin : Pin_Type; Value : Boolean) is
  begin
    GPIO_WriteBit (GPIOs (Pin.Port), 2 ** Natural (Pin.Pin),
                   GPIO_Bit_Action'Val (Boolean'Pos (Value)));
  end Set_Pin;

  ----------------
  -- Toggle_Pin --
  ----------------

  procedure Toggle_Pin (Pin : Pin_Type) is
    Old_Value : constant Unsigned_8 :=
        GPIO_ReadOutputDataBit (GPIOs (Pin.Port),
                                2 ** Natural (Pin.Pin));
  begin
    Set_Pin (Pin, Old_Value = 0);
  end Toggle_Pin;

end Stm32.GPIO;
