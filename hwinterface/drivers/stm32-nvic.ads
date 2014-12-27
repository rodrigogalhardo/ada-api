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

--****c* Stm32.NVIC/Stm32.NVIC
--
--  NAME
--    Stm32.NVIC - The Nested Vectored Interrupt Controller package.
--  COPYRIGHT
--    (c) 2014 by Julien Brette & Julien Romero
--  SYNOPSIS
--    with Stm32.NVIC;
--  DESCRIPTION
--    This package is used to manage the interrupts for the stm.
--  AUTHOR
--    Julien Brette & Julien Romero
--  USES
--    Ada.Interrupts
--*****

package Stm32.NVIC is

--****c* Stm32.NVIC/IRQn_Type
--
--  NAME
--    IRQn_Type -- The number of this interrupt.
--  USAGE
--    It is the same than Interrupt_ID in the Ada.Interrupts package, a number
--which represents the interrupt.
--  SEE ALSO
--    Ada.Interrupts/Interrupt_ID
--
--*****

  subtype IRQn_Type is Interrupt_ID;

  --------------------------------------------
  -- Cortex-M4 Processor Exceptions Numbers --
  --------------------------------------------

--****d* Stm32.NVIC/NonMaskableInt_IRQn
--
--  NAME
--    NonMaskableInt_IRQn -- A Cortex-M4 Processor Exception
--  USAGE
--    Non Maskable Interrupt. Use as a IRQn_Type.
--
--*****

  -- 2 Non Maskable Interrupt
  NonMaskableInt_IRQn         : constant IRQn_Type := 2;

--****d* Stm32.NVIC/MemoryManagement_IRQn
--
--  NAME
--    MemoryManagement_IRQn -- A Cortex-M4 Processor Exception
--  USAGE
--    Cortex-M4 Memory Management Interrupt. Use as a IRQn_Type.
--  SEE ALSO
--    IRQn_Type
--
--*****

  -- 4 Cortex-M4 Memory Management Interrupt
  MemoryManagement_IRQn       : constant IRQn_Type := 4;

--****d* Stm32.NVIC/BusFault_IRQn
--
--  NAME
--    BusFault_IRQn -- A Cortex-M4 Processor Exception
--  USAGE
--    Cortex-M4 Bus Fault Interrupt. Use as a IRQn_Type.
--  SEE ALSO
--    IRQn_Type
--
--*****

  -- 5 Cortex-M4 Bus Fault Interrupt
  BusFault_IRQn               : constant IRQn_Type := 5;

--****d* Stm32.NVIC/UsageFault_IRQn
--
--  NAME
--    UsageFault_IRQn -- A Cortex-M4 Processor Exception
--  USAGE
--    Cortex-M4 Usage Fault Interrupt. Use as a IRQn_Type.
--  SEE ALSO
--    IRQn_Type
--
--*****

  -- 6 Cortex-M4 Usage Fault Interrupt
  UsageFault_IRQn             : constant IRQn_Type := 6;

--****d* Stm32.NVIC/SVCall_IRQn
--
--  NAME
--    SVCall_IRQn -- A Cortex-M4 Processor Exception
--  USAGE
--    Cortex-M4 SV Call Interrupt. Use as a IRQn_Type
--  SEE ALSO
--    IRQn_Type
--
--*****

  -- 11 Cortex-M4 SV Call Interrupt
  SVCall_IRQn                 : constant IRQn_Type := 11;

--****d* Stm32.NVIC/DebugMonitor_IRQn
--
--  NAME
--    DebugMonitor_IRQn -- A Cortex-M4 Processor Exception
--  USAGE
--    Cortex-M4 Debug Monitor Interrupt. Use as a IRQn_Type.
--  SEE ALSO
--    IRQn_Type
--
--*****

  -- 12 Cortex-M4 Debug Monitor Interrupt
  DebugMonitor_IRQn           : constant IRQn_Type := 12;

--****d* Stm32.NVIC/PendSV_IRQn
--
--  NAME
--    PendSV_IRQn -- A Cortex-M4 Processor Exception
--  USAGE
--    Cortex-M4 Pend SV Interrupt. Use as a IRQn_Type.
--  SEE ALSO
--    IRQn_Type
--
--*****

  -- 14 Cortex-M4 Pend SV Interrupt
  PendSV_IRQn                 : constant IRQn_Type := 14;

--****d* Stm32.NVIC/SysTick_IRQn
--
--  NAME
--    SysTick_IRQn -- A Cortex-M4 Processor Exception
--  USAGE
--    Cortex-M4 System Tick Interrupt. Use as a IRQn_Type.
--  SEE ALSO
--    IRQn_Type
--
--*****

  -- 15 Cortex-M4 System Tick Interrupt
  SysTick_IRQn                : constant IRQn_Type := 15;

  --------------------------------------
  -- STM32 specific Interrupt Numbers --
  --------------------------------------

--****d* Stm32.NVIC/WWDG_IRQn
--
--  NAME
--    WWDG_IRQn -- A STM32 specific Interrupt Numbers
--  USAGE
--    Window WatchDog Interrupt. Use as a IRQn_Type.
--  SEE ALSO
--    IRQn_Type
--
--*****

  -- Window WatchDog Interrupt
  WWDG_IRQn               : constant IRQn_Type := 16;

--****d* Stm32.NVIC/PVD_IRQn
--
--  NAME
--    PVD_IRQn -- A STM32 specific Interrupt Numbers
--  USAGE
--    PVD through EXTI Line detection Interrupt. Use as a IRQn_Type.
--  SEE ALSO
--    IRQn_Type
--
--*****

  -- PVD through EXTI Line detection Interrupt
  PVD_IRQn                : constant IRQn_Type := 17;

