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
with Stm32.GPIO; use Stm32.GPIO;

--****c* Stm32.I2C/Stm32.I2C
--
--  NAME
--    Stm32.I2C -- Package for I2C communications.
--  COPYRIGHT
--    (c) 2014 by Julien Brette & Julien Romero
--  SYNOPSIS
--    with Stm32.I2C;
--  DESCRIPTION
--    Thanks to this package, you can manage I2C communications.
--  AUTHOR
--    Julien Brette & Julien Romero
--  USES
--    Interfaces, Stm32.GPIO
--*****

package Stm32.I2C is

--****t* Stm32.I2C/Slave_Address
--
--  NAME
--    Slave_Address -- The address of a slave.
--  USAGE
--    An unsigned number on 7 bits.
--
--*****

  type Slave_Address is mod 2**7;

--****t* Stm32.I2C/I2C_Number
--
--  NAME
--    I2C_Number -- The number of the I2C.
--  USAGE
--    An Integer between 1 and 3 (included).
--
--*****

  type I2C_Number is new Integer range 1 .. 3;

--****d* Stm32.I2C/AF_I2C
--
--  NAME
--    AF_I2C -- The array of alternate functions of the I2C.
--  USAGE
--    This array makes the correspondance between an I2C_Number and an
--Alternate_Function.
--  SEE ALSO
--    I2C_Number, Alternate_Function
--
--*****

  AF_I2C : constant array (I2C_Number) of Alternate_Function :=
    (AF_I2C1, AF_I2C2, AF_I2C3);

