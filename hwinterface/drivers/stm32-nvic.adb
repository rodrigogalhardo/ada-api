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
with Stm32.Defines; use Stm32.Defines;

package body Stm32.NVIC is

  type NVIC_InitTypeDef is record
    IRQChannel : Integer_8;
    IRQChannelPreemptionPriority : Unsigned_8;
    IRQChannelSubPriority : Unsigned_8;
    IRQChannelCmd : FunctionalState;
  end record;
  for NVIC_InitTypeDef'Size use 32;

  procedure NVIC_Init (NVIC_InitStruct : access NVIC_InitTypeDef);
  pragma Import (C, NVIC_Init, "NVIC_Init");

  function GetPendingIRQ (IRQn : IRQn_Type) return Boolean is
    function NVIC_GetPendingIRQ (IRQn : IRQn_Type) return Unsigned_32;
    pragma Import (C, NVIC_GetPendingIRQ, "_NVIC_GetPendingIRQ");
  begin
    return NVIC_GetPendingIRQ (IRQn) /= 0;
  end GetPendingIRQ;


  procedure NVIC_Init (IRQn: IRQn_Type; Priority : IRQ_Priority) is
    Init : aliased NVIC_InitTypeDef :=
      (IRQChannel => Integer_8 (IRQn) - 16,
       IRQChannelPreemptionPriority => 15 - Unsigned_8 (Priority),
       IRQChannelSubPriority => 0,
       IRQChannelCmd => Enable);
  begin
    NVIC_Init (Init'Access);
  end NVIC_Init;
end Stm32.NVIC;
