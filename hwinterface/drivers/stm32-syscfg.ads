--------------------------------------------------------------------------------
--
--Copyright 2014 - Julien Romero
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

--****c* Stm32.SYSCFG/Stm32.SYSCFG
--
--  NAME
--    SYSCFG -- SYSCFG package.
--  COPYRIGHT
--    (c) 2014 by Julien Romero
--  SYNOPSIS
--    with Stm32.SYSCFG;
--  DESCRIPTION
--    A package for the SYSCFG peripheral.
--  AUTHOR
--    Julien Romero
--  USES
--    Stm32.Defines
--*****

package Stm32.SYSCFG is

--****t* Stm32.SYSCFG/ETH_MediaInterface
--
--  NAME
--    ETH_MediaInterface -- The Ethernet media interface.
--  USAGE
--    Choose between :
--      * MII : MII mode
--      * RMII : RMII mode
--
--*****

  type ETH_MediaInterface is (MII, RMII);
  for ETH_MediaInterface use
    (MII => 0,
    RMII => 1);
  for ETH_MediaInterface'Size use 32;

--****t* Stm32.SYSCFG/MemoryRemap
--
--  NAME
--    MemoryRemap -- Mapping of a pin.
--  USAGE
--    Choose between :
--      * Flash : Main Flash memory mapped at 0x00000000.
--      * SystemFlash : System Flash memory mapped at 0x00000000.
--      * SRAM : Embedded SRAM (112kB) mapped at 0x00000000.
--      * SDRAM :  FMC (External SDRAM) mapped at 0x00000000 for
--  STM32F42xxx/43xxx devices.
--
--*****

  type MemoryRemap is
    (Flash,SystemFlash,SRAM,SDRAM);
  for MemoryRemap use
    (Flash      => 16#00#,
    SystemFlash => 16#01#,
    SRAM        => 16#03#,
    SDRAM       => 16#04#);
  for MemoryRemap'Size use 8;

--****t* Stm32.SYSCFG/Port_Source
--
--  NAME
--    Port_Source -- The GPIO source port.
--  USAGE
--    Choose between :
--      * SYSCFG_GPIOA
--      * SYSCFG_GPIOB
--      * SYSCFG_GPIOC
--      * SYSCFG_GPIOD
--      * SYSCFG_GPIOE
--      * SYSCFG_GPIOF
--      * SYSCFG_GPIOG
--      * SYSCFG_GPIOH
--      * SYSCFG_GPIOI
--      * SYSCFG_GPIOJ
--      * SYSCFG_GPIOK
--
--*****

  type Port_Source is
    (SYSCFG_GPIOA,
     SYSCFG_GPIOB,
     SYSCFG_GPIOC,
     SYSCFG_GPIOD,
     SYSCFG_GPIOE,
     SYSCFG_GPIOF,
     SYSCFG_GPIOG,
     SYSCFG_GPIOH,
     SYSCFG_GPIOI,
     SYSCFG_GPIOJ,
     SYSCFG_GPIOK);
  for Port_Source use
    (SYSCFG_GPIOA => 16#00#,
     SYSCFG_GPIOB => 16#01#,
     SYSCFG_GPIOC => 16#02#,
     SYSCFG_GPIOD => 16#03#,
     SYSCFG_GPIOE => 16#04#,
     SYSCFG_GPIOF => 16#05#,
     SYSCFG_GPIOG => 16#06#,
     SYSCFG_GPIOH => 16#07#,
     SYSCFG_GPIOI => 16#08#,
     SYSCFG_GPIOJ => 16#09#,
     SYSCFG_GPIOK => 16#0A#);
  for Port_Source'Size use 8;

--****t* Stm32.SYSCFG/Pin_Source
--
--  NAME
--    Pin_Source -- The pin number of the source.
--  USAGE
--    Choose between :
--      * PinSource0
--      * PinSource1
--      * PinSource2
--      * PinSource3
--      * PinSource4
--      * PinSource5
--      * PinSource6
--      * PinSource7
--      * PinSource8
--      * PinSource9
--      * PinSource10
--      * PinSource11
--      * PinSource12
--      * PinSource13
--      * PinSource14
--      * PinSource15
--
--*****

  type Pin_Source is
    (PinSource0,
     PinSource1,
     PinSource2,
     PinSource3,
     PinSource4,
     PinSource5,
     PinSource6,
     PinSource7,
     PinSource8,
     PinSource9,
     PinSource10,
     PinSource11,
     PinSource12,
     PinSource13,
     PinSource14,
     PinSource15);
  for Pin_Source use
    (PinSource0 => 16#00#,
     PinSource1 => 16#01#,
     PinSource2 => 16#02#,
     PinSource3 => 16#03#,
     PinSource4 => 16#04#,
     PinSource5 => 16#05#,
     PinSource6 => 16#06#,
     PinSource7 => 16#07#,
     PinSource8 => 16#08#,
     PinSource9 => 16#09#,
     PinSource10 => 16#0A#,
     PinSource11 => 16#0B#,
     PinSource12 => 16#0C#,
     PinSource13 => 16#0D#,
     PinSource14 => 16#0E#,
     PinSource15 => 16#0F#);
  for Pin_Source'Size use 8;

--****t* Stm32.SYSCFG/EXTI_Source
--
--  NAME
--    EXTI_Source -- The complete pin name or the source.
--  USAGE
--    Define the fields of the following record :
--      * Port : The port name, of type Port_Source.
--      * Pin : The pin number, of type Pin_Source.
--  SEE ALSO
--    Port_Source, Pin_Source
--
--*****

  type EXTI_Source is record
    Port : Port_Source;
    Pin  : Pin_Source;
  end record;

--****f* Stm32.SYSCFG/SYSCFG_CompensationCellCmd
--
--  NAME
--    SYSCFG_CompensationCellCmd -- Activation of I/O Compensation.
--  SYNOPSIS
--    SYSCFG_CompensationCellCmd(New_State);
--  FUNCTION
--    Activates or desactivates the Input/Output compensation.
--  INPUTS
--    New_State - Status of the compensation, of type FunctionalState.
--  SEE ALSO
--    FunctionalState
--
--*****

  procedure SYSCFG_CompensationCellCmd (New_State : FunctionalState);
  pragma Import (C, SYSCFG_CompensationCellCmd, "SYSCFG_CompensationCellCmd");

--****f* Stm32.SYSCFG/SYSCFG_DeInit
--
--  NAME
--    SYSCFG_DeInit -- Resets the SYSCFG parameters.
--  SYNOPSIS
--    SYSCFG_DeInit;
--  FUNCTION
--    Resets the SYSCFG parameters.
--
--*****

  procedure SYSCFG_DeInit;
  pragma Import (C, SYSCFG_DeInit, "SYSCFG_DeInit");

--****f* Stm32.SYSCFG/SYSCFG_ETH_MediaInterfaceConfig
--
--  NAME
--    SYSCFG_ETH_MediaInterfaceConfig -- Configures ethernet media interface.
--  SYNOPSIS
--    SYSCFG_ETH_MediaInterfaceConfig(ETH);
--  FUNCTION
--    Configures ethernet media interface.
--  INPUTS
--    ETH : The ethernet media interface, of type ETH_MediaInterface.
--  SEE ALSO
--    ETH_MediaInterface
--
--*****

  procedure SYSCFG_ETH_MediaInterfaceConfig (ETH : ETH_MediaInterface);
  pragma Import (C, SYSCFG_ETH_MediaInterfaceConfig,
  "SYSCFG_ETH_MediaInterfaceConfig");

--****f* Stm32.SYSCFG/Config_EXTILine
--
--  NAME
--    Config_EXTILine -- Configures an EXTI line with a source.
--  SYNOPSIS
--    Config_EXTILine(Pin);
--  FUNCTION
--    Configures an EXTI line with the given source.
--  INPUTS
--    Pin - The pin source, of type EXTI_Source.
--  SEE ALSO
--    EXTI_Source
--
--*****

  procedure Config_EXTILine (Pin : EXTI_Source);

--****t* Stm32.SYSCFG/SYSCFG_GetCompensationCellStatus
--
--  NAME
--    SYSCFG_GetCompensationCellStatus -- Gets the compensation cell ready flag.
--  SYNOPSIS
--    Value := SYSCFG_GetCompensationCellStatus;
--  FUNCTION
--    Gets the compensation cell ready flag status.
--  RESULT
--    Value - A boolean representing if the ready flag is set or not.
--
--*****

  function SYSCFG_GetCompensationCellStatus return Boolean;

--****f* Stm32.SYSCFG/SYSCFG_MemoryRemapConfig
--
--  NAME
--    SYSCFG_MemoryRemapConfig -- Changes the mapping of a pin.
--  SYNOPSIS
--    SYSCFG_MemoryRemapConfig(Map);
--  FUNCTION
--    Changes the mapping of a pin.
--  INPUTS
--    Map - The new map, of type MemoryRemap.
--  SEE ALSO
--    MemoryRemap
--
--*****

  procedure SYSCFG_MemoryRemapConfig (Map : MemoryRemap);
  pragma Import (C, SYSCFG_MemoryRemapConfig, "SYSCFG_MemoryRemapConfig");

--****f* Stm32.SYSCFG/SYSCFG_MemorySwappingBank
--
--  NAME
--    SYSCFG_MemorySwappingBank -- Enables or disables the Interal FLASH Bank
--  Swapping.
--  SYNOPSIS
--    SYSCFG_MemorySwappingBank(State);
--  FUNCTION
--    Enables or disables the Interal FLASH Bank Swapping.
--  INPUTS
--    State - New status of the Internal Flash Bank, of type FunctionalState.
--  SEE ALSO
--    Stm32.Defines/FunctionalState
--
--*****

  procedure SYSCFG_MemorySwappingBank (State : FunctionalState);
  pragma Import (C, SYSCFG_MemorySwappingBank, "SYSCFG_MemorySwappingBank");

end Stm32.SYSCFG;