--****d* Stm32.NVIC/TAMP_STAMP_IRQn
--
--  NAME
--    TAMP_STAMP_IRQn -- A STM32 specific Interrupt Numbers
--  USAGE
--    Tamper and TimeStamp interrupts through the EXTI line. Use as a IRQn_Type.
--  SEE ALSO
--    IRQn_Type
--
--*****

  -- Tamper and TimeStamp interrupts through the EXTI line
  TAMP_STAMP_IRQn         : constant IRQn_Type := 18;

--****d* Stm32.NVIC/RTC_WKUP_IRQn
--
--  NAME
--    RTC_WKUP_IRQn -- A STM32 specific Interrupt Numbers
--  USAGE
--    RTC Wakeup interrupt through the EXTI line. Use as a IRQn_Type.
--  SEE ALSO
--    IRQn_Type
--
--*****

  -- RTC Wakeup interrupt through the EXTI line
  RTC_WKUP_IRQn           : constant IRQn_Type := 19;

--****d* Stm32.NVIC/FLASH_IRQn
--
--  NAME
--    FLASH_IRQn -- A STM32 specific Interrupt Numbers
--  USAGE
--    FLASH global Interrupt. Use as a IRQn_Type.
--  SEE ALSO
--    IRQn_Type
--
--*****

  -- FLASH global Interrupt
  FLASH_IRQn              : constant IRQn_Type := 20;

--****d* Stm32.NVIC/RCC_IRQn
--
--  NAME
--    RCC_IRQn -- A STM32 specific Interrupt Numbers
--  USAGE
--    RCC global Interrupt. Use as a IRQn_Type.
--  SEE ALSO
--    IRQn_Type
--
--*****

  -- RCC global Interrupt
  RCC_IRQn                : constant IRQn_Type := 21;

--****d* Stm32.NVIC/EXTI0_IRQn
--
--  NAME
--    EXTI0_IRQn -- A STM32 specific Interrupt Numbers
--  USAGE
--    EXTI Line0 Interrupt. Use as a IRQn_Type.
--  SEE ALSO
--    IRQn_Type
--
--*****

  -- EXTI Line0 Interrupt
  EXTI0_IRQn              : constant IRQn_Type := 22;

--****d* Stm32.NVIC/EXTI1_IRQn
--
--  NAME
--    EXTI1_IRQn -- A STM32 specific Interrupt Numbers
--  USAGE
--    EXTI Line1 Interrupt. Use as a IRQn_Type.
--  SEE ALSO
--    IRQn_Type
--
--*****

  -- EXTI Line1 Interrupt
  EXTI1_IRQn              : constant IRQn_Type := 23;

--****d* Stm32.NVIC/EXTI2_IRQn
--
--  NAME
--    EXTI2_IRQn -- A STM32 specific Interrupt Numbers
--  USAGE
--    EXTI Line2 Interrupt. Use as a IRQn_Type.
--  SEE ALSO
--    IRQn_Type
--
--*****

  -- EXTI Line2 Interrupt
  EXTI2_IRQn              : constant IRQn_Type := 24;

--****d* Stm32.NVIC/EXTI3_IRQn
--
--  NAME
--    EXTI3_IRQn -- A STM32 specific Interrupt Numbers
--  USAGE
--    EXTI Line3 Interrupt. Use as a IRQn_Type.
--  SEE ALSO
--    IRQn_Type
--
--*****

  -- EXTI Line3 Interrupt
  EXTI3_IRQn              : constant IRQn_Type := 25;

--****d* Stm32.NVIC/EXTI4_IRQn
--
--  NAME
--    EXTI4_IRQn -- A STM32 specific Interrupt Numbers
--  USAGE
--    EXTI Line4 Interrupt. Use as a IRQn_Type.
--  SEE ALSO
--    IRQn_Type
--
--*****

  -- EXTI Line4 Interrupt
  EXTI4_IRQn              : constant IRQn_Type := 26;

--****d* Stm32.NVIC/DMA1_Stream0_IRQn
--
--  NAME
--     DMA1_Stream0_IRQn -- A STM32 specific Interrupt Numbers
--  USAGE
--    DMA1 Stream 0 global Interrupt. Use as a IRQn_Type.
--  SEE ALSO
--    IRQn_Type
--
--*****

  -- DMA1 Stream 0 global Interrupt
  DMA1_Stream0_IRQn       : constant IRQn_Type := 27;

--****d* Stm32.NVIC/DMA1_Stream1_IRQn
--
--  NAME
--    DMA1_Stream1_IRQn -- A STM32 specific Interrupt Numbers
--  USAGE
--    DMA1 Stream 1 global Interrupt. Use as a IRQn_Type.
--  SEE ALSO
--    IRQn_Type
--
--*****

  -- DMA1 Stream 1 global Interrupt
  DMA1_Stream1_IRQn       : constant IRQn_Type := 28;

--****d* Stm32.NVIC/DMA1_Stream2_IRQn
--
--  NAME
--    DMA1_Stream2_IRQn -- A STM32 specific Interrupt Numbers
--  USAGE
--    DMA1 Stream 2 global Interrupt. Use as a IRQn_Type.
--  SEE ALSO
--    IRQn_Type
--
--*****

  -- DMA1 Stream 2 global Interrupt
  DMA1_Stream2_IRQn       : constant IRQn_Type := 29;

