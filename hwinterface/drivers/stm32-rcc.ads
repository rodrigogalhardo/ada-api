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

with Stm32.Defines; use Stm32.Defines;

package Stm32.RCC is

  type Stm_Periph is (
    -- APB1 periph
    TIM2, TIM3, TIM4, TIM5, TIM6, TIM7, TIM12, TIM13, TIM14,
    WWDG, SPI2, SPI3, USART2, USART3, UART4, UART5, I2C1,
    I2C2, I2C3, CAN1, CAN2, PWR, DAC,
    -- APB2 periph
    TIM1, TIM8, USART1, USART6, ADC, ADC1, ADC2, ADC3,
    SDIO, SPI1, SYSCFG, TIM9, TIM10, TIM11,
    -- AHB1 periph
    GPIOA, GPIOB, GPIOC, GPIOD, GPIOE, GPIOF, GPIOG, GPIOH,
    GPIOI, CRC, FLITF, SRAM1, SRAM2, BKPSRAM, CCMDATARAMEN,
    DMA1, DMA2, ETH_MAC, ETH_MAC_Tx, ETH_MAC_Rx, ETH_MAC_PTP,
    OTG_HS, OTG_HS_ULPI,
    -- AHB2 periph
    DCMI, CRYP, HASH, RNG, OTG_FS);

  subtype APB1_Periph is Stm_Periph range TIM2 .. DAC;
  subtype APB2_Periph is Stm_Periph range TIM1 .. TIM11;
  subtype AHB1_Periph is Stm_Periph range GPIOA .. OTG_HS_ULPI;
  subtype AHB2_Periph is Stm_Periph range DCMI .. OTG_FS;

  procedure RCC_PeriphClockCmd (Periph : Stm_Periph; State : FunctionalState);

end Stm32.RCC;
