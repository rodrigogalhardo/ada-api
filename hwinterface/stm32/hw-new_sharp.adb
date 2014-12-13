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

with Current_Bot;
with Hw.Hw_Config; use Hw.Hw_Config;
with Stm32.GPIO; use Stm32.GPIO;
pragma Elaborate_All (Stm32.GPIO);

package body Hw.New_Sharp is

  -------------------
  -- Setup_In_Pin --
  -------------------

  procedure Setup_In_Pin (Pin : Pin_Type; Pull : GPIO_PuPd) is
    GPIO : GPIO_Params;
  begin
    GPIO := (Pins        => (Mask => (others => False)),
             Mode        => Mode_In,
             Speed       => Speed_100MHz,
             Output_Type => PP,
             PuPd        => Pull);
    GPIO.Pins.Mask (Pin.Pin) := True;
    Config_GPIO (Pin.Port, GPIO);
  end Setup_In_Pin;

  function Get_New_Sharp (NS : New_Sharp_Type) return Boolean is
  begin
    case NS is
      when Front =>
        return Read_Pin (New_Sharp_1_Pin);
      when Back =>
        if Current_Bot = Small then
          return not Read_Pin (New_Sharp_Inverted_Pin);
        else
          return not Read_Pin (New_Sharp_2_Pin) or not Read_Pin (New_Sharp_3_Pin) ;
        end if;
    end case;
  end Get_New_Sharp;

begin
  Setup_In_Pin (New_Sharp_1_Pin, Pull_Down);
  Setup_In_Pin (New_Sharp_2_Pin, Pull_Down);
  Setup_In_Pin (New_Sharp_3_Pin, Pull_Down);
  Setup_In_Pin (New_Sharp_Inverted_Pin, Pull_Up);
end Hw.New_Sharp;