--****d* Stm32.NVIC/DMA1_Stream3_IRQn
--
--  NAME
--    DMA1_Stream3_IRQn -- A STM32 specific Interrupt Numbers
--  USAGE
--    DMA1 Stream 3 global Interrupt. Use as a IRQn_Type.
--  SEE ALSO
--    IRQn_Type
--
--*****

  -- DMA1 Stream 3 global Interrupt
  DMA1_Stream3_IRQn       : constant IRQn_Type := 30;

--****d* Stm32.NVIC/DMA1_Stream4_IRQn
--
--  NAME
--    DMA1_Stream4_IRQn -- A STM32 specific Interrupt Numbers
--  USAGE
--    DMA1 Stream 4 global Interrupt. Use as a IRQn_Type.
--  SEE ALSO
--    IRQn_Type
--
--*****

  -- DMA1 Stream 4 global Interrupt
  DMA1_Stream4_IRQn       : constant IRQn_Type := 31;

--****d* Stm32.NVIC/DMA1_Stream5_IRQn
--
--  NAME
--    DMA1_Stream5_IRQn -- A STM32 specific Interrupt Numbers
--  USAGE
--    DMA1 Stream 5 global Interrupt. Use as a IRQn_Type.
--  SEE ALSO
--    IRQn_Type
--
--*****

  -- DMA1 Stream 5 global Interrupt
  DMA1_Stream5_IRQn       : constant IRQn_Type := 32;

--****d* Stm32.NVIC/DMA1_Stream6_IRQn
--
--  NAME
--    DMA1_Stream6_IRQn -- A STM32 specific Interrupt Numbers
--  USAGE
--    DMA1 Stream 6 global Interrupt. Use as a IRQn_Type.
--  SEE ALSO
--    IRQn_Type
--
--*****

  -- DMA1 Stream 6 global Interrupt
  DMA1_Stream6_IRQn       : constant IRQn_Type := 33;

--****d* Stm32.NVIC/ADC_IRQn
--
--  NAME
--    ADC_IRQn -- A STM32 specific Interrupt Numbers
--  USAGE
--    ADC1, ADC2 and ADC3 global Interrupts. Use as a IRQn_Type.
--  SEE ALSO
--    IRQn_Type
--
--*****

  -- ADC1, ADC2 and ADC3 global Interrupts
  ADC_IRQn                : constant IRQn_Type := 34;

--****d* Stm32.NVIC/CAN1_TX_IRQn
--
--  NAME
--    CAN1_TX_IRQn -- A STM32 specific Interrupt Numbers
--  USAGE
--    CAN1 TX Interrupt. Use as a IRQn_Type.
--  SEE ALSO
--    IRQn_Type
--
--*****

  -- CAN1 TX Interrupt
  CAN1_TX_IRQn            : constant IRQn_Type := 35;

--****d* Stm32.NVIC/CAN1_RX0_IRQn
--
--  NAME
--    CAN1_RX0_IRQn -- A STM32 specific Interrupt Numbers
--  USAGE
--    CAN1 RX0 Interrupt. Use as a IRQn_Type.
--  SEE ALSO
--    IRQn_Type
--
--*****

  -- CAN1 RX0 Interrupt
  CAN1_RX0_IRQn           : constant IRQn_Type := 36;

--****d* Stm32.NVIC/CAN1_RX1_IRQn
--
--  NAME
--    CAN1_RX1_IRQn -- A STM32 specific Interrupt Numbers
--  USAGE
--    CAN1 RX1 Interrupt. Use as a IRQn_Type.
--  SEE ALSO
--    IRQn_Type
--
--*****

  -- CAN1 RX1 Interrupt
  CAN1_RX1_IRQn           : constant IRQn_Type := 37;

--****d* Stm32.NVIC/CAN1_SCE_IRQn
--
--  NAME
--    CAN1_SCE_IRQn -- A STM32 specific Interrupt Numbers
--  USAGE
--    CAN1 SCE Interrupt. Use as a IRQn_Type.
--  SEE ALSO
--    IRQn_Type
--
--*****

  -- CAN1 SCE Interrupt
  CAN1_SCE_IRQn           : constant IRQn_Type := 38;

--****d* Stm32.NVIC/EXTI9_5_IRQn
--
--  NAME
--    EXTI9_5_IRQn -- A STM32 specific Interrupt Numbers
--  USAGE
--    External Line[9:5] Interrupts. Use as a IRQn_Type.
--  SEE ALSO
--    IRQn_Type
--
--*****

  -- External Line[9:5] Interrupts
  EXTI9_5_IRQn            : constant IRQn_Type := 39;

--****d* Stm32.NVIC/TIM1_BRK_TIM9_IRQn
--
--  NAME
--    TIM1_BRK_TIM9_IRQn -- A STM32 specific Interrupt Numbers
--  USAGE
--    TIM1 Break interrupt and TIM9 global interrupt. Use as a IRQn_Type.
--  SEE ALSO
--    IRQn_Type
--
--*****

  -- TIM1 Break interrupt and TIM9 global interrupt
  TIM1_BRK_TIM9_IRQn      : constant IRQn_Type := 40;

--****d* Stm32.NVIC/TIM1_UP_TIM10_IRQn
--
--  NAME
--    TIM1_UP_TIM10_IRQn -- A STM32 specific Interrupt Numbers
--  USAGE
--    TIM1 Update Interrupt and TIM10 global interrupt. Use as a IRQn_Type.
--  SEE ALSO
--    IRQn_Type
--
--*****

  -- TIM1 Update Interrupt and TIM10 global interrupt
  TIM1_UP_TIM10_IRQn      : constant IRQn_Type := 41;

