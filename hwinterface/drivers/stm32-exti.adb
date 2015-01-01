with Interfaces; use Interfaces;

package body Stm32.EXTI is

  function EXTI_GetFlagStatus (EXTI : EXTI_Line) return Boolean is
    function GetFlagStatus (EXTI : EXTI_Line) return Unsigned_32;
    pragma Import (C, GetFlagStatus, "EXTI_GetFlagStatus");
  begin
    return GetFlagStatus(EXTI) /= 0;
  end EXTI_GetFlagStatus;

  function EXTI_GetITStatus (EXTI : EXTI_Line) return Boolean is
    function GetITStatus (EXTI : EXTI_Line) return Unsigned_32;
    pragma Import (C, GetITStatus, "EXTI_GetITStatus");
  begin
    return GetITStatus (EXTI)/= 0;
  end EXTI_GetITStatus;

  procedure EXTI_Init (Params : access EXTI_Params);
  pragma Import (C, EXTI_Init, "EXTI_Init");

  procedure Config_EXTI (Params : EXTI_Params) is
    P : aliased EXTI_Params := Params;
  begin
    EXTI_Init (P'Access);
  end Config_EXTI;

end Stm32.EXTI;
