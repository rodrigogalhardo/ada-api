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
with Common.Types; use Common.Types;
with Hw.Digital_Servo_High; use Hw.Digital_Servo_High;
with Hw.Digital_Servo_Low; use Hw.Digital_Servo_Low;

package Hw.Digital_Servo is

  -------------------------
  -- Low level interface --
  -------------------------

  subtype Params_Type is Hw.Digital_Servo_Low.Params_Type;
  subtype Params_Max_Type is Hw.Digital_Servo_Low.Params_Max_Type;

  subtype Servo_Reply is Hw.Digital_Servo_Low.Servo_Reply;

  procedure Set_Retry_Number (Number : Integer)
      renames Hw.Digital_Servo_Low.Set_Retry_Number;

  function Send_Command (Servo : Digital_Servo_Type;
                         Cmd : Unsigned_8;
                         Params : Params_Type) return Servo_Reply
      renames Hw.Digital_Servo_Low.Send_Command;

  procedure Send_Command_No_Result (Servo : Digital_Servo_Type;
                                    Cmd : Unsigned_8;
                                    Params : Hw.Digital_Servo.Params_Type)
      renames Hw.Digital_Servo_Low.Send_Command_No_Result;

  --------------------------
  -- High level interface --
  --------------------------

  Empty_Arg : Hw.Digital_Servo.Params_Type
      renames Hw.Digital_Servo_High.Empty_Arg;

  function Get_Reg(Servo : Digital_Servo_Type; Reg : Unsigned_8)
      return Unsigned_8 renames Hw.Digital_Servo_High.Get_Reg;
  function Get_Reg16(Servo : Digital_Servo_Type; Reg : Unsigned_8)
      return Unsigned_16 renames Hw.Digital_Servo_High.Get_Reg16;
  procedure Set_Reg(Servo : Digital_Servo_Type;
                    Reg : Unsigned_8;
                    Val : Unsigned_8)
      renames Hw.Digital_Servo_High.Set_Reg;
  procedure Set_Reg16(Servo : Digital_Servo_Type;
                      Reg : Unsigned_8;
                      Val : Unsigned_16)
      renames Hw.Digital_Servo_High.Set_Reg16;

  procedure Set_Buffered(Value : Boolean)
      renames Hw.Digital_Servo_High.Set_Buffered;
  procedure Execute renames Hw.Digital_Servo_High.Execute;

  procedure Reset (Servo : Digital_Servo_Type) renames Hw.Digital_Servo_High.Reset;

  -------------------
  -- Configuration --
  -------------------

--  procedure Configure_Servo (Servo : Digital_Servo_Type;
--                             Bus : Bus_Type)
--      renames Hw.Digital_Servo_Config.Configure_Servo;
--  procedure Configure_Bus (Bus : Bus_Type; FD : int)
--      renames Hw.Digital_Servo_Config.Configure_Bus;
--  procedure Configure_Bus (Bus : Bus_Type; RS : RS232_Type)
--      renames Hw.Digital_Servo_Config.Configure_Bus;
--
--  function Get_Servo_Bus (Servo : Digital_Servo_Type) return Bus_Type
--      renames Hw.Digital_Servo_Config.Get_Servo_Bus;
--
--  function Is_Internal (Bus : Bus_Type) return Boolean
--      renames Hw.Digital_Servo_Config.Is_Internal;

end Hw.Digital_Servo;