--****d* Stm32.NVIC/TIM1_TRG_COM_TIM11_IRQn
--
--  NAME
--    TIM1_TRG_COM_TIM11_IRQn -- A STM32 specific Interrupt Numbers
--  USAGE
--    TIM1 Trigger and Commutation Interrupt and TIM11 global interrupt. Use as a IRQn_Type.
--  SEE ALSO
--    IRQn_Type
--
--*****

  -- TIM1 Trigger and Commutation Interrupt and TIM11 global interrupt
  TIM1_TRG_COM_TIM11_IRQn : constant IRQn_Type := 42;

--****d* Stm32.NVIC/TIM1_CC_IRQn
--
--  NAME
--    TIM1_CC_IRQn -- A STM32 specific Interrupt Numbers
--  USAGE
--    TIM1 Capture Compare Interrupt. Use as a IRQn_Type.
--  SEE ALSO
--    IRQn_Type
--
--*****

  -- TIM1 Capture Compare Interrupt
  TIM1_CC_IRQn            : constant IRQn_Type := 43;

--****d* Stm32.NVIC/TIM2_IRQn
--
--  NAME
--    TIM2_IRQn -- A STM32 specific Interrupt Numbers
--  USAGE
--    TIM2 global Interrupt. Use as a IRQn_Type.
--  SEE ALSO
--    IRQn_Type
--
--*****

  -- TIM2 global Interrupt
  TIM2_IRQn               : constant IRQn_Type := 44;

--****d* Stm32.NVIC/TIM3_IRQn
--
--  NAME
--    TIM3_IRQn -- A STM32 specific Interrupt Numbers
--  USAGE
--    TIM3 global Interrupt. Use as a IRQn_Type.
--  SEE ALSO
--    IRQn_Type
--
--*****

  -- TIM3 global Interrupt
  TIM3_IRQn               : constant IRQn_Type := 45;

--****d* Stm32.NVIC/TIM4_IRQn
--
--  NAME
--    TIM4_IRQn -- A STM32 specific Interrupt Numbers
--  USAGE
--    TIM4 global Interrupt. Use as a IRQn_Type.
--  SEE ALSO
--    IRQn_Type
--
--*****

  -- TIM4 global Interrupt
  TIM4_IRQn               : constant IRQn_Type := 46;

--****d* Stm32.NVIC/I2C1_EV_IRQn
--
--  NAME
--    I2C1_EV_IRQn -- A STM32 specific Interrupt Numbers
--  USAGE
--    I2C1 Event Interrupt. Use as a IRQn_Type.
--  SEE ALSO
--    IRQn_Type
--
--*****

  -- I2C1 Event Interrupt
  I2C1_EV_IRQn            : constant IRQn_Type := 47;

--****d* Stm32.NVIC/I2C1_ER_IRQn
--
--  NAME
--    I2C1_ER_IRQn -- A STM32 specific Interrupt Numbers
--  USAGE
--    I2C1 Error Interrupt. Use as a IRQn_Type.
--  SEE ALSO
--    IRQn_Type
--
--*****

  -- I2C1 Error Interrupt
  I2C1_ER_IRQn            : constant IRQn_Type := 48;

--****d* Stm32.NVIC/I2C2_EV_IRQn
--
--  NAME
--    I2C2_EV_IRQn -- A STM32 specific Interrupt Numbers
--  USAGE
--    I2C2 Event Interrupt. Use as a IRQn_Type.
--  SEE ALSO
--    IRQn_Type
--
--*****

  -- I2C2 Event Interrupt
  I2C2_EV_IRQn            : constant IRQn_Type := 49;

--****d* Stm32.NVIC/I2C2_ER_IRQn
--
--  NAME
--    I2C2_ER_IRQn -- A STM32 specific Interrupt Numbers
--  USAGE
--    I2C2 Error Interrupt. Use as a IRQn_Type.
--  SEE ALSO
--    IRQn_Type
--
--*****

  -- I2C2 Error Interrupt
  I2C2_ER_IRQn            : constant IRQn_Type := 50;

--****d* Stm32.NVIC/SPI1_IRQn
--
--  NAME
--    SPI1_IRQn -- A STM32 specific Interrupt Numbers
--  USAGE
--    SPI1 global Interrupt. Use as a IRQn_Type.
--  SEE ALSO
--    IRQn_Type
--
--*****

  -- SPI1 global Interrupt
  SPI1_IRQn               : constant IRQn_Type := 51;

--****d* Stm32.NVIC/SPI2_IRQn
--
--  NAME
--    SPI2_IRQn -- A STM32 specific Interrupt Numbers
--  USAGE
--    SPI2 global Interrupt. Use as a IRQn_Type.
--  SEE ALSO
--    IRQn_Type
--
--*****

  -- SPI2 global Interrupt
  SPI2_IRQn               : constant IRQn_Type := 52;

--****d* Stm32.NVIC/USART1_IRQn
--
--  NAME
--    USART1_IRQn -- A STM32 specific Interrupt Numbers
--  USAGE
--    USART1 global Interrupt. Use as a IRQn_Type.
--  SEE ALSO
--    IRQn_Type
--
--*****

  -- USART1 global Interrupt
  USART1_IRQn             : constant IRQn_Type := 53;

--****d* Stm32.NVIC/USART2_IRQn
--
--  NAME
--    USART2_IRQn -- A STM32 specific Interrupt Numbers
--  USAGE
--    USART2 global Interrupt. Use as a IRQn_Type.
--  SEE ALSO
--    IRQn_Type
--
--*****

  -- USART2 global Interrupt
  USART2_IRQn             : constant IRQn_Type := 54;