--****t* Stm32.I2C/I2C_Mode
--
--  NAME
--    I2C_Mode -- The I2C mode.
--  USAGE
--    Choose between :
--      * I2C
--      * SMBusDevice
--      * SMBusHost
--
--*****

  type I2C_Mode is (I2C, SMBusDevice, SMBusHost);
  for I2C_Mode'Size use 16;
  for I2C_Mode use (
    I2C         => 16#0000#,
    SMBusDevice => 16#0002#,
    SMBusHost   => 16#000A#);

--****t* Stm32.I2C/I2C_Duty_Cycle
--
--  NAME
--    I2C_Duty_Cycle -- The I2C fast mode duty cycle.
--  USAGE
--    Choose between :
--      * Duty_Cycle_16_9 : I2C fast mode Tlow/Thigh = 16/9.
--      * Duty_Cycle_2 : I2C fast mode Tlow/Thigh = 2.
--
--*****

  type I2C_Duty_Cycle is (Duty_Cycle_16_9, Duty_Cycle_2);
  for I2C_Duty_Cycle'Size use 16;
  for I2C_Duty_Cycle use (
    Duty_Cycle_16_9 => 16#4000#,
    Duty_Cycle_2    => 16#BFFF#);

--****t* Stm32.I2C/I2C_Ack_State
--
--  NAME
--    I2C_Ack_State - Enables or disables the acknowledgement.
--  USAGE
--    Choose between :
--      * Disable : Disable the acknowledgement.
--      * Enable : Enable the ackowledgement.
--
--*****

  type I2C_Ack_State is (Disable, Enable);
  for I2C_Ack_State'Size use 16;
  for I2C_Ack_State use (
    Disable => 16#0000#,
    Enable  => 16#0400#);

--****t* Stm32.I2C/I2C_Direction
--
--  NAME
--    I2C_Direction -- The role of the I2C device.
--  USAGE
--    Choose between :
--      * Transmitter : The device is a transmitter.
--      * Receiver : The device is a receiver.
--
--*****

  type I2C_Direction is (Transmitter, Receiver);
  for I2C_Direction'Size use 8;
  for I2C_Direction use (
    Transmitter => 16#00#,
    Receiver    => 16#01#);

--****t* Stm32.I2C/I2C_Acknowledged_Address
--
--  NAME
--    I2C_Acknowledged_Address -- The length of address acknowledge.
--  USAGE
--    Choose between :
--      * Seven_Bits : 7-bits address is acknowledged.
--      * Ten_Bits : 10_bits address is acknowledged.
--
--*****

  type I2C_Acknowledged_Address is (Seven_Bits, Ten_Bits);
  for I2C_Acknowledged_Address'Size use 16;
  for I2C_Acknowledged_Address use (
    Seven_Bits => 16#4000#,
    Ten_Bits   => 16#C000#);

--****t* Stm32.I2C/I2C_NACK_Position
--
--  NAME
--    I2C_NACK_Position -- Indicates the last received byte.
--  USAGE
--    Choose between :
--      * Next : The next byte will be the last.
--      * Current : The current byte is the last.
--
--*****

  type I2C_NACK_Position is (Next, Current);
  for I2C_NACK_Position'Size use 16;
  for I2C_NACK_Position use (
    Next    => 16#0800#,
    Current => 16#F7FF#);

--****t* Stm32.I2C/I2C_SMBus_Alert_Pin_Level
--
--  NAME
--    I2C_SMBus_Alert_Pin_Level -- The SMBAlert pin level.
--  USAGE
--    Choose between :
--      * Low : SMBAlert pin driven low.
--      * High : SMBAlert pin driven high.
--
--*****

  type I2C_SMBus_Alert_Pin_Level is (Low, High);
  for I2C_SMBus_Alert_Pin_Level'Size use 16;
  for I2C_SMBus_Alert_Pin_Level use (
    Low  => 16#2000#,
    High => 16#DFFF#);

--****t* Stm32.I2C/I2C_PEC_Position
--
--  NAME
--    I2C_PEC_Position -- Indicates the PEC position.
--  USAGE
--    Choose between :
--      * Next : The next byte is PEC.
--      * Current : The current byte is PEC.
--
--*****

  type I2C_PEC_Position is (Next, Current);
  for I2C_PEC_Position'Size use 16;
  for I2C_PEC_Position use (
    Next    => 16#0800#,
    Current => 16#F7FF#);

--****t* Stm32.I2C/I2C_Flag_Type
--
--  NAME
--    I2C_Flag_Type -- I2C flags.
--  USAGE
--    Choose between :
--      * MSL : Master/Slave
--      * BUSY : Bus busy
--      * TRA : Transmitter/Receiver
--      * GENCALL : General Call header (slave mode)
--      * SMBDEFAULT : SMBus default header (slave mode)
--      * SMBHOST : SMBus host header (slave mode)
--      * DUALF : Dual flag (slave mode)
--      * SB : Start Bit
--      * ADDR : Address sent
--      * BTF : Byte transfer finished.
--      * ADD10 : 10-bits header sent
--      * STOPF : STOP detection
--      * RXNE : Data register not empty (receiver)
--      * TXE : Data register empty (trasmitter)
--      * BERR : Bus error.
--      * ARLO : Arbitration lost (master mode)
--      * AF : Acknoledgement failure.
--      * OVR : Overrun/Underrun flag (in slave mode)
--      * PECERR : PEC error in reception.
--      * TIMEOUT : Timeout or Tlow error
--      * SMBALERT : SMBus Alert
--
--*****

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

--****t* Stm32.I2C/I2C_Event
--
--  NAME
--    I2C_Event -- An I2C event.
--  USAGE
--    Choose between :
--      * SLAVE_STOP_DETECTED : STOPF flag
--      * SLAVE_ACK_FAILURE : AF flag
--      * SLAVE_RECEIVER_ADDRESS_MATCHED : BUSY and ADDR flags
--      * SLAVE_BYTE_RECEIVED : BUSY and RXNE flags
--      * MASTER_MODE_SELECT : BUSY, MSL and SB flags.
--      * MASTER_RECEIVER_MODE_SELECTED : BUSY,MSL and ADDR flags.
--      * MASTER_MODE_ADDRESS10 : BUSY, MSL and ADD10 flags.
--      * MASTER_BYTE_RECEIVED : BUSY, MSL and RXNE flags.
--      * SLAVE_BYTE_TRANSMITTING : TRA, BUSY and TXE flags
--      * SLAVE_TRANSMITTER_ADDRESS_MATCHED : TRA, BUSY, TXE, ADDR flags.
--      * SLAVE_BYTE_TRANSMITTED : TRA, BUSY, TXE and BTF flags.
--      * MASTER_BYTE_TRANSMITTING :TRA, BUSY, MSL and TXE flags.
--      * MASTER_TRANSMITTER_MODE_SELECTED : BUSY, MSL, ADDR, TXE and TRA flags.
--      * MASTER_BYTE_TRANSMITTED : TRA, BUSY, MSL, TXE and TRA flags.
--      * SLAVE_GENERALCALLADDRESS_MATCHED : GENCALL and BUSY flags.
--      * SLAVE_RECEIVER_SECONDADDRESS_MATCHED : DUALF and BUSY flags.
--      * SLAVE_TRANSMITTER_SECONDADDRESS_MATCHED : DUALF, TRA, BUSY and TXE
--flags.
--
--*****

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

--****t* Stm32.I2C/I2C_Params
--
--  NAME
--    I2C_Params -- I2C Parameters.
--  USAGE
--    Define the following fields of the record :
--      * Clock_Speed : An Unsigned_32 that specifies the clock frequency. This parameter must be set to a value lower than 400kHz.
--      * Mode : The I2C mode, of type I2C_Mode.
--      * Duty_Cycle : I2C fast mode duty cycle, of type I2C_Duty_Cycle.
--      * Own_Address_1 : An Unsigned_16 that specifies the fist device own address. This parameter can be a 7-bit or 10-bit address.
--      * Ack : Enables or disables the acknowledgement, of type I2C_Ack_State.
--      * Ack_Address : Specifies if 7-bit or 10-bit address is acknowledged, of type I2C_Acknowledgement_Address.
--  SEE ALSO
--    I2C_Mode, I2C_Duty_Cycle, I2C_Ack_State, I2C_Acknowledged_Address
--
--*****

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

--****t* Stm32.I2C/I2C_Init
--
--  NAME
--    I2C_Init -- Initializes I2C.
--  SYNOPSIS
--    I2C_Init(I2C, Params);
--  FUNCTION
--    Initializes the I2C with the given parameters.
--  INPUTS
--    I2C - The number of the I2C, of type I2C_Number.
--    Params - The parameters of the I2C, of type I2C_Params.
--  SEE ALSO
--    I2C_Number, I2C_Params
--
--*****

  procedure I2C_Init (I2C : I2C_Number;
                      Params : I2C_Params);

--****t* Stm32.I2C/Configure_Pins
--
--  NAME
--    Configure_Pins : Configures pins for an I2C communication.
--  SYNOPSIS
--    Configure_Pins(I2C, SDA, SCL);
--  FUNCTION
--    Configures the given pins for a I2C communication.
--  INPUTS
--    I2C - The I2C number, of type I2C_Number.
--    SDA - The SD1 pin, of type Pin_Type.
--    SCL - The SCL pin, of type Pin_Type.
--  SEE ALSO
--    I2C_Number, Pin_Type
--
--*****

  procedure Configure_Pins (I2C : I2C_Number; SDA : Pin_Type; SCL : Pin_Type);

--****f* Stm32.I2C/Get_Flag_Status
--
--  NAME
--    Get_Flag_Status -- Checks whether the specified I2C flag is set or not.
--  SYNOPSIS
--    Value := Get_Flag_Status(I2C, Flag);
--  FUNCTION
--    Checks whether the specified I2C flag is set or not.
--  INPUTS
--    I2C - The number of the I2C peripheral, of type I2C_Number.
--    Flag - The flag to check, of type I2C_Flag_Type.
--  RESULT
--    Value - A Boolean representing the new state of the flag.
--  SEE ALSO
--    I2C_Number, I2C_Flag_Type
--
--*****

  function Get_Flag_Status (I2C : I2C_Number;
                            Flag : I2C_Flag_Type) return Boolean;

--****f* Stm32.I2C/Clear_Flag
--
--  NAME
--    Clear_Flag -- Clears the I2C's pending flag.
--  SYNOPSIS
--    Clear_Flag(I2C, Flag);
--  FUNCTION
--    Clears the I2C's pending flag.
--  INPUTS
--    I2C - The I2C number, of type I2C_Number.
--    Flag - The flag to clear, of type I2C_Flag_Type
--  SEE ALSO
--    I2C_Number, I2C_Flag_Type
--
--*****

  procedure Clear_Flag (I2C : I2C_Number; Flag : I2C_Flag_Type);

--****f* Stm32.I2C/Check_Event
--
--  NAME
--    Check_Event -- Checks the last I2C event.
--  SYNOPSIS
--    Value := Check_Event(I2C, Event);
--  FUNCTION
--    Checks whether the last I2C event is equal to the one passed as parameter.
--  INPUTS
--    I2C - The I2C number, of type I2C_Number.
--    Event - The event to check, of type I2C_Event.
--  RESULT
--    Value - A Boolean saying if the one given was the last one.
--  SEE ALSO
--    I2C_Number, I2C_Event
--
--*****

  function Check_Event (I2C : I2C_Number; Event : I2C_Event) return Boolean;

--****d* Stm32.I2C/Data_Array
--
--  NAME
--    Data_Array -- An array of datas.
--  USAGE
--    This is an array of Unsigned_8 that will receive data transfered.
--
--*****

  type Data_Array is array (Integer range <>) of Unsigned_8;

--****f* Stm32.I2C/Read
--
--  NAME
--    Read -- Reads datas from an I2C communication.
--  SYNOPSIS
--    Read(I2C, Address, Data, Success);
--  FUNCTION
--    Reads datas received during an I2C communication.
--  INPUTS
--    I2C - The I2C number, of type I2C_Number.
--    Address - The address of the slave to read from.
--    Data - The array of the received datas, of type out Data_Array.
--    Success - Says whether the transmission was a success or not.
--  SEE ALSO
--    I2C_Number, Slave_Address, Data_Array
--
--*****

  procedure Read (I2C : I2C_Number;
                  Address : Slave_Address;
                  Data : out Data_Array;
                  Success : out Boolean);

--****f* Stm32.I2C/Write
--
--  NAME
--    Write -- Sends datas to a slave.
--  SYNOPSIS
--    Value := Write(I2C, Address, Data);
--  FUNCTION
--    Sends datas to the given slave.
--  INPUTS
--    I2C - The I2C Number, of type I2C_Number.
--    Address - The slave address, of type Slave_Address.
--    Data - The array of the datas, of type Data_Array.
--  RESULT
--    Value - A Boolean to know whether the transmission was a success or not.
--  SEE ALSO
--    I2C_Number, Slave_Address, Data_Array
--
--*****

  function Write (I2C : I2C_Number; Address : Slave_Address; Data : Data_Array)
      return Boolean;

end Stm32.I2C;
