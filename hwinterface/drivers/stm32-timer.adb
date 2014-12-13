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
with Stm32.RCC; use Stm32.RCC;

package body Stm32.Timer is

  type TIM_TypeDef is new Unsigned_32;

  Timers : constant array (Timer_Number) of TIM_TypeDef :=
    (TIM1_BASE, TIM2_BASE, TIM3_BASE, TIM4_BASE, TIM5_BASE, TIM6_BASE,
     TIM7_BASE, TIM8_BASE, TIM9_BASE, TIM10_BASE, TIM11_BASE,
     TIM12_BASE, TIM13_BASE, TIM14_BASE);

  Periph : constant array (Timer_Number) of Stm_Periph :=
    (TIM1, TIM2, TIM3, TIM4, TIM5, TIM6, TIM7,
     TIM8, TIM9, TIM10, TIM11, TIM12, TIM13, TIM14);

  type OCPreload_Enable_Type is (Disable, Enable);
  for OCPreload_Enable_Type use (Disable => 0, Enable => 8);
  for OCPreload_Enable_Type'Size use 16;

  -------------
  -- Imports --
  -------------

  procedure TIM_DeInit (Timer : TIM_TypeDef);
  pragma Import (C, TIM_DeInit, "TIM_DeInit");

  procedure TIM_TimeBaseInit (Timer : TIM_TypeDef; Params : access Timer_Params);
  pragma Import (C, TIM_TimeBaseInit, "TIM_TimeBaseInit");

  procedure TIM_ARRPreloadConfig (Timer : TIM_TypeDef; State : FunctionalState);
  pragma Import (C, TIM_ARRPreloadConfig, "TIM_ARRPreloadConfig");

  procedure TIM_ITConfig (Timer : TIM_TypeDef; It : Timer_Interrupt_Source;
                          State : FunctionalState);
  pragma Import (C, TIM_ITConfig, "TIM_ITConfig");

  procedure TIM_Cmd (Timer : TIM_TypeDef; State : FunctionalState);
  pragma Import (C, TIM_Cmd, "TIM_Cmd");

  procedure TIM_ClearITPendingBit (Timer : TIM_TypeDef;
                                   It : Timer_Interrupt_Source);
  pragma Import (C, TIM_ClearITPendingBit, "TIM_ClearITPendingBit");

  procedure TIM_EncoderInterfaceConfig (Timer : TIM_TypeDef;
                                        Encoder_Mode : Encoder_Mode_Type;
                                        IC1_Polarity : ICPolarity_Type;
                                        IC2_Polarity : ICPolarity_Type);
  pragma Import (C, TIM_EncoderInterfaceConfig, "TIM_EncoderInterfaceConfig");

  procedure TIM_OC1Init (Timer : TIM_TypeDef;
                         Params : access Output_Channel_Params);
  pragma Import (C, TIM_OC1Init, "TIM_OC1Init");

  procedure TIM_OC2Init (Timer : TIM_TypeDef;
                         Params : access Output_Channel_Params);
  pragma Import (C, TIM_OC2Init, "TIM_OC2Init");

  procedure TIM_OC3Init (Timer : TIM_TypeDef;
                         Params : access Output_Channel_Params);
  pragma Import (C, TIM_OC3Init, "TIM_OC3Init");

  procedure TIM_OC4Init (Timer : TIM_TypeDef;
                         Params : access Output_Channel_Params);
  pragma Import (C, TIM_OC4Init, "TIM_OC4Init");

  procedure TIM_OC1PreloadConfig (Timer : TIM_TypeDef;
                                  Enable : OCPreload_Enable_Type);
  pragma Import (C, TIM_OC1PreloadConfig, "TIM_OC1PreloadConfig");

  procedure TIM_OC2PreloadConfig (Timer : TIM_TypeDef;
                                  Enable : OCPreload_Enable_Type);
  pragma Import (C, TIM_OC2PreloadConfig, "TIM_OC2PreloadConfig");

  procedure TIM_OC3PreloadConfig (Timer : TIM_TypeDef;
                                  Enable : OCPreload_Enable_Type);
  pragma Import (C, TIM_OC3PreloadConfig, "TIM_OC3PreloadConfig");

  procedure TIM_OC4PreloadConfig (Timer : TIM_TypeDef;
                                  Enable : OCPreload_Enable_Type);
  pragma Import (C, TIM_OC4PreloadConfig, "TIM_OC4PreloadConfig");

  procedure TIM_SetCompare1 (Timer : TIM_TypeDef; Value : Unsigned_32);
  pragma Import (C, TIM_SetCompare1, "TIM_SetCompare1");

  procedure TIM_SetCompare2 (Timer : TIM_TypeDef; Value : Unsigned_32);
  pragma Import (C, TIM_SetCompare2, "TIM_SetCompare2");

  procedure TIM_SetCompare3 (Timer : TIM_TypeDef; Value : Unsigned_32);
  pragma Import (C, TIM_SetCompare3, "TIM_SetCompare3");

  procedure TIM_SetCompare4 (Timer : TIM_TypeDef; Value : Unsigned_32);
  pragma Import (C, TIM_SetCompare4, "TIM_SetCompare4");

  function TIM_GetCounter (Timer : TIM_TypeDef) return Unsigned_32;
  pragma Import (C, TIM_GetCounter, "TIM_GetCounter");

  procedure TIM_CtrlPWMOutputs (Timer : TIM_TypeDef;
                                State : FunctionalState);
  pragma Import (C, TIM_CtrlPWMOutputs, "TIM_CtrlPWMOutputs");

  -----------------
  -- Reset_Timer --
  -----------------

  procedure Reset_Timer (Timer : Timer_Number) is
    Tim : constant TIM_TypeDef := Timers (Timer);
  begin
    TIM_DeInit (Tim);
  end Reset_Timer;

  ----------------
  -- Init_Timer --
  ----------------

  procedure Init_Timer (Timer : Timer_Number; Params : Timer_Params;
                        Interrupt : Timer_Interrupt_Source;
                        Priority : IRQ_Priority) is
    P : aliased Timer_Params := Params;
    Tim : constant TIM_TypeDef := Timers (Timer);
  begin
    RCC_PeriphClockCmd (Periph (Timer), Enable);
    TIM_TimeBaseInit (Tim, P'Access);
    TIM_ARRPreloadConfig (Tim, Enable);

    if Interrupt = Disable then
      TIM_ITConfig (Tim, Disable, Disable);
    else
      NVIC_Init (IRQ_Timer (Timer), Priority);
      TIM_ITConfig (Tim, Interrupt,  Enable);
    end if;
    TIM_Cmd (Tim, Enable);
    if Tim = Timers (8) then
      TIM_CtrlPWMOutputs (Tim, Enable);
    end if;
  end Init_Timer;

  ---------------------
  -- Clear_Interrupt --
  ---------------------

  procedure Clear_Interrupt (Timer : Timer_Number;
                             Interrupt : Timer_Interrupt_Source) is
  begin
    TIM_ClearITPendingBit (Timers (Timer), Interrupt);
  end Clear_Interrupt;

  -------------------
  -- Setup_Encoder --
  -------------------

  procedure Setup_Encoder (Timer : Timer_Number;
                           Encoder_Mode : Encoder_Mode_Type;
                           IC1_Polarity : ICPolarity_Type;
                           IC2_Polarity : ICPolarity_Type) is
  begin
    RCC_PeriphClockCmd (Periph (Timer), Enable);
    TIM_EncoderInterfaceConfig (Timers (Timer), Encoder_Mode,
                                IC1_Polarity, IC2_Polarity);
  end Setup_Encoder;

  --------------------------
  -- Setup_Output_Channel --
  --------------------------

  procedure Setup_Output_Channel (Timer : Timer_Number;
                                  Channel : Timer_Channel_Number;
                                  Params : Output_Channel_Params) is
    P : aliased Output_Channel_Params := Params;
    Tim : constant TIM_TypeDef := Timers (Timer);
  begin
    RCC_PeriphClockCmd (Periph (Timer), Enable);
    case Channel is
      when 1 =>
        TIM_OC1Init (Tim, P'Access);
        TIM_OC1PreloadConfig (Tim, Enable);
      when 2 =>
        TIM_OC2Init (Tim, P'Access);
        TIM_OC2PreloadConfig (Tim, Enable);
      when 3 =>
        TIM_OC3Init (Tim, P'Access);
        TIM_OC3PreloadConfig (Tim, Enable);
      when 4 =>
        TIM_OC4Init (Tim, P'Access);
        TIM_OC4PreloadConfig (Tim, Enable);
    end case;
  end Setup_Output_Channel;

  ----------------------------
  -- Configure_Encoder_Pins --
  ----------------------------

  procedure Configure_Encoder_Pins (Timer : Timer_Number; Pin1 : Pin_Type;
                                    Pin2 : Pin_Type) is
    GPIO : GPIO_Params;
  begin
    GPIO := (Pins        => (Mask => (others => False)),
             Mode        => Alternate,
             Speed       => Speed_50MHz,
             Output_Type => PP,
             PuPd        => Pull_Up);
    GPIO.Pins.Mask (Pin1.Pin) := True;
    Config_GPIO (Pin1.Port, GPIO);
    Config_GPIO_AF (Pin1.Port, Pin1.Pin, AF_Timer (Timer));

    GPIO := (Pins        => (Mask => (others => False)),
             Mode        => Alternate,
             Speed       => Speed_50MHz,
             Output_Type => PP,
             PuPd        => Pull_Up);
    GPIO.Pins.Mask (Pin2.Pin) := True;
    Config_GPIO (Pin2.Port, GPIO);
    Config_GPIO_AF (Pin2.Port, Pin2.Pin, AF_Timer (Timer));
  end Configure_Encoder_Pins;

  --------------------------
  -- Configure_Output_Pin --
  --------------------------

  procedure Configure_Output_Pin (Timer : Timer_Number; Pin : Pin_Type) is
    GPIO : GPIO_Params;
  begin
    GPIO := (Pins        => (Mask => (others => False)),
             Mode        => Alternate,
             Speed       => Speed_100MHz,
             Output_Type => PP,
             PuPd        => Pull_Up);
    GPIO.Pins.Mask (Pin.Pin) := True;
    Config_GPIO (Pin.Port, GPIO);
    Config_GPIO_AF (Pin.Port, Pin.Pin, AF_Timer (Timer));
  end Configure_Output_Pin;

  -----------------
  -- Get_Counter --
  -----------------

  function Get_Counter (Timer : Timer_Number) return Unsigned_32 is
  begin
    return TIM_GetCounter (Timers (Timer));
  end Get_Counter;

  -----------------
  -- Set_Compare --
  -----------------

  procedure Set_Compare (Timer : Timer_Number;
                         Channel : Timer_Channel_Number;
                         Value : Unsigned_32) is
    Tim : constant TIM_TypeDef := Timers (Timer);
  begin
    case Channel is
      when 1 => TIM_SetCompare1 (Tim, Value);
      when 2 => TIM_SetCompare2 (Tim, Value);
      when 3 => TIM_SetCompare3 (Tim, Value);
      when 4 => TIM_SetCompare4 (Tim, Value);
    end case;
  end Set_Compare;

end Stm32.Timer;