--****d* Stm32.NVIC/USART3_IRQn
--
--  NAME
--    USART3_IRQn -- A STM32 specific Interrupt Numbers
--  USAGE
--    USART3 global Interrupt. Use as a IRQn_Type.
--  SEE ALSO
--    IRQn_Type
--
--*****

  -- USART3 global Interrupt
  USART3_IRQn             : constant IRQn_Type := 55;

--****d* Stm32.NVIC/EXTI15_10_IRQn
--
--  NAME
--    EXTI15_10_IRQn -- A STM32 specific Interrupt Numbers
--  USAGE
--    External Line[15:10] Interrupts. Use as a IRQn_Type.
--  SEE ALSO
--    IRQn_Type
--
--*****

  -- External Line[15:10] Interrupts
  EXTI15_10_IRQn          : constant IRQn_Type := 56;

--****d* Stm32.NVIC/RTC_Alarm_IRQn
--
--  NAME
--    RTC_Alarm_IRQn -- A STM32 specific Interrupt Numbers
--  USAGE
--    RTC Alarm (A and B) through EXTI Line Interrupt. Use as a IRQn_Type.
--  SEE ALSO
--    IRQn_Type
--
--*****

  -- RTC Alarm (A and B) through EXTI Line Interrupt
  RTC_Alarm_IRQn          : constant IRQn_Type := 57;

--****d* Stm32.NVIC/OTG_FS_WKUP_IRQn
--
--  NAME
--    OTG_FS_WKUP_IRQn -- A STM32 specific Interrupt Numbers
--  USAGE
--    USB OTG FS Wakeup through EXTI line interrupt. Use as a IRQn_Type.
--  SEE ALSO
--    IRQn_Type
--
--*****

  -- USB OTG FS Wakeup through EXTI line interrupt
  OTG_FS_WKUP_IRQn        : constant IRQn_Type := 58;

--****d* Stm32.NVIC/TIM8_BRK_TIM12_IRQn
--
--  NAME
--    TIM8_BRK_TIM12_IRQn -- A STM32 specific Interrupt Numbers
--  USAGE
--    TIM8 Break Interrupt and TIM12 global interrupt. Use as a IRQn_Type.
--  SEE ALSO
--    IRQn_Type
--
--*****

  -- TIM8 Break Interrupt and TIM12 global interrupt
  TIM8_BRK_TIM12_IRQn     : constant IRQn_Type := 59;

--****d* Stm32.NVIC/TIM8_UP_TIM13_IRQn
--
--  NAME
--    TIM8_UP_TIM13_IRQn -- A STM32 specific Interrupt Numbers
--  USAGE
--    TIM8 Update Interrupt and TIM13 global interrupt. Use as a IRQn_Type.
--  SEE ALSO
--    IRQn_Type
--
--*****

  -- TIM8 Update Interrupt and TIM13 global interrupt
  TIM8_UP_TIM13_IRQn      : constant IRQn_Type := 60;

--****d* Stm32.NVIC/TIM8_TRG_COM_TIM14_IRQn
--
--  NAME
--    TIM8_TRG_COM_TIM14_IRQn -- A STM32 specific Interrupt Numbers
--  USAGE
--    TIM8 Trigger and Commutation Interrupt and TIM14 global interrupt. Use as a IRQn_Type.
--  SEE ALSO
--    IRQn_Type
--
--*****

  -- TIM8 Trigger and Commutation Interrupt and TIM14 global interrupt
  TIM8_TRG_COM_TIM14_IRQn : constant IRQn_Type := 61;

--****d* Stm32.NVIC/TIM8_CC_IRQn
--
--  NAME
--    TIM8_CC_IRQn -- A STM32 specific Interrupt Numbers
--  USAGE
--    TIM8 Capture Compare Interrupt. Use as a IRQn_Type.
--  SEE ALSO
--    IRQn_Type
--
--*****

  -- TIM8 Capture Compare Interrupt
  TIM8_CC_IRQn            : constant IRQn_Type := 62;

--****d* Stm32.NVIC/DMA1_Stream7_IRQn
--
--  NAME
--    DMA1_Stream7_IRQn -- A STM32 specific Interrupt Numbers
--  USAGE
--    DMA1 Stream7 Interrupt. Use as a IRQn_Type.
--  SEE ALSO
--    IRQn_Type
--
--*****

  -- DMA1 Stream7 Interrupt
  DMA1_Stream7_IRQn       : constant IRQn_Type := 63;

--****d* Stm32.NVIC/FSMC_IRQn
--
--  NAME
--    FSMC_IRQn -- A STM32 specific Interrupt Numbers
--  USAGE
--    FSMC global Interrupt. Use as a IRQn_Type.
--  SEE ALSO
--    IRQn_Type
--
--*****

  -- FSMC global Interrupt
  FSMC_IRQn               : constant IRQn_Type := 64;

--****d* Stm32.NVIC/SDIO_IRQn
--
--  NAME
--    SDIO_IRQn -- A STM32 specific Interrupt Numbers
--  USAGE
--    SDIO global Interrupt. Use as a IRQn_Type.
--  SEE ALSO
--    IRQn_Type
--
--*****

  -- SDIO global Interrupt
  SDIO_IRQn               : constant IRQn_Type := 65;

--****d* Stm32.NVIC/TIM5_IRQn
--
--  NAME
--    TIM5_IRQn -- A STM32 specific Interrupt Numbers
--  USAGE
--    TIM5 global Interrupt. Use as a IRQn_Type.
--  SEE ALSO
--    IRQn_Type
--
--*****

  -- TIM5 global Interrupt
  TIM5_IRQn               : constant IRQn_Type := 66;

