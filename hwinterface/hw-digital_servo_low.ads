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

package Hw.Digital_Servo_Low is

  type Bus_Type is (Bus_1);

  Broadcast : constant Digital_Servo_Type := 254;

  type Params_Type is array (Integer range <>) of Unsigned_8;
  subtype Params_Max_Type is Params_Type (0 .. 15);

  type Servo_Reply is record
    Error  : Unsigned_8;
    Length : Unsigned_8;
    Params : Params_Max_Type;
  end record;

  Digital_Servo_Exception : exception;

  procedure Set_Retry_Number (Number : Integer);

  function Send_Command (Servo : Digital_Servo_Type;
                         Cmd : Unsigned_8;
                         Params : Params_Type) return Servo_Reply;

  procedure Send_Command_No_Result (Servo : Digital_Servo_Type;
                                    Cmd : Unsigned_8;
                                    Params : Params_Type);

end Hw.Digital_Servo_Low;
