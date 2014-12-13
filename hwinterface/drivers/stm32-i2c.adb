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
with Stm32.Defines; use Stm32.Defines;
with Stm32.RCC; use Stm32.RCC;

package body Stm32.I2C is

  type I2C_TypeDef is new Unsigned_32;

  I2Cs : constant array (I2C_Number) of I2C_TypeDef :=
    (I2C1_BASE, I2C2_BASE, I2C3_BASE);

  Periph : constant array (I2C_Number) of Stm_Periph :=
    (I2C1, I2C2, I2C3);

  -------------
  -- Imports --
  -------------

  procedure I2C_DeInit (I2C : I2C_TypeDef);
  pragma Import (C, I2C_DeInit, "I2C_DeInit");

  procedure I2C_Init (I2C : I2C_TypeDef; Params : access I2C_Params);
  pragma Import (C, I2C_Init, "I2C_Init");

  procedure I2C_Cmd (I2C : I2C_TypeDef; State : FunctionalState);
  pragma Import (C, I2C_Cmd, "I2C_Cmd");

  procedure I2C_GenerateSTART (I2C : I2C_TypeDef; State : FunctionalState);
  pragma Import (C, I2C_GenerateSTART, "I2C_GenerateSTART");

  procedure I2C_GenerateSTOP (I2C : I2C_TypeDef; State : FunctionalState);
  pragma Import (C, I2C_GenerateSTOP, "I2C_GenerateSTOP");

  procedure I2C_Send7bitAddress (I2C : I2C_TypeDef;
                                 Address : Unsigned_8;
                                 Direction: I2C_Direction);
  pragma Import (C, I2C_Send7bitAddress, "I2C_Send7bitAddress");

  procedure I2C_AcknowledgeConfig (I2C : I2C_TypeDef; State : FunctionalState);
  pragma Import (C, I2C_AcknowledgeConfig, "I2C_AcknowledgeConfig");

  procedure I2C_OwnAddress2Config (I2C : I2C_TypeDef; Address : Unsigned_8);
  pragma Import (C, I2C_OwnAddress2Config, "I2C_OwnAddress2Config");
  pragma Warnings (Off, I2C_OwnAddress2Config);

  procedure I2C_DualAddressCmd (I2C : I2C_TypeDef; State : FunctionalState);
  pragma Import (C, I2C_DualAddressCmd, "I2C_DualAddressCmd");
  pragma Warnings (Off, I2C_DualAddressCmd);

  procedure I2C_GeneralCallCmd (I2C : I2C_TypeDef; State : FunctionalState);
  pragma Import (C, I2C_GeneralCallCmd, "I2C_GeneralCallCmd");
  pragma Warnings (Off, I2C_GeneralCallCmd);

  procedure I2C_SoftwareResetCmd (I2C : I2C_TypeDef; State : FunctionalState);
  pragma Import (C, I2C_SoftwareResetCmd, "I2C_SoftwareResetCmd");
  pragma Warnings (Off, I2C_SoftwareResetCmd);

  procedure I2C_StretchClockCmd (I2C : I2C_TypeDef; State : FunctionalState);
  pragma Import (C, I2C_StretchClockCmd, "I2C_StretchClockCmd");
  pragma Warnings (Off, I2C_StretchClockCmd);

  procedure I2C_FastModeDutyCycleConfig (I2C : I2C_TypeDef; Cycle : I2C_Duty_Cycle);
  pragma Import (C, I2C_FastModeDutyCycleConfig, "I2C_FastModeDutyCycleConfig");
  pragma Warnings (Off, I2C_FastModeDutyCycleConfig);

  procedure I2C_NACKPositionConfig (I2C : I2C_TypeDef; Pos : I2C_NACK_Position);
  pragma Import (C, I2C_NACKPositionConfig, "I2C_NACKPositionConfig");
  pragma Warnings (Off, I2C_NACKPositionConfig);

  procedure I2C_SMBusAlertConfig (I2C : I2C_TypeDef; Level : I2C_SMBus_Alert_Pin_Level);
  pragma Import (C, I2C_SMBusAlertConfig, "I2C_SMBusAlertConfig");
  pragma Warnings (Off, I2C_SMBusAlertConfig);

  procedure I2C_ARPCmd (I2C : I2C_TypeDef; State : FunctionalState);
  pragma Import (C, I2C_ARPCmd, "I2C_ARPCmd");
  pragma Warnings (Off, I2C_ARPCmd);

  procedure I2C_SendData (I2C : I2C_TypeDef; Data : Unsigned_8);
  pragma Import (C, I2C_SendData, "I2C_SendData");

  function I2C_CheckEvent (I2C : I2C_TypeDef; Event : I2C_Event) return Integer;
  pragma Import (C, I2C_CheckEvent, "I2C_CheckEvent");

  function I2C_ReceiveData (I2C : I2C_TypeDef) return Unsigned_8;
  pragma Import (C, I2C_ReceiveData, "I2C_ReceiveData");

  function I2C_GetFlagStatus (I2C : I2C_TypeDef; Flag : I2C_Flag_Type)
      return Integer;
  pragma Import (C, I2C_GetFlagStatus, "I2C_GetFlagStatus");

  procedure I2C_ClearFlag (I2C : I2C_TypeDef; Flag : I2C_Flag_Type);
  pragma Import (C, I2C_ClearFlag, "I2C_ClearFlag");
  pragma Warnings (Off, I2C_ClearFlag);

  -----------------------
  -- PRIVATE FUNCTIONS --
  -----------------------

  -----------------------
  -- Wait_For_Not_Flag --
  -----------------------

  function Wait_For_Not_Flag (I2C : I2C_Number;
                              Flag : I2C_Flag_Type) return Boolean is
    Timeout : constant Time := Clock + To_Time_Span (0.01);
  begin
    while Clock < Timeout loop
      if not Get_Flag_Status (I2C, Flag) then
        return True;
      end if;
    end loop;
    return False;
  end Wait_For_Not_Flag;

  --------------------
  -- Wait_For_Event --
  --------------------

  function Wait_For_Event (I2C : I2C_Number; Event : I2C_Event)
      return Boolean is
    Timeout : constant Time := Clock + To_Time_Span (0.01);
  begin
    while Clock < Timeout loop
      if Check_Event (I2C, Event) then
        return True;
      end if;
    end loop;
    return False;
  end Wait_For_Event;

  -----------
  -- Start --
  -----------

  function Start (I2C : I2C_Number;
                  Address : Unsigned_7;
                  Direction : I2C_Direction) return Boolean is
  begin
    -- Wait until I2C is not busy any more
    if not Wait_For_Not_Flag (I2C, BUSY) then
      return False;
    end if;

    -- Send I2C START condition
    I2C_GenerateSTART (I2Cs (I2C), Enable);

    -- Wait for I2C EV5 --> Slave has acknowledged start condition
    if not Wait_For_Event (I2C, MASTER_MODE_SELECT) then
      return False;
    end if;

    -- Send slave Address for write
    I2C_Send7bitAddress(I2Cs (I2C), Unsigned_8 (Address) * 2, Direction);

    -- Wait for I2C EV6, check if
    -- either Slave has acknowledged Master transmitter or
    -- Master receiver mode, depending on the transmission
    -- direction
    if Direction = Transmitter then
      return Wait_For_Event (I2C, MASTER_TRANSMITTER_MODE_SELECTED);
    else
      return Wait_For_Event (I2C, MASTER_RECEIVER_MODE_SELECTED);
    end if;
  end Start;

  -----------
  -- Write --
  -----------

  function Write (I2C : I2C_Number; Data : Unsigned_8) return Boolean is
  begin
    -- Wait for I2C EV8 --> last byte is still being transmitted (last byte in
    --  SR, buffer empty), next byte can already be written
    if not Wait_For_Event(I2C, MASTER_BYTE_TRANSMITTING) then
      return False;
    end if;
    I2C_SendData (I2Cs (I2C), Data);
    return True;
  end Write;

  ----------
  -- Stop --
  ----------

  function Stop (I2C : I2C_Number) return Boolean is
  begin
    if not Wait_For_Event (I2C, MASTER_BYTE_TRANSMITTING) then
      return False;
    end if;
    -- Send I2C STOP Condition after last byte has been transmitted
    I2C_GenerateSTOP(I2Cs (I2C), Enable);
    -- Wait for I2C EV8_2 --> byte has been transmitted