--****d* Stm32.NVIC/SPI3_IRQn
--
--  NAME
--    SPI3_IRQn -- A STM32 specific Interrupt Numbers
--  USAGE
--    SPI3 global Interrupt. Use as a IRQn_Type.
--  SEE ALSO
--    IRQn_Type
--
--*****

  -- SPI3 global Interrupt
  SPI3_IRQn               : constant IRQn_Type := 67;

--****d* Stm32.NVIC/UART4_IRQn
--
--  NAME
--    UART4_IRQn -- A STM32 specific Interrupt Numbers
--  USAGE
--    UART4 global Interrupt. Use as a IRQn_Type.
--  SEE ALSO
--    IRQn_Type
--
--*****

  -- UART4 global Interrupt
  UART4_IRQn              : constant IRQn_Type := 68;

--****d* Stm32.NVIC/UART5_IRQn
--
--  NAME
--    UART5_IRQn -- A STM32 specific Interrupt Numbers
--  USAGE
--    UART5 global Interrupt. Use as a IRQn_Type.
--  SEE ALSO
--    IRQn_Type
--
--*****

  -- UART5 global Interrupt
  UART5_IRQn              : constant IRQn_Type := 69;

--****d* Stm32.NVIC/TIM6_DAC_IRQn
--
--  NAME
--    TIM6_DAC_IRQn -- A STM32 specific Interrupt Numbers
--  USAGE
--    TIM6 global and DAC1&2 underrun error  interrupts. Use as a IRQn_Type.
--  SEE ALSO
--    IRQn_Type
--
--*****

  -- TIM6 global and DAC1&2 underrun error  interrupts
  TIM6_DAC_IRQn           : constant IRQn_Type := 70;

--****d* Stm32.NVIC/TIM7_IRQn
--
--  NAME
--    TIM7_IRQn -- A STM32 specific Interrupt Numbers
--  USAGE
--    TIM7 global interrupt. Use as a IRQn_Type.
--  SEE ALSO
--    IRQn_Type
--
--*****

  -- TIM7 global interrupt
  TIM7_IRQn               : constant IRQn_Type := 71;

--****d* Stm32.NVIC/DMA2_Stream0_IRQn
--
--  NAME
--    DMA2_Stream0_IRQn -- A STM32 specific Interrupt Numbers
--  USAGE
--    DMA2 Stream 0 global Interrupt. Use as a IRQn_Type.
--  SEE ALSO
--    IRQn_Type
--
--*****

  -- DMA2 Stream 0 global Interrupt
  DMA2_Stream0_IRQn       : constant IRQn_Type := 72;

--****d* Stm32.NVIC/DMA2_Stream1_IRQn
--
--  NAME
--    DMA2_Stream1_IRQn -- A STM32 specific Interrupt Numbers
--  USAGE
--    DMA2 Stream 1 global Interrupt. Use as a IRQn_Type.
--  SEE ALSO
--    IRQn_Type
--
--*****

  -- DMA2 Stream 1 global Interrupt
  DMA2_Stream1_IRQn       : constant IRQn_Type := 73;

--****d* Stm32.NVIC/DMA2_Stream2_IRQn
--
--  NAME
--    DMA2_Stream2_IRQn -- A STM32 specific Interrupt Numbers
--  USAGE
--    DMA2 Stream 2 global Interrupt. Use as a IRQn_Type.
--  SEE ALSO
--    IRQn_Type
--
--*****

  -- DMA2 Stream 2 global Interrupt
  DMA2_Stream2_IRQn       : constant IRQn_Type := 74;

--****d* Stm32.NVIC/DMA2_Stream3_IRQn
--
--  NAME
--    DMA2_Stream3_IRQn -- A STM32 specific Interrupt Numbers
--  USAGE
--    DMA2 Stream 3 global Interrupt. Use as a IRQn_Type.
--  SEE ALSO
--    IRQn_Type
--
--*****

  -- DMA2 Stream 3 global Interrupt
  DMA2_Stream3_IRQn       : constant IRQn_Type := 75;

--****d* Stm32.NVIC/DMA2_Stream4_IRQn
--
--  NAME
--    DMA2_Stream4_IRQn -- A STM32 specific Interrupt Numbers
--  USAGE
--    DMA2 Stream 4 global Interrupt. Use as a IRQn_Type.
--  SEE ALSO
--    IRQn_Type
--
--*****

  -- DMA2 Stream 4 global Interrupt
  DMA2_Stream4_IRQn       : constant IRQn_Type := 76;

--****d* Stm32.NVIC/ETH_IRQn
--
--  NAME
--    ETH_IRQn -- A STM32 specific Interrupt Numbers
--  USAGE
--    Ethernet global Interrupt. Use as a IRQn_Type.
--  SEE ALSO
--    IRQn_Type
--
--*****

  -- Ethernet global Interrupt
  ETH_IRQn                : constant IRQn_Type := 77;

--****d* Stm32.NVIC/ETH_WKUP_IRQn
--
--  NAME
--    ETH_WKUP_IRQn -- A STM32 specific Interrupt Numbers
--  USAGE
--    Ethernet Wakeup through EXTI line Interrupt. Use as a IRQn_Type.
--  SEE ALSO
--    IRQn_Type
--
--*****

  -- Ethernet Wakeup through EXTI line Interrupt
  ETH_WKUP_IRQn           : constant IRQn_Type := 78;

