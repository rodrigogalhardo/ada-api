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

with Ada.Interrupts; use Ada.Interrupts;

package Stm32.NVIC is

  subtype IRQn_Type is Interrupt_ID;

  --------------------------------------------
  -- Cortex-M4 Processor Exceptions Numbers --
  --------------------------------------------

  -- 2 Non Maskable Interrupt
  NonMaskableInt_IRQn         : constant IRQn_Type := 2;
  -- 4 Cortex-M4 Memory Management Interrupt
  MemoryManagement_IRQn       : constant IRQn_Type := 4;
  -- 5 Cortex-M4 Bus Fault Interrupt
  BusFault_IRQn               : constant IRQn_Type := 5;
  -- 6 Cortex-M4 Usage Fault Interrupt
  UsageFault_IRQn             : constant IRQn_Type := 6;
  -- 11 Cortex-M4 SV Call Interrupt
  SVCall_IRQn                 : constant IRQn_Type := 11;
  -- 12 Cortex-M4 Debug Monitor Interrupt
  DebugMonitor_IRQn           : constant IRQn_Type := 12;
  -- 14 Cortex-M4 Pend SV Interrupt
  PendSV_IRQn                 : constant IRQn_Type := 14;
  -- 15 Cortex-M4 System Tick Interrupt
  SysTick_IRQn                : constant IRQn_Type := 15;

  --------------------------------------
  -- STM32 specific Interrupt Numbers --
  --------------------------------------

  -- Window WatchDog Interrupt
  WWDG_IRQn               : constant IRQn_Type := 16;
  -- PVD through EXTI Line detection Interrupt
  PVD_IRQn                : constant IRQn_Type := 17;
  -- Tamper and TimeStamp interrupts through the EXTI line
  TAMP_STAMP_IRQn         : constant IRQn_Type := 18;
  -- RTC Wakeup interrupt through the EXTI line
  RTC_WKUP_IRQn           : constant IRQn_Type := 19;
  -- FLASH global Interrupt
  FLASH_IRQn              : constant IRQn_Type := 20;
  -- RCC global Interrupt
  RCC_IRQn                : constant IRQn_Type := 21;
  -- EXTI Line0 Interrupt
  EXTI0_IRQn              : constant IRQn_Type := 22;
  -- EXTI Line1 Interrupt
  EXTI1_IRQn              : constant IRQn_Type := 23;
  -- EXTI Line2 Interrupt
  EXTI2_IRQn              : constant IRQn_Type := 24;
  -- EXTI Line3 Interrupt
  EXTI3_IRQn              : constant IRQn_Type := 25;
  -- EXTI Line4 Interrupt
  EXTI4_IRQn              : constant IRQn_Type := 26;
  -- DMA1 Stream 0 global Interrupt
  DMA1_Stream0_IRQn       : constant IRQn_Type := 27;
  -- DMA1 Stream 1 global Interrupt
  DMA1_Stream1_IRQn       : constant IRQn_Type := 28;
  -- DMA1 Stream 2 global Interrupt
  DMA1_Stream2_IRQn       : constant IRQn_Type := 29;
  -- DMA1 Stream 3 global Interrupt
  DMA1_Stream3_IRQn       : constant IRQn_Type := 30;
  -- DMA1 Stream 4 global Interrupt
  DMA1_Stream4_IRQn       : constant IRQn_Type := 31;
  -- DMA1 Stream 5 global Interrupt
  DMA1_Stream5_IRQn       : constant IRQn_Type := 32;
  -- DMA1 Stream 6 global Interrupt
  DMA1_Stream6_IRQn       : constant IRQn_Type := 33;
  -- ADC1, ADC2 and ADC3 global Interrupts
  ADC_IRQn                : constant IRQn_Type := 34;
  -- CAN1 TX Interrupt
  CAN1_TX_IRQn            : constant IRQn_Type := 35;
  -- CAN1 RX0 Interrupt
  CAN1_RX0_IRQn           : constant IRQn_Type := 36;
  -- CAN1 RX1 Interrupt
  CAN1_RX1_IRQn           : constant IRQn_Type := 37;
  -- CAN1 SCE Interrupt
  CAN1_SCE_IRQn           : constant IRQn_Type := 38;
  -- External Line[9:5] Interrupts
  EXTI9_5_IRQn            : constant IRQn_Type := 39;
  -- TIM1 Break interrupt and TIM9 global interrupt
  TIM1_BRK_TIM9_IRQn      : constant IRQn_Type := 40;
  -- TIM1 Update Interrupt and TIM10 global interrupt
  TIM1_UP_TIM10_IRQn      : constant IRQn_Type := 41;
  -- TIM1 Trigger and Commutation Interrupt and TIM11 global interrupt
  TIM1_TRG_COM_TIM11_IRQn : constant IRQn_Type := 42;
  -- TIM1 Capture Compare Interrupt
  TIM1_CC_IRQn            : constant IRQn_Type := 43;
  -- TIM2 global Interrupt
  TIM2_IRQn               : constant IRQn_Type := 44;
  -- TIM3 global Interrupt
  TIM3_IRQn               : constant IRQn_Type := 45;
  -- TIM4 global Interrupt
  TIM4_IRQn               : constant IRQn_Type := 46;
  -- I2C1 Event Interrupt
  I2C1_EV_IRQn            : constant IRQn_Type := 47;
  -- I2C1 Error Interrupt
  I2C1_ER_IRQn            : constant IRQn_Type := 48;
  -- I2C2 Event Interrupt
  I2C2_EV_IRQn            : constant IRQn_Type := 49;
  -- I2C2 Error Interrupt
  I2C2_ER_IRQn            : constant IRQn_Type := 50;
  -- SPI1 global Interrupt
  SPI1_IRQn               : constant IRQn_Type := 51;
  -- SPI2 global Interrupt
  SPI2_IRQn               : constant IRQn_Type := 52;
  -- USART1 global Interrupt
  USART1_IRQn             : constant IRQn_Type := 53;
  -- USART2 global Interrupt
  USART2_IRQn             : constant IRQn_Type := 54;
  -- USART3 global Interrupt
  USART3_IRQn             : constant IRQn_Type := 55;
  -- External Line[15:10] Interrupts
  EXTI15_10_IRQn          : constant IRQn_Type := 56;
  -- RTC Alarm (A and B) through EXTI Line Interrupt
  RTC_Alarm_IRQn          : constant IRQn_Type := 57;
  -- USB OTG FS Wakeup through EXTI line interrupt
  OTG_FS_WKUP_IRQn        : constant IRQn_Type := 58;
  -- TIM8 Break Interrupt and TIM12 global interrupt
  TIM8_BRK_TIM12_IRQn     : constant IRQn_Type := 59;
  -- TIM8 Update Interrupt and TIM13 global interrupt
  TIM8_UP_TIM13_IRQn      : constant IRQn_Type := 60;
  -- TIM8 Trigger and Commutation Interrupt and TIM14 global interrupt
  TIM8_TRG_COM_TIM14_IRQn : constant IRQn_Type := 61;
  -- TIM8 Capture Compare Interrupt
  TIM8_CC_IRQn            : constant IRQn_Type := 62;
  -- DMA1 Stream7 Interrupt
  DMA1_Stream7_IRQn       : constant IRQn_Type := 63;
  -- FSMC global Interrupt
  FSMC_IRQn               : constant IRQn_Type := 64;
  -- SDIO global Interrupt
  SDIO_IRQn               : constant IRQn_Type := 65;
  -- TIM5 global Interrupt
  TIM5_IRQn               : constant IRQn_Type := 66;
  -- SPI3 global Interrupt
  SPI3_IRQn               : constant IRQn_Type := 67;
  -- UART4 global Interrupt
  UART4_IRQn              : constant IRQn_Type := 68;
  -- UART5 global Interrupt
  UART5_IRQn              : constant IRQn_Type := 69;
  -- TIM6 global and DAC1&2 underrun error  interrupts
  TIM6_DAC_IRQn           : constant IRQn_Type := 70;
  -- TIM7 global interrupt
  TIM7_IRQn               : constant IRQn_Type := 71;
  -- DMA2 Stream 0 global Interrupt
  DMA2_Stream0_IRQn       : constant IRQn_Type := 72;
  -- DMA2 Stream 1 global Interrupt
  DMA2_Stream1_IRQn       : constant IRQn_Type := 73;
  -- DMA2 Stream 2 global Interrupt
  DMA2_Stream2_IRQn       : constant IRQn_Type := 74;
  -- DMA2 Stream 3 global Interrupt
  DMA2_Stream3_IRQn       : constant IRQn_Type := 75;
  -- DMA2 Stream 4 global Interrupt
  DMA2_Stream4_IRQn       : constant IRQn_Type := 76;
  -- Ethernet global Interrupt
  ETH_IRQn                : constant IRQn_Type := 77;
  -- Ethernet Wakeup through EXTI line Interrupt
  ETH_WKUP_IRQn           : constant IRQn_Type := 78;
  -- CAN2 TX Interrupt
  CAN2_TX_IRQn            : constant IRQn_Type := 79;
  -- CAN2 RX0 Interrupt
  CAN2_RX0_IRQn           : constant IRQn_Type := 80;
  -- CAN2 RX1 Interrupt
  CAN2_RX1_IRQn           : constant IRQn_Type := 81;
  -- CAN2 SCE Interrupt
  CAN2_SCE_IRQn           : constant IRQn_Type := 82;
  -- USB OTG FS global Interrupt
  OTG_FS_IRQn             : constant IRQn_Type := 83;
  -- DMA2 Stream 5 global interrupt
  DMA2_Stream5_IRQn       : constant IRQn_Type := 84;
  -- DMA2 Stream 6 global interrupt
  DMA2_Stream6_IRQn       : constant IRQn_Type := 85;
  -- DMA2 Stream 7 global interrupt
  DMA2_Stream7_IRQn       : constant IRQn_Type := 86;
  -- USART6 global interrupt
  USART6_IRQn             : constant IRQn_Type := 87;
  -- I2C3 event interrupt
  I2C3_EV_IRQn            : constant IRQn_Type := 88;
  -- I2C3 error interrupt
  I2C3_ER_IRQn            : constant IRQn_Type := 89;
  -- USB OTG HS End Point 1 Out global interrupt
  OTG_HS_EP1_OUT_IRQn     : constant IRQn_Type := 90;
  -- USB OTG HS End Point 1 In global interrupt
  OTG_HS_EP1_IN_IRQn      : constant IRQn_Type := 91;
  -- USB OTG HS Wakeup through EXTI interrupt
  OTG_HS_WKUP_IRQn        : constant IRQn_Type := 92;
  -- USB OTG HS global interrupt
  OTG_HS_IRQn             : constant IRQn_Type := 93;
  -- DCMI global interrupt
  DCMI_IRQn               : constant IRQn_Type := 94;
  -- CRYP crypto global interrupt
  CRYP_IRQn               : constant IRQn_Type := 95;
  -- Hash and Rng global interrupt
  HASH_RNG_IRQn           : constant IRQn_Type := 96;
  -- FPU global interrupt
  FPU_IRQn                : constant IRQn_Type := 97;

  type IRQ_Priority is new Integer range 0 .. 15;

  procedure EnableIRQ (IRQn : IRQn_Type);
  pragma Import (C, EnableIRQ, "NVIC_EnableIRQ");

  procedure DisableIRQ (IRQn : IRQn_Type);
  pragma Import (C, DisableIRQ, "NVIC_DisableIRQ");

  function GetPendingIRQ (IRQn : IRQn_Type) return Boolean;
  pragma Inline (GetPendingIRQ);

  procedure NVIC_Init (IRQn: IRQn_Type; Priority : IRQ_Priority);

end Stm32.NVIC;
