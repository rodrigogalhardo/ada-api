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
with Interfaces; use Interfaces;
with Stm32.GPIO; use Stm32.GPIO;

package Stm32.I2C is
  type I2C_Number is new Integer range 1 .. 3;

  AF_I2C : constant array (I2C_Number) of Alternate_Function :=
    (AF_I2C1, AF_I2C2, AF_I2C3);

  type I2C_Mode is (I2C, SMBusDevice, SMBusHost);
  for I2C_Mode'Size use 16;
  for I2C_Mode use (
    I2C         => 16#0000#,
    SMBusDevice => 16#0002#,
    SMBusHost   => 16#000A#);

  type I2C_Duty_Cycle is (Duty_Cycle_16_9, Duty_Cycle_2);
  for I2C_Duty_Cycle'Size use 16;
  for I2C_Duty_Cycle use (
    Duty_Cycle_16_9 => 16#4000#,
    Duty_Cycle_2    => 16#BFFF#);

  type I2C_Ack_State is (Disable, Enable);
  for I2C_Ack_State'Size use 16;
  for I2C_Ack_State use (
    Disable => 16#0000#,
    Enable  => 16#0400#);

  type I2C_Direction is (Transmitter, Receiver);
  for I2C_Direction'Size use 8;
  for I2C_Direction use (
    Transmitter => 16#00#,
    Receiver    => 16#01#);

  type I2C_Acknowledged_Address is (Seven_Bits, Ten_Bits);
  for I2C_Acknowledged_Address'Size use 16;
  for I2C_Acknowledged_Address use (
    Seven_Bits => 16#4000#,
    Ten_Bits   => 16#C000#);

  type I2C_NACK_Position is (Next, Current);
  for I2C_NACK_Position'Size use 16;
  for I2C_NACK_Position use (
    Next    => 16#0800#,
    Current => 16#F7FF#);

  type I2C_SMBus_Alert_Pin_Level is (Low, High);
  for I2C_SMBus_Alert_Pin_Level'Size use 16;
  for I2C_SMBus_Alert_Pin_Level use (
    Low  => 16#2000#,
    High => 16#DFFF#);

  type I2C_PEC_Position is (Next, Current);
  for I2C_PEC_Position'Size use 16;
  for I2C_PEC_Position use (
    Next    => 16#0800#,
    Current => 16#F7FF#);

  type I2C_Flag_Type is (MSL, BUSY, TRA, GENCALL, SMBDEFAULT, SMBHOST, DUALF,
                         SB, ADDR, BTF, ADD10, STOPF, RXNE, TXE, BERR, ARLO,
                         AF, OVR, PECERR, TIMEOUT, SMBALERT);
  for I2C_Flag_Type'Size use 32;
  for I2C_Flag_Type use (
    MSL        => 16#00010000#,
    BUSY       => 16#00020000#,
    TRA        => 16#00040000#,
    GENCALL    => 16#00100000#,
    SMBDEFAULT => 16#00200000#,
    SMBHOST    => 16#00400000#,
    DUALF      => 16#00800000#,
    SB         => 16#10000001#,
    ADDR       => 16#10000002#,
    BTF        => 16#10000004#,
    ADD10      => 16#10000008#,
    STOPF      => 16#10000010#,
    RXNE       => 16#10000040#,
    TXE        => 16#10000080#,
    BERR       => 16#10000100#,
    ARLO       => 16#10000200#,
    AF         => 16#10000400#,
    OVR        => 16#10000800#,
    PECERR     => 16#10001000#,
    TIMEOUT    => 16#10004000#,
    SMBALERT   => 16#10008000#);

  type I2C_Event is (
    SLAVE_STOP_DETECTED, SLAVE_ACK_FAILURE, SLAVE_RECEIVER_ADDRESS_MATCHED,
    SLAVE_BYTE_RECEIVED, MASTER_MODE_SELECT, MASTER_RECEIVER_MODE_SELECTED,

    MASTER_MODE_ADDRESS10, MASTER_BYTE_RECEIVED, SLAVE_BYTE_TRANSMITTING,
    SLAVE_TRANSMITTER_ADDRESS_MATCHED, SLAVE_BYTE_TRANSMITTED,
    MASTER_BYTE_TRANSMITTING, MASTER_TRANSMITTER_MODE_SELECTED,
    MASTER_BYTE_TRANSMITTED, SLAVE_GENERALCALLADDRESS_MATCHED,
    SLAVE_RECEIVER_SECONDADDRESS_MATCHED,
    SLAVE_TRANSMITTER_SECONDADDRESS_MATCHED);
  for I2C_Event'Size use 32;
  for I2C_Event use (
    -- STOPF flag.
    SLAVE_STOP_DETECTED => 16#00000010#,
    -- AF flag.
    SLAVE_ACK_FAILURE => 16#00000400#,
    -- BUSY and ADDR flags.
    SLAVE_RECEIVER_ADDRESS_MATCHED => 16#00020002#,
    -- BUSY and RXNE flags.
    SLAVE_BYTE_RECEIVED => 16#00020040#,
    -- BUSY, MSL and SB flag.
    MASTER_MODE_SELECT => 16#00030001#,
    -- BUSY, MSL and ADDR flags.
    MASTER_RECEIVER_MODE_SELECTED => 16#00030002#,
    -- BUSY, MSL and ADD10 flags.
    MASTER_MODE_ADDRESS10 => 16#00030008#,
    -- BUSY, MSL and RXNE flags.
    MASTER_BYTE_RECEIVED => 16#00030040#,
    -- TRA, BUSY and TXE flags.
    SLAVE_BYTE_TRANSMITTING => 16#00060080#,
    -- TRA, BUSY, TXE and ADDR flags.
    SLAVE_TRANSMITTER_ADDRESS_MATCHED => 16#00060082#,
    -- TRA, BUSY, TXE and BTF flags.
    SLAVE_BYTE_TRANSMITTED => 16#00060084#,
    -- TRA, BUSY, MSL, TXE flags.
    MASTER_BYTE_TRANSMITTING => 16#00070080#,
    -- BUSY, MSL, ADDR, TXE and TRA flags.
    MASTER_TRANSMITTER_MODE_SELECTED => 16#00070082#,
    -- TRA, BUSY, MSL, TXE and BTF flags.
    MASTER_BYTE_TRANSMITTED => 16#00070084#,
    -- GENCALL and BUSY flags.
    SLAVE_GENERALCALLADDRESS_MATCHED => 16#00120000#,
    -- DUALF and BUSY flags.
    SLAVE_RECEIVER_SECONDADDRESS_MATCHED => 16#00820000#,
    -- DUALF, TRA, BUSY and TXE flags.
    SLAVE_TRANSMITTER_SECONDADDRESS_MATCHED => 16#00860080#);

  type I2C_Params is record
    Clock_Speed : Unsigned_32;               -- Specifies the clock frequency.
                                             -- This parameter must be set to a
                                             -- value lower than 400kHz
    Mode : I2C_Mode;                         -- Specifies the I2C mode.
    Duty_Cycle : I2C_Duty_Cycle;             -- Specifies the I2C fast mode
                                             -- duty cycle.
    Own_Address_1 : Unsigned_16;             -- Specifies the first device own
                                             -- address. This parameter can be
                                             -- a 7-bit or 10-bit address.
    Ack : I2C_Ack_State;                     --  Enables or disables the
                                             -- acknowledgement.
    Ack_Address : I2C_Acknowledged_Address;  -- Specifies if 7-bit or 10-bit
                                             -- address is acknowledged.
  end record;

  procedure I2C_Init (I2C : I2C_Number;
                      Params : I2C_Params);

  procedure Configure_Pins (I2C : I2C_Number; SDA : Pin_Type; SCL : Pin_Type);

  function Get_Flag_Status (I2C : I2C_Number;
                            Flag : I2C_Flag_Type) return Boolean;

  procedure Clear_Flag (I2C : I2C_Number; Flag : I2C_Flag_Type);

  function Check_Event (I2C : I2C_Number; Event : I2C_Event) return Boolean;

  type Data_Array is array (Integer range <>) of Unsigned_8;

  procedure Read (I2C : I2C_Number;
                  Address : Unsigned_7;
                  Data : out Data_Array;
                  Success : out Boolean);

  function Write (I2C : I2C_Number; Address : Unsigned_7; Data : Data_Array)
      return Boolean;

end Stm32.I2C;
