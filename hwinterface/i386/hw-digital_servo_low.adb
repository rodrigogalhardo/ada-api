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

package body Hw.Digital_Servo_Low is

  procedure Set_Retry_Number (Number : Integer) is
    pragma Unreferenced (Number);
  begin
    null;
  end Set_Retry_Number;

  function Send_Command (Servo : Digital_Servo_Type;
                         Cmd : Unsigned_8;
                         Params : Params_Type) return Servo_Reply is
    pragma Unreferenced (Servo);
    pragma Unreferenced (Cmd);
    pragma Unreferenced (Params);
  begin
    return (Error => 0, Length => 0, Params => (others => 0));
  end Send_Command;

  procedure Send_Command_No_Result (Servo : Digital_Servo_Type;
                                    Cmd : Unsigned_8;
                                    Params : Params_Type) is
    pragma Unreferenced (Servo);
    pragma Unreferenced (Cmd);
    pragma Unreferenced (Params);
  begin
    null;
  end Send_Command_No_Result;

end Hw.Digital_Servo_Low;
