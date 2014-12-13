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

package body Hw.Led is

  --------------------
  -- Hardware_Setup --
  --------------------

  procedure Hardware_Setup is
  begin
    for I in Board_Led_Type loop
      Setup_Out_Pin (Main_Leds (I));
      Set_Pin (Main_Leds (I), False);
    end loop;
    Setup_Out_Pin (Top_Led_Pin);
  end Hardware_Setup;

  ------------
  -- Led_On --
  ------------

  procedure Led_On (Led : Board_Led_Type) is
    use Common.Types;
  begin
    if Led = Common.Types.Error then
      -- Special case error to help setting breakpoint in gdb.
      Set_Pin (Main_Leds (Led), True);
    else
      Set_Pin (Main_Leds (Led), True);
    end if;
  end Led_On;

  -------------
  -- Led_Off --
  -------------

  procedure Led_Off (Led : Board_Led_Type) is
  begin
    Set_Pin (Main_Leds (Led), False);
  end Led_Off;

  ----------------
  -- Led_Toggle --
  ----------------

  procedure Led_Toggle (Led : Board_Led_Type) is
  begin
    Toggle_Pin (Main_Leds (Led));
  end Led_Toggle;

  ----------------
  -- Top_Led_On --
  ----------------

  procedure Top_Led_On is
  begin
    Set_Pin (Top_Led_Pin, True);
  end Top_Led_On;

  -----------------
  -- Top_Led_Off --
  -----------------

  procedure Top_Led_Off is
  begin
    Set_Pin (Top_Led_Pin, False);
  end Top_Led_Off;

  -------------------
  -- Set_Color_Led --
  -------------------

  procedure Set_Color_Led (Color : Common.Types.Color_Type) is
    use Common.Types;
  begin
    Setup_Out_Pin (Top_Color_Led_Pin);
    if Color = Yellow then
      Set_Pin (Top_Color_Led_Pin, True);
    else
      Set_Pin (Top_Color_Led_Pin, False);
    end if;
  end Set_Color_Led;

  -----------------------
  -- Set_Color_Led_Off --
  -----------------------

  procedure Set_Color_Led_Off is
  begin
    Setup_In_Pin (Top_Color_Led_Pin);
  end Set_Color_Led_Off;

begin
  Hardware_Setup;
end Hw.Led;
