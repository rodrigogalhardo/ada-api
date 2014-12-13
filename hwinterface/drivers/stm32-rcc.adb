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

package body Stm32.RCC is

  Periph_Values : constant array (Stm_Periph) of Integer :=
    (TIM2               => 16#00000001#,
     TIM3               => 16#00000002#,
     TIM4               => 16#00000004#,
     TIM5               => 16#00000008#,
     TIM6               => 16#00000010#,
     TIM7               => 16#00000020#,
     TIM12              => 16#00000040#,
     TIM13              => 16#00000080#,
     TIM14              => 16#00000100#,
     WWDG               => 16#00000800#,
     SPI2               => 16#00004000#,
     SPI3               => 16#00008000#,
     USART2             => 16#00020000#,
     USART3             => 16#00040000#,
     UART4              => 16#00080000#,
     UART5              => 16#00100000#,
     I2C1               => 16#00200000#,
     I2C2               => 16#00400000#,
     I2C3               => 16#00800000#,
     CAN1               => 16#02000000#,
     CAN2               => 16#04000000#,
     PWR                => 16#10000000#,
     DAC                => 16#20000000#,

     TIM1               => 16#00000001#,
     TIM8               => 16#00000002#,
     USART1             => 16#00000010#,
     USART6             => 16#00000020#,
     ADC                => 16#00000100#,
     ADC1               => 16#00000100#,
     ADC2               => 16#00000200#,
     ADC3               => 16#00000400#,
     SDIO               => 16#00000800#,
     SPI1               => 16#00001000#,
     SYSCFG             => 16#00004000#,
     TIM9               => 16#00010000#,
     TIM10              => 16#00020000#,
     TIM11              => 16#00040000#,

     GPIOA              => 16#00000001#,
     GPIOB              => 16#00000002#,
     GPIOC              => 16#00000004#,
     GPIOD              => 16#00000008#,
     GPIOE              => 16#00000010#,
     GPIOF              => 16#00000020#,
     GPIOG              => 16#00000040#,
     GPIOH              => 16#00000080#,
     GPIOI              => 16#00000100#,
     CRC                => 16#00001000#,
     FLITF              => 16#00008000#,
     SRAM1              => 16#00010000#,
     SRAM2              => 16#00020000#,
     BKPSRAM            => 16#00040000#,
     CCMDATARAMEN       => 16#00100000#,
     DMA1               => 16#00200000#,
     DMA2               => 16#00400000#,
     ETH_MAC            => 16#02000000#,
     ETH_MAC_Tx         => 16#04000000#,
     ETH_MAC_Rx         => 16#08000000#,
     ETH_MAC_PTP        => 16#10000000#,
     OTG_HS             => 16#20000000#,
     OTG_HS_ULPI        => 16#40000000#,

     DCMI               => 16#00000001#,
     CRYP               => 16#00000010#,
     HASH               => 16#00000020#,
     RNG                => 16#00000040#,
     OTG_FS             => 16#00000080#);

  procedure RCC_PeriphClockCmd (Periph : Stm_Periph; State : FunctionalState) is
    procedure RCC_APB1PeriphClockCmd (P : Integer; State : FunctionalState);
    pragma Import (C, RCC_APB1PeriphClockCmd, "RCC_APB1PeriphClockCmd");
    procedure RCC_APB2PeriphClockCmd (P : Integer; State : FunctionalState);
    pragma Import (C, RCC_APB2PeriphClockCmd, "RCC_APB2PeriphClockCmd");
    procedure RCC_AHB1PeriphClockCmd (P : Integer; State : FunctionalState);
    pragma Import (C, RCC_AHB1PeriphClockCmd, "RCC_AHB1PeriphClockCmd");
    procedure RCC_AHB2PeriphClockCmd (P : Integer; State : FunctionalState);
    pragma Import (C, RCC_AHB2PeriphClockCmd, "RCC_AHB2PeriphClockCmd");
  begin
    if Periph in APB1_Periph then
      RCC_APB1PeriphClockCmd (Periph_Values (Periph), State);
    elsif Periph in APB2_Periph then
      RCC_APB2PeriphClockCmd (Periph_Values (Periph), State);
    elsif Periph in AHB1_Periph then
      RCC_AHB1PeriphClockCmd (Periph_Values (Periph), State);
    elsif Periph in AHB2_Periph then
      RCC_AHB2PeriphClockCmd (Periph_Values (Periph), State);
    end if;
  end RCC_PeriphClockCmd;
end Stm32.RCC;
