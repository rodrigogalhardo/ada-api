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

--****c* Stm32.Defines/Stm32.Defines
--
--  NAME
--    Stm32.Defines -- Defines some constants.
--  COPYRIGHT
--    (c) 2014 by Julien Brette & Julien Romero
--  SYNOPSIS
--    with Stm32.Defines;
--  DESCRIPTION
--    Contains some global constants.
--  AUTHOR
--    Julien Brette & Julien Romero
--
--*****

package Stm32.Defines is

--****t* Stm32.Defines/FunctionalState
--
--  NAME
--    FunctionalState -- Stands for a functional state.
--  USAGE
--    Choose between Disable and Enable.
--
--*****

  type FunctionalState is (Disable, Enable);
  for FunctionalState use (Disable => 0, Enable => 1);

  FLASH_BASE : constant :=            (16#08000000#); --  FLASH(up to 1 MB) base address in the alias region
  CCMDATARAM_BASE : constant :=       (16#10000000#); --  CCM(core coupled memory) data RAM(64 KB) base address in the alias region
  SRAM1_BASE : constant :=            (16#20000000#); --  SRAM1(112 KB) base address in the alias region
  SRAM2_BASE : constant :=            (16#2001C000#); --  SRAM2(16 KB) base address in the alias region
  PERIPH_BASE : constant :=           (16#40000000#); --  Peripheral base address in the alias region
  BKPSRAM_BASE : constant :=          (16#40024000#); --  Backup SRAM(4 KB) base address in the alias region
  FSMC_R_BASE : constant :=           (16#A0000000#); --  FSMC registers base address

  CCMDATARAM_BB_BASE : constant :=    (16#12000000#); --  CCM(core coupled memory) data RAM(64 KB) base address in the bit-band region
  SRAM1_BB_BASE : constant :=         (16#22000000#); --  SRAM1(112 KB) base address in the bit-band region
  SRAM2_BB_BASE : constant :=         (16#2201C000#); --  SRAM2(16 KB) base address in the bit-band region
  PERIPH_BB_BASE : constant :=        (16#42000000#); --  Peripheral base address in the bit-band region
  BKPSRAM_BB_BASE : constant :=       (16#42024000#); --  Backup SRAM(4 KB) base address in the bit-band region

--  Legacy defines
  SRAM_BASE : constant :=             SRAM1_BASE;
  SRAM_BB_BASE : constant :=          SRAM1_BB_BASE;


--  Peripheral memory map
  APB1PERIPH_BASE : constant :=       PERIPH_BASE;
  APB2PERIPH_BASE : constant :=       (PERIPH_BASE + 16#00010000#);
  AHB1PERIPH_BASE : constant :=       (PERIPH_BASE + 16#00020000#);
  AHB2PERIPH_BASE : constant :=       (PERIPH_BASE + 16#10000000#);

--  APB1 peripherals
  TIM2_BASE : constant :=             (APB1PERIPH_BASE + 16#0000#);
  TIM3_BASE : constant :=             (APB1PERIPH_BASE + 16#0400#);
  TIM4_BASE : constant :=             (APB1PERIPH_BASE + 16#0800#);
  TIM5_BASE : constant :=             (APB1PERIPH_BASE + 16#0C00#);
  TIM6_BASE : constant :=             (APB1PERIPH_BASE + 16#1000#);
  TIM7_BASE : constant :=             (APB1PERIPH_BASE + 16#1400#);
  TIM12_BASE : constant :=            (APB1PERIPH_BASE + 16#1800#);
  TIM13_BASE : constant :=            (APB1PERIPH_BASE + 16#1C00#);
  TIM14_BASE : constant :=            (APB1PERIPH_BASE + 16#2000#);
  RTC_BASE : constant :=              (APB1PERIPH_BASE + 16#2800#);
  WWDG_BASE : constant :=             (APB1PERIPH_BASE + 16#2C00#);
  IWDG_BASE : constant :=             (APB1PERIPH_BASE + 16#3000#);
  I2S2ext_BASE : constant :=          (APB1PERIPH_BASE + 16#3400#);
  SPI2_BASE : constant :=             (APB1PERIPH_BASE + 16#3800#);
  SPI3_BASE : constant :=             (APB1PERIPH_BASE + 16#3C00#);
  I2S3ext_BASE : constant :=          (APB1PERIPH_BASE + 16#4000#);
  USART2_BASE : constant :=           (APB1PERIPH_BASE + 16#4400#);
  USART3_BASE : constant :=           (APB1PERIPH_BASE + 16#4800#);
  UART4_BASE : constant :=            (APB1PERIPH_BASE + 16#4C00#);
  UART5_BASE : constant :=            (APB1PERIPH_BASE + 16#5000#);
  I2C1_BASE : constant :=             (APB1PERIPH_BASE + 16#5400#);
  I2C2_BASE : constant :=             (APB1PERIPH_BASE + 16#5800#);
  I2C3_BASE : constant :=             (APB1PERIPH_BASE + 16#5C00#);
  CAN1_BASE : constant :=             (APB1PERIPH_BASE + 16#6400#);
  CAN2_BASE : constant :=             (APB1PERIPH_BASE + 16#6800#);
  PWR_BASE : constant :=              (APB1PERIPH_BASE + 16#7000#);
  DAC_BASE : constant :=              (APB1PERIPH_BASE + 16#7400#);

--  APB2 peripherals
  TIM1_BASE : constant :=             (APB2PERIPH_BASE + 16#0000#);
  TIM8_BASE : constant :=             (APB2PERIPH_BASE + 16#0400#);
  USART1_BASE : constant :=           (APB2PERIPH_BASE + 16#1000#);
  USART6_BASE : constant :=           (APB2PERIPH_BASE + 16#1400#);
  ADC1_BASE : constant :=             (APB2PERIPH_BASE + 16#2000#);
  ADC2_BASE : constant :=             (APB2PERIPH_BASE + 16#2100#);
  ADC3_BASE : constant :=             (APB2PERIPH_BASE + 16#2200#);
  ADC_BASE : constant :=              (APB2PERIPH_BASE + 16#2300#);
  SDIO_BASE : constant :=             (APB2PERIPH_BASE + 16#2C00#);
  SPI1_BASE : constant :=             (APB2PERIPH_BASE + 16#3000#);
  SYSCFG_BASE : constant :=           (APB2PERIPH_BASE + 16#3800#);
  EXTI_BASE : constant :=             (APB2PERIPH_BASE + 16#3C00#);
  TIM9_BASE : constant :=             (APB2PERIPH_BASE + 16#4000#);
  TIM10_BASE : constant :=            (APB2PERIPH_BASE + 16#4400#);
  TIM11_BASE : constant :=            (APB2PERIPH_BASE + 16#4800#);

--  AHB1 peripherals
  GPIOA_BASE : constant :=            (AHB1PERIPH_BASE + 16#0000#);
  GPIOB_BASE : constant :=            (AHB1PERIPH_BASE + 16#0400#);
  GPIOC_BASE : constant :=            (AHB1PERIPH_BASE + 16#0800#);
  GPIOD_BASE : constant :=            (AHB1PERIPH_BASE + 16#0C00#);
  GPIOE_BASE : constant :=            (AHB1PERIPH_BASE + 16#1000#);
  GPIOF_BASE : constant :=            (AHB1PERIPH_BASE + 16#1400#);
  GPIOG_BASE : constant :=            (AHB1PERIPH_BASE + 16#1800#);
  GPIOH_BASE : constant :=            (AHB1PERIPH_BASE + 16#1C00#);
  GPIOI_BASE : constant :=            (AHB1PERIPH_BASE + 16#2000#);
  CRC_BASE : constant :=              (AHB1PERIPH_BASE + 16#3000#);
  RCC_BASE : constant :=              (AHB1PERIPH_BASE + 16#3800#);
  FLASH_R_BASE : constant :=          (AHB1PERIPH_BASE + 16#3C00#);
  DMA1_BASE : constant :=             (AHB1PERIPH_BASE + 16#6000#);
  DMA1_Stream0_BASE : constant :=     (DMA1_BASE + 16#010#);
  DMA1_Stream1_BASE : constant :=     (DMA1_BASE + 16#028#);
  DMA1_Stream2_BASE : constant :=     (DMA1_BASE + 16#040#);
  DMA1_Stream3_BASE : constant :=     (DMA1_BASE + 16#058#);
  DMA1_Stream4_BASE : constant :=     (DMA1_BASE + 16#070#);
  DMA1_Stream5_BASE : constant :=     (DMA1_BASE + 16#088#);
  DMA1_Stream6_BASE : constant :=     (DMA1_BASE + 16#0A0#);
  DMA1_Stream7_BASE : constant :=     (DMA1_BASE + 16#0B8#);
  DMA2_BASE : constant :=             (AHB1PERIPH_BASE + 16#6400#);
  DMA2_Stream0_BASE : constant :=     (DMA2_BASE + 16#010#);
  DMA2_Stream1_BASE : constant :=     (DMA2_BASE + 16#028#);
  DMA2_Stream2_BASE : constant :=     (DMA2_BASE + 16#040#);
  DMA2_Stream3_BASE : constant :=     (DMA2_BASE + 16#058#);
  DMA2_Stream4_BASE : constant :=     (DMA2_BASE + 16#070#);
  DMA2_Stream5_BASE : constant :=     (DMA2_BASE + 16#088#);
  DMA2_Stream6_BASE : constant :=     (DMA2_BASE + 16#0A0#);
  DMA2_Stream7_BASE : constant :=     (DMA2_BASE + 16#0B8#);
  ETH_BASE : constant :=              (AHB1PERIPH_BASE + 16#8000#);
  ETH_MAC_BASE : constant :=          (ETH_BASE);
  ETH_MMC_BASE : constant :=          (ETH_BASE + 16#0100#);
  ETH_PTP_BASE : constant :=          (ETH_BASE + 16#0700#);
  ETH_DMA_BASE : constant :=          (ETH_BASE + 16#1000#);

--  AHB2 peripherals
  DCMI_BASE : constant :=             (AHB2PERIPH_BASE + 16#50000#);
  CRYP_BASE : constant :=             (AHB2PERIPH_BASE + 16#60000#);
  HASH_BASE : constant :=             (AHB2PERIPH_BASE + 16#60400#);
  RNG_BASE : constant :=              (AHB2PERIPH_BASE + 16#60800#);

--  FSMC Bankx registers base address
  FSMC_Bank1_R_BASE : constant :=     (FSMC_R_BASE + 16#0000#);
  FSMC_Bank1E_R_BASE : constant :=    (FSMC_R_BASE + 16#0104#);
  FSMC_Bank2_R_BASE : constant :=     (FSMC_R_BASE + 16#0060#);
  FSMC_Bank3_R_BASE : constant :=     (FSMC_R_BASE + 16#0080#);
  FSMC_Bank4_R_BASE : constant :=     (FSMC_R_BASE + 16#00A0#);

end Stm32.Defines;