--****d* Stm32.NVIC/CAN2_TX_IRQn
--
--  NAME
--    CAN2_TX_IRQn -- A STM32 specific Interrupt Numbers
--  USAGE
--    CAN2 TX Interrupt. Use as a IRQn_Type.
--  SEE ALSO
--    IRQn_Type
--
--*****

  -- CAN2 TX Interrupt
  CAN2_TX_IRQn            : constant IRQn_Type := 79;

--****d* Stm32.NVIC/CAN2_RX0_IRQn
--
--  NAME
--    CAN2_RX0_IRQn -- A STM32 specific Interrupt Numbers
--  USAGE
--    CAN2 RX0 Interrupt. Use as a IRQn_Type.
--  SEE ALSO
--    IRQn_Type
--
--*****

  -- CAN2 RX0 Interrupt
  CAN2_RX0_IRQn           : constant IRQn_Type := 80;

--****d* Stm32.NVIC/CAN2_RX1_IRQn
--
--  NAME
--    CAN2_RX1_IRQn -- A STM32 specific Interrupt Numbers
--  USAGE
--    CAN2 RX1 Interrupt. Use as a IRQn_Type.
--  SEE ALSO
--    IRQn_Type
--
--*****

  -- CAN2 RX1 Interrupt
  CAN2_RX1_IRQn           : constant IRQn_Type := 81;

--****d* Stm32.NVIC/CAN2_SCE_IRQn
--
--  NAME
--    CAN2_SCE_IRQn -- A STM32 specific Interrupt Numbers
--  USAGE
--    CAN2 SCE Interrupt. Use as a IRQn_Type.
--  SEE ALSO
--    IRQn_Type
--
--*****

  -- CAN2 SCE Interrupt
  CAN2_SCE_IRQn           : constant IRQn_Type := 82;

--****d* Stm32.NVIC/OTG_FS_IRQn
--
--  NAME
--    OTG_FS_IRQn -- A STM32 specific Interrupt Numbers
--  USAGE
--    USB OTG FS global Interrupt. Use as a IRQn_Type.
--  SEE ALSO
--    IRQn_Type
--
--*****

  -- USB OTG FS global Interrupt
  OTG_FS_IRQn             : constant IRQn_Type := 83;

--****d* Stm32.NVIC/DMA2_Stream5_IRQn
--
--  NAME
--    DMA2_Stream5_IRQn -- A STM32 specific Interrupt Numbers
--  USAGE
--    DMA2 Stream 5 global interrupt. Use as a IRQn_Type.
--  SEE ALSO
--    IRQn_Type
--
--*****

  -- DMA2 Stream 5 global interrupt
  DMA2_Stream5_IRQn       : constant IRQn_Type := 84;

--****d* Stm32.NVIC/DMA2_Stream6_IRQn
--
--  NAME
--    DMA2_Stream6_IRQn -- A STM32 specific Interrupt Numbers
--  USAGE
--    DMA2 Stream 6 global interrupt. Use as a IRQn_Type.
--  SEE ALSO
--    IRQn_Type
--
--*****

  -- DMA2 Stream 6 global interrupt
  DMA2_Stream6_IRQn       : constant IRQn_Type := 85;

--****d* Stm32.NVIC/DMA2_Stream7_IRQn
--
--  NAME
--    DMA2_Stream7_IRQn -- A STM32 specific Interrupt Numbers
--  USAGE
--    DMA2 Stream 7 global interrupt. Use as a IRQn_Type.
--  SEE ALSO
--    IRQn_Type
--
--*****

  -- DMA2 Stream 7 global interrupt
  DMA2_Stream7_IRQn       : constant IRQn_Type := 86;

--****d* Stm32.NVIC/USART6_IRQn
--
--  NAME
--    USART6_IRQn -- A STM32 specific Interrupt Numbers
--  USAGE
--    USART6 global interrupt. Use as a IRQn_Type.
--  SEE ALSO
--    IRQn_Type
--
--*****

  -- USART6 global interrupt
  USART6_IRQn             : constant IRQn_Type := 87;

--****d* Stm32.NVIC/I2C3_EV_IRQn
--
--  NAME
--    I2C3_EV_IRQn -- A STM32 specific Interrupt Numbers
--  USAGE
--    I2C3 event interrupt. Use as a IRQn_Type.
--  SEE ALSO
--    IRQn_Type
--
--*****

  -- I2C3 event interrupt
  I2C3_EV_IRQn            : constant IRQn_Type := 88;

--****d* Stm32.NVIC/I2C3_ER_IRQn
--
--  NAME
--    I2C3_ER_IRQn -- A STM32 specific Interrupt Numbers
--  USAGE
--    I2C3 error interrupt. Use as a IRQn_Type.
--  SEE ALSO
--    IRQn_Type
--
--*****

  -- I2C3 error interrupt
  I2C3_ER_IRQn            : constant IRQn_Type := 89;

--****d* Stm32.NVIC/OTG_HS_EP1_OUT_IRQn
--
--  NAME
--    OTG_HS_EP1_OUT_IRQn -- A STM32 specific Interrupt Numbers
--  USAGE
--    USB OTG HS End Point 1 Out global interrupt. Use as a IRQn_Type.
--  SEE ALSO
--    IRQn_Type
--
--*****

  -- USB OTG HS End Point 1 Out global interrupt
  OTG_HS_EP1_OUT_IRQn     : constant IRQn_Type := 90;

