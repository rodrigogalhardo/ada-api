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
with Hw.Digital_Servo_Low; use Hw.Digital_Servo_Low;

package Hw.Digital_Servo_High is

  Empty_Arg : constant Params_Type (1 .. 0) := (others => 0);

  function Get_Reg (Servo : Digital_Servo_Type; Reg : Unsigned_8) return Unsigned_8;
  function Get_Reg16 (Servo : Digital_Servo_Type; Reg : Unsigned_8) return Unsigned_16;
  procedure Set_Reg (Servo : Digital_Servo_Type; Reg : Unsigned_8; Val : Unsigned_8);
  procedure Set_Reg16 (Servo : Digital_Servo_Type; Reg : Unsigned_8; Val : Unsigned_16);
  procedure Reset (Servo : Digital_Servo_Type);

  procedure Set_Buffered(Value : Boolean);
  procedure Execute;

end Hw.Digital_Servo_High;
