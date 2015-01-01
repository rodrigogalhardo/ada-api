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
