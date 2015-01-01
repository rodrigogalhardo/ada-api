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

--****c* Stm32.EXTI/Stm32.EXTI
--
--  NAME
--    Stm32.EXTI -- External Interrupt
--  COPYRIGHT
--    (c) 2014 by Julien Romero
--  SYNOPSIS
--    with Stm32.EXTI;
--  DESCRIPTION
--    Package for external interrupts.
--  AUTHOR
--    Julien Romero
--  USES
--    Stm32.Defines
--*****

package Stm32.EXTI is

--****t* Stm32.EXTI/EXTI_Line
--
--  NAME
--    EXTI_Line -- The EXTI line.
--  USAGE
--    Choose between the following lines :
--      * EXTI_Line0
--      * EXTI_Line1
--      * EXTI_Line2
--      * EXTI_Line3
--      * EXTI_Line4
--      * EXTI_Line5
--      * EXTI_Line6
--      * EXTI_Line7
--      * EXTI_Line8
--      * EXTI_Line9
--      * EXTI_Line10
--      * EXTI_Line11
--      * EXTI_Line12
--      * EXTI_Line13
--      * EXTI_Line14
--      * EXTI_Line15
--      * EXTI_Line16
--      * EXTI_Line17
--      * EXTI_Line18
--      * EXTI_Line19
--      * EXTI_Line20
--      * EXTI_Line21
--      * EXTI_Line22
--
--*****

  type EXTI_Line is
    (EXTI_Line0, EXTI_Line1, EXTI_Line2, EXTI_Line3, EXTI_Line4, EXTI_Line5,
     EXTI_Line6, EXTI_Line7, EXTI_Line8, EXTI_Line9, EXTI_Line10, EXTI_Line11,
     EXTI_Line12, EXTI_Line13, EXTI_Line14, EXTI_Line15, EXTI_Line16,
     EXTI_Line17, EXTI_Line18, EXTI_Line19, EXTI_Line20, EXTI_Line21,
     EXTI_Line22);
  for EXTI_Line use
    (EXTI_Line0 => 16#00000001#,
    EXTI_Line1  => 16#00000002#,
    EXTI_Line2  => 16#00000004#,
    EXTI_Line3  => 16#00000008#,
    EXTI_Line4  => 16#00000010#,
    EXTI_Line5  => 16#00000020#,
    EXTI_Line6  => 16#00000040#,
    EXTI_Line7  => 16#00000080#,
    EXTI_Line8  => 16#00000100#,
    EXTI_Line9  => 16#00000200#,
    EXTI_Line10 => 16#00000400#,
    EXTI_Line11 => 16#00000800#,
    EXTI_Line12 => 16#00001000#,
    EXTI_Line13 => 16#00002000#,
    EXTI_Line14 => 16#00004000#,
    EXTI_Line15 => 16#00008000#,
    EXTI_Line16 => 16#00010000#,
    EXTI_Line17 => 16#00020000#,
    EXTI_Line18 => 16#00040000#,
    EXTI_Line19 => 16#00080000#,
    EXTI_Line20 => 16#00100000#,
    EXTI_Line21 => 16#00200000#,
    EXTI_Line22 => 16#00400000#);
  for EXTI_Line'Size use 32;

--****t* Stm32.EXTI/EXTI_Number
--
--  NAME
--    EXTI_Number -- The number of a EXTI line.
--  USAGE
--    An Integer between 0 and 22 (included).
--
--*****

  type EXTI_Number is new Integer range 0 .. 22;

--****t* Stm32.EXTI/EXTI_Mask
--
--  NAME
--    EXTI_Mask -- The EXTI lines mask.
--  USAGE
--    An array of Boolean indexed by EXTI_Number.
--  SEE ALSO
--    EXTI_Number
--
--*****

  type EXTI_Mask is array (EXTI_Number) of Boolean;
  pragma Pack (EXTI_Mask);

--****t* Stm32.EXTI/EXTI_Lines
--
--  NAME
--    EXTI_Line -- The actual mask of EXTI lines.
--  USAGE
--    A record with a field, Mask of type EXTI_Mask.
--  SEE ALSO
--    EXTI_Mask
--
--*****

  type EXTI_Lines is record
    Mask : EXTI_Mask;
  end record;
  for EXTI_Lines use record
    Mask at 0 range 0 .. 22;
  end record;
  for EXTI_Lines'Size use 32;

--****t* Stm32.EXTI/EXTI_Mode
--
--  NAME
--    EXTI_Mode -- The mode of the EXTI.
--  USAGE
--    Choose between :
--      * Mode_Interrupt : For interrupts.
--      * Mode_Event : For events.
--
--*****

  type EXTI_Mode is (Mode_Interrupt, Mode_Event);
  for EXTI_Mode use
    (Mode_Interrupt => 16#00#,
     Mode_Event     => 16#04#);

--****t* Stm32.EXTI/EXTI_Trigger
--
--  NAME
--    EXTI_Trigger -- The event that triggers an interrupt.
--  USAGE
--    Choose between :
--      * Rising : A rising trigger.
--      * Falling : A falling trigger.
--      * Rising_Falling : Both rising and falling trigger.
--
--*****

  type EXTI_Trigger is (Rising, Falling, Rising_Falling);
  for EXTI_Trigger use
    (Rising         => 16#08#,
     Falling        => 16#0C#,
     Rising_Falling => 16#10#);

--****t* Stm32.EXTI/EXTI_Params
--
--  NAME
--    EXTI_Params -- The parameters of the EXTI.
--  USAGE
--    Define the following field of this record :
--      * EXTI : The mask of the lines, of type EXTI_Lines.
--      * Mode : The mode of the EXTI, of type EXTI_Mode.
--      * Trigger : The trigger event of the EXTI, of type EXTI_Trigger.
--      * LineCmd : Activation of the EXTI, of type FunctionalState.
--  SEE ALSO
--    EXTI_Lines, EXTI_Mode, EXTI_Trigger, Stm32.Defines/FunctionalState
--
--*****

  type EXTI_Params is record
    EXTI : EXTI_Lines := (Mask => (others => False));
    Mode : EXTI_Mode := Mode_Interrupt;
    Trigger : EXTI_Trigger := Falling;
    LineCmd : FunctionalState := Disable;
  end record;

--****f* Stm32.EXTI/EXTI_ClearFlag
--
--  NAME
--    EXTI_ClearFlag -- Clears the EXTI's line pending flags.
--  SYNOPSIS
--    EXTI_ClearFlag (EXTI);
--  FUNCTION
--    Clears the EXTI's line pending flags.
--  INPUTS
--    EXTI - The EXTI line, of type EXTI_Line.
--  SEE ALSO
--    EXTI_Line
--
--*****

  procedure EXTI_ClearFlag (EXTI : EXTI_Line);
  pragma Import (C, EXTI_ClearFlag, "EXTI_ClearFlag");

--****f* Stm32.EXTI/EXTI_ClearITPendingBit
--
--  NAME
--    EXTI_ClearITPendingBit -- Clears the EXTI's line pending bits.
--  SYNOPSIS
--    EXTI_ClearITPendingBit(EXTI);
--  FUNCTION
--    Clears the EXTI's line pending bits.
--  INPUTS
--    EXTI - The EXTI line, of type EXTI_Line.
--  SEE ALSO
--    EXTI_Line
--
--*****

  procedure EXTI_ClearITPendingBit (EXTI : EXTI_Line);
  pragma Import (C, EXTI_ClearITPendingBit, "EXTI_ClearITPendingBit");

--****f* Stm32.EXTI/EXTI_DeInit
--
--  NAME
--    EXTI_DeInit -- Deinitialize the EXTI peripheral.
--  SYNOPSIS
--    EXTI_DeInit;
--  FUNCTION
--    Deinitialize the EXTI peripheral with the reset values.
--
--*****

  procedure EXTI_DeInit;
  pragma Import (C, EXTI_DeInit, "EXTI_DeInit");

--****f* Stm32.EXTI/EXTI_GenerateSWInterrupt
--
--  NAME
--    EXTI_GenerateSWInterrupt -- Generates software interrupt.
--  SYNOPSIS
--    EXTI_GenerateSWInterrupt(EXTI);
--  FUNCTION
--    Generates software interrupt on the given EXTI line.
--  INPUTS
--    EXTI - The EXTI line, of type EXTI_Line
--  SEE ALSO
--    EXTI_Line
--
--*****

  procedure EXTI_GenerateSWInterrupt (EXTI : EXTI_Line);
  pragma Import (C, EXTI_GenerateSWInterrupt, "EXTI_GenerateSWInterrupt");

--****f* Stm32.EXTI/EXTI_GetFlagStatus
--
--  NAME
--    EXTI_GetFlagStatus -- Says if the EXTI line flag is set.
--  SYNOPSIS
--    Value := EXTI_GetFlagStatus(EXTI);
--  FUNCTION
--    Says if the EXTI line flag is set or not.
--  INPUTS
--    EXTI - The EXTI line, of type EXTI_Line.
--  RESULT
--    Value - A boolean indicating if the EXTI flag is set or not.
--  SEE ALSO
--    EXTI_Line
--
--*****

  function EXTI_GetFlagStatus (EXTI : EXTI_Line) return Boolean;

--****f* Stm32.EXTI/EXTI_EXTI_GetITStatus
--
--  NAME
--    EXTI_GetITStatus -- Checks if the specified EXTI line is asserted.
--  SYNOPSIS
--    EXTI_GetITStatus(EXTI);
--  FUNCTION
--    Checks whether the specified EXTI line is asserted or not.
--  INPUTS
--    EXTI - The EXTI line, of type EXTI_Line.
--  RESULT
--    Value - A Boolean indicating if the specified EXTI line is asserted.
--  SEE ALSO
--    EXTI_Line
--
--*****

  function EXTI_GetITStatus (EXTI : EXTI_Line) return Boolean;

--****f* Stm32.EXTI/Config_EXTI
--
--  NAME
--    Config_EXTI -- Initializes the EXTI peripheral.
--  SYNOPSIS
--    Config_EXTI(Params);
--  FUNCTION
--    Initializes the EXTI peripheral with the given parameters.
--  INPUTS
--    Params - The EXTI parameters, of type EXTI_Params
--  SEE ALSO
--    EXTI_Params
--*****

  procedure Config_EXTI (Params : EXTI_Params);

end Stm32.EXTI;
