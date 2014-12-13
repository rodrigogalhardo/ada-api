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
with Hw.ADC;
with Hw.Hw_Config; use Hw.Hw_Config;
with Stm32.GPIO; use Stm32.GPIO;
pragma Elaborate_All (Stm32.GPIO);

package body Hw.Button_Base is

  -----------------
  -- User_Button --
  -----------------

  function User_Button return Boolean is
  begin
    return Read_Pin (User_Button_Pin);
  end User_Button;

  ----------------
  -- Top_Switch --
  ----------------

  function Top_Switch return Boolean is
  begin
    return Read_Pin (Top_Switch_Pin);
  end Top_Switch;

  ------------------
  -- Start_Button --
  ------------------

  function Start_Button return Boolean is
  begin
    return not Read_Pin (Start_Button_Pin);
  end Start_Button;

  ----------------
  -- Red_Button --
  ----------------

  function Red_Button return Boolean is
  begin
    return Hw.ADC.Get_Value (Engines) > 3700;
  end Red_Button;

  ------------------
  -- Color_Button --
  ------------------

  function Color_Button return Boolean is
  begin
    return Read_Pin (Color_Button_Pin);
  end Color_Button;

begin
  Setup_In_Pin (Start_Button_Pin);
  Setup_In_Pin (Color_Button_Pin);
  Setup_In_Pin (Top_Switch_Pin);
end Hw.Button_Base;
