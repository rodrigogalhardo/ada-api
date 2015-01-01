with Stm32.RCC; use Stm32.RCC;
with Interfaces; use Interfaces;

package body Stm32.SYSCFG is

  procedure SYSCFG_EXTILineConfig (Port : Port_Source; Pin : Pin_Source);
  pragma Import (C, SYSCFG_EXTILineConfig , "SYSCFG_EXTILineConfig");

  procedure Config_EXTILine (Pin : EXTI_Source) is
  begin
    RCC_PeriphClockCmd(Stm32.RCC.SYSCFG, Enable);
    SYSCFG_EXTILineConfig (Pin.Port, Pin.Pin);
  end Config_EXTILine;

  function SYSCFG_GetCompensationCellStatus return Boolean is
    function GetCompensationCellStatus return Unsigned_32;
    pragma Import (C, GetCompensationCellStatus,
    "SYSCFG_GetCompensationCellStatus");
  begin
    return GetCompensationCellStatus /= 0;
  end SYSCFG_GetCompensationCellStatus;

end Stm32.SYSCFG;