--****d* Stm32.NVIC/OTG_HS_EP1_IN_IRQn
--
--  NAME
--    OTG_HS_EP1_IN_IRQn -- A STM32 specific Interrupt Numbers
--  USAGE
--    USB OTG HS End Point 1 In global interrupt. Use as a IRQn_Type.
--  SEE ALSO
--    IRQn_Type
--
--*****

  -- USB OTG HS End Point 1 In global interrupt
  OTG_HS_EP1_IN_IRQn      : constant IRQn_Type := 91;

--****d* Stm32.NVIC/OTG_HS_WKUP_IRQn
--
--  NAME
--    OTG_HS_WKUP_IRQn -- A STM32 specific Interrupt Numbers
--  USAGE
--    USB OTG HS Wakeup through EXTI interrupt. Use as a IRQn_Type.
--  SEE ALSO
--    IRQn_Type
--
--*****

  -- USB OTG HS Wakeup through EXTI interrupt
  OTG_HS_WKUP_IRQn        : constant IRQn_Type := 92;

--****d* Stm32.NVIC/OTG_HS_IRQn
--
--  NAME
--    OTG_HS_IRQn -- A STM32 specific Interrupt Numbers
--  USAGE
--    USB OTG HS global interrupt. Use as a IRQn_Type.
--  SEE ALSO
--    IRQn_Type
--
--*****

  -- USB OTG HS global interrupt
  OTG_HS_IRQn             : constant IRQn_Type := 93;

--****d* Stm32.NVIC/DCMI_IRQn
--
--  NAME
--    DCMI_IRQn -- A STM32 specific Interrupt Numbers
--  USAGE
--    DCMI global interrupt. Use as a IRQn_Type.
--  SEE ALSO
--    IRQn_Type
--
--*****

  -- DCMI global interrupt
  DCMI_IRQn               : constant IRQn_Type := 94;

--****d* Stm32.NVIC/CRYP_IRQn
--
--  NAME
--    CRYP_IRQn -- A STM32 specific Interrupt Numbers
--  USAGE
--    CRYP crypto global interrupt. Use as a IRQn_Type.
--  SEE ALSO
--    IRQn_Type
--
--*****

  -- CRYP crypto global interrupt
  CRYP_IRQn               : constant IRQn_Type := 95;

--****d* Stm32.NVIC/HASH_RNG_IRQn
--
--  NAME
--    HASH_RNG_IRQn -- A STM32 specific Interrupt Numbers
--  USAGE
--    Hash and Rng global interrupt. Use as a IRQn_Type.
--  SEE ALSO
--    IRQn_Type
--
--*****

  -- Hash and Rng global interrupt
  HASH_RNG_IRQn           : constant IRQn_Type := 96;

--****d* Stm32.NVIC/FPU_IRQn
--
--  NAME
--    FPU_IRQn -- A STM32 specific Interrupt Numbers
--  USAGE
--    FPU global interrupt. Use as a IRQn_Type.
--  SEE ALSO
--    IRQn_Type
--
--*****

  -- FPU global interrupt
  FPU_IRQn                : constant IRQn_Type := 97;

--****t* Stm32.NVIC/IRQ_Priority
--
--  NAME
--    IRQ_Priority -- Priority of the interrupt.
--  USAGE
--    This is the priority of the interrupt, an integer between 0 and 15.
--
--*****

  type IRQ_Priority is new Integer range 0 .. 15;

--****f* Stm32.NVIC/EnableIRQ
--
--  NAME
--    EnableIRQ -- Enable an interrupt.
--  SYNOPSIS
--    EnableIRQ(IRQn);
--  FUNCTION
--    Enable the given interrupt.
--  INPUTS
--    IRQn - The number of the interrupt, of type IRQn_Type.
--  SEE ALSO
--    IRQn_Type
--
--*****

  procedure EnableIRQ (IRQn : IRQn_Type);
  pragma Import (C, EnableIRQ, "NVIC_EnableIRQ");

--****f* Stm32.NVIC/DisableIRQ
--
--  NAME
--    DisableIRQ -- Disable an interrupt.
--  SYNOPSIS
--    DisableIRQ(IRQn);
--  FUNCTION
--    Disable the given interrupt.
--  INPUTS
--    IRQn - The number of the interrupt, of type IRQn_Type.
--  SEE ALSO
--    IRQn_Type
--
--*****

  procedure DisableIRQ (IRQn : IRQn_Type);
  pragma Import (C, DisableIRQ, "NVIC_DisableIRQ");

--****f* Stm32.NVIC/GetPendingIRQ
--
--  NAME
--    GetPendingIRQ -- Get the state of an interrupt.
--  SYNOPSIS
--    value := GetPendingIRQ(IRQn);
--  FUNCTION
--    Says if the given interrupt is activated or not.
--  INPUTS
--    IRQn - The number of the interrupt, of type IRQn_Type.
--  RESULT
--    value - A Boolean representing the state of the interrupt.
--  SEE ALSO
--    IRQn_Type
--
--*****

  function GetPendingIRQ (IRQn : IRQn_Type) return Boolean;
  pragma Inline (GetPendingIRQ);

--****f* Stm32.NVIC/NVIC_Init
--
--  NAME
--    NVIC_Init -- Initialize the interrupt.
--  SYNOPSIS
--    NVIC_Init(IRQn, Priority);
--  FUNCTION
--    Initialize an interrupt with the given priority.
--  INPUTS
--    IRQn     - The number of the interrupt to initialize, of type IRQn_Type.
--    Priority - The priority of the interrupt, of type IRQ_Priority
--  SEE ALSO
--    IRQn_Type, IRQ_Priority
--
--*****

  procedure NVIC_Init (IRQn: IRQn_Type; Priority : IRQ_Priority);

end Stm32.NVIC;
