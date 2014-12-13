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

--with Ada.Text_IO; use Ada.Text_IO;

package body Hw.Led is

  type State_Type is (On, Off);
  State : array (Board_Led_Type) of State_Type;

  -----------------
  -- Print_State --
  -----------------

  procedure Print_State is
  begin
    null;
--    for I in Led_Type loop
--      Put (State (I)'Img & " ");
--    end loop;
--    Put_Line ("");
  end Print_State;

  ----------------------
  -- PUBLIC FUNCTIONS --
  ----------------------

  ------------
  -- Led_On --
  ------------

  procedure Led_On (Led : Board_Led_Type) is
  begin
    if State (Led) /= On then
      State (Led) := On;
      Print_State;
    end if;
  end Led_On;

  -------------
  -- Led_Off --
  -------------

  procedure Led_Off (Led : Board_Led_Type) is
  begin
    if State (Led) /= Off then
      State (Led) := Off;
      Print_State;
    end if;
  end Led_Off;

  ----------------
  -- Led_Toggle --
  ----------------

  procedure Led_Toggle (Led : Board_Led_Type) is
  begin
    case State (Led) is
      when On =>
        Led_Off (Led);
      when Off =>
        Led_On (Led);
    end case;
  end Led_Toggle;

  -----------------
  -- Top_Leds_On --
  -----------------

  procedure Top_Led_On is
  begin
    null;
  end Top_Led_On;

  ------------------
  -- Top_Leds_Off --
  ------------------

  procedure Top_Led_Off is
  begin
    null;
  end Top_Led_Off;

  -------------------
  -- Set_Color_Led --
  -------------------

  procedure Set_Color_Led (Color : Common.Types.Color_Type) is
    pragma Unreferenced (Color);
  begin
    null;
  end Set_Color_Led;

  -------------------
  -- Set_Color_Led --
  -------------------

  procedure Set_Color_Led_Off is
  begin
    null;
  end Set_Color_Led_Off;

end Hw.Led;
