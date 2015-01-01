with Stm32.Defines; use Stm32.Defines;

package Stm32.SYSCFG is

  type ETH_MediaInterface is (MII, RMII);
  for ETH_MediaInterface use
    (MII => 0,
    RMII => 1);
  for ETH_MediaInterface'Size use 32;

  type MemoryRemap is
    (Flash,SystemFlash,SRAM,SDRAM);
  for MemoryRemap use
    (Flash      => 16#00#,
    SystemFlash => 16#01#,
    SRAM        => 16#03#,
    SDRAM       => 16#04#);
  for MemoryRemap'Size use 8;

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

  type EXTI_Source is record
    Port : Port_Source;
    Pin  : Pin_Source;
  end record;

  procedure SYSCFG_CompensationCellCmd (New_State : FunctionalState);
  pragma Import (C, SYSCFG_CompensationCellCmd, "SYSCFG_CompensationCellCmd");

  procedure SYSCFG_DeInit;
  pragma Import (C, SYSCFG_DeInit, "SYSCFG_DeInit");

  procedure SYSCFG_ETH_MediaInterfaceConfig (ETH : ETH_MediaInterface);
  pragma Import (C, SYSCFG_ETH_MediaInterfaceConfig,
  "SYSCFG_ETH_MediaInterfaceConfig");

  procedure Config_EXTILine (Pin : EXTI_Source);

  function SYSCFG_GetCompensationCellStatus return Boolean;

  procedure SYSCFG_MemoryRemapConfig (Map : MemoryRemap);
  pragma Import (C, SYSCFG_MemoryRemapConfig, "SYSCFG_MemoryRemapConfig");

  procedure SYSCFG_MemorySwappingBank (State : FunctionalState);
  pragma Import (C, SYSCFG_MemorySwappingBank, "SYSCFG_MemorySwappingBank");

end Stm32.SYSCFG;