--    return Wait_For_Event (I2C, MASTER_BYTE_TRANSMITTED);
    return True;
  end Stop;

  --------------
  -- Read_Ack --
  --------------

  procedure Read_Ack (I2C : I2C_Number;
                      Data : out Unsigned_8;
                      Success : out Boolean) is
  begin
    -- Enable acknowledge of received data.
    I2C_AcknowledgeConfig(I2Cs (I2C), Enable);
    -- Wait until one byte has been received.
    if not Wait_For_Event (I2C, MASTER_BYTE_RECEIVED) then
      Success := False;
      return;
    end if;
    -- Read data from I2C data register and return it.
    Data := I2C_ReceiveData(I2Cs (I2C));
    Success := True;
  end Read_Ack;

  ---------------
  -- Read_Nack --
  ---------------

  procedure Read_Nack (I2C : I2C_Number;
                       Data : out Unsigned_8;
                       Success : out Boolean) is
  begin
    -- Disable acknowledge of received data
    -- nack also generates stop condition after last byte received
    -- see reference manual for more info
    I2C_AcknowledgeConfig(I2Cs (I2C), Disable);
    I2C_GenerateSTOP(I2Cs (I2C), Enable);
    -- Wait until one byte has been received
    if not Wait_For_Event (I2C, MASTER_BYTE_RECEIVED) then
      Success := False;
      return;
    end if;
    -- Read data from I2C data register and return it.
    Data := I2C_ReceiveData(I2Cs (I2C));
    Success := True;
  end Read_Nack;

  ----------------------
  -- PUBLIC FUNCTIONS --
  ----------------------

  --------------
  -- I2C_Init --
  --------------

  procedure I2C_Init (I2C : I2C_Number;
                      Params : I2C_Params) is
    P : aliased I2C_Params := Params;
    I : constant I2C_TypeDef := I2Cs (I2C);
  begin
    RCC_PeriphClockCmd (Periph (I2C), Enable);
    I2C_DeInit (I);
    I2C_Init (I, P'Access);
    I2C_Cmd (I, Enable);
  end I2C_Init;

  --------------------
  -- Configure_Pins --
  --------------------

  procedure Configure_Pins (I2C : I2C_Number; SDA : Pin_Type; SCL : Pin_Type) is
    GPIO : GPIO_Params;
  begin
    GPIO := (Pins        => (Mask => (others => False)),
             Mode        => Alternate,
             Speed       => Speed_50MHz,
             Output_Type => OD,
             PuPd        => Pull_Up);
    GPIO.Pins.Mask (SDA.Pin) := True;
    Config_GPIO (SDA.Port, GPIO);
    Config_GPIO_AF (SDA.Port, SDA.Pin, AF_I2C (I2C));

    GPIO := (Pins        => (Mask => (others => False)),
             Mode        => Alternate,
             Speed       => Speed_50MHz,
             Output_Type => OD,
             PuPd        => Pull_Up);
    GPIO.Pins.Mask (SCL.Pin) := True;
    Config_GPIO (SCL.Port, GPIO);
    Config_GPIO_AF (SCL.Port, SCL.Pin, AF_I2C (I2C));
  end Configure_Pins;

  ---------------------
  -- Get_Flag_Status --
  ---------------------

  function Get_Flag_Status (I2C : I2C_Number;
                            Flag : I2C_Flag_Type) return Boolean is
  begin
    return I2C_GetFlagStatus (I2Cs (I2C), Flag) /= 0;
  end Get_Flag_Status;

  ----------------
  -- Clear_Flag --
  ----------------

  procedure Clear_Flag (I2C : I2C_Number; Flag : I2C_Flag_Type) is
  begin
    I2C_ClearFlag (I2Cs (I2C), Flag);
  end Clear_Flag;

  -----------------
  -- Check_Event --
  -----------------

  function Check_Event (I2C : I2C_Number; Event : I2C_Event) return Boolean is
  begin
    return I2C_CheckEvent (I2Cs (I2C), Event) /= 0;
  end Check_Event;

  ----------
  -- Read --
  ----------

  procedure Read (I2C : I2C_Number;
                  Address : Unsigned_7;
                  Data : out Data_Array;
                  Success : out Boolean) is
  begin
    Success := Start (I2C, Address, Transmitter);
    if not Success then
      return;
    end if;
    for I in Data'First .. Data'Last - 1 loop
      Read_Ack (I2C, Data (I), Success);
      if not Success then
        return;
      end if;
    end loop;
    Read_Nack (I2C, Data (Data'Last), Success);
  end Read;

  -----------
  -- Write --
  -----------

  function Write (I2C : I2C_Number; Address : Unsigned_7; Data : Data_Array)
      return Boolean is
  begin
    if not Start (I2C, Address, Transmitter) then
      return False;
    end if;
    for I in Data'Range loop
      if not Write (I2C, Data (I)) then
        return False;
      end if;
    end loop;
    return Stop (I2C);
  end Write;

end Stm32.I2C;
