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

with Hw.Hw_Config; use Hw.Hw_Config;
with Stm32.GPIO; use Stm32.GPIO;
pragma Elaborate_All (Stm32.GPIO);

package body Hw.Paintings is

  -------------------
  -- Setup_In_Pin --
  -------------------

  procedure Setup_In_Pin (Pin : Pin_Type) is
    GPIO : GPIO_Params;
  begin
    GPIO := (Pins        => (Mask => (others => False)),
             Mode        => Mode_In,
             Speed       => Speed_100MHz,
             Output_Type => PP,
             PuPd        => Pull_Up);
    GPIO.Pins.Mask (Pin.Pin) := True;
    Config_GPIO (Pin.Port, GPIO);
  end Setup_In_Pin;

  ----------------
  -- Get_Status --
  ----------------

  function Get_Status (Side : Side_Type) return Boolean is
    pragma Unreferenced (Side);
  begin
    return False;
  end Get_Status;

  function Get_Sharp (Side : Side_Type) return Boolean is
  begin
    case Side is
      when Left =>
        return not Read_Pin (Paintings_Left);
      when Right =>
        return not Read_Pin (Paintings_Right);
    end case;
  end Get_Sharp;

begin
  Setup_In_Pin (Paintings_Left);
  Setup_In_Pin (Paintings_Right);
end Hw.Paintings;
