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

with Common.Types;

package Hw.Led is
  subtype Board_Led_Type is Common.Types.Led_Type;

  procedure Led_On (Led : Board_Led_Type);
  procedure Led_Off (Led : Board_Led_Type);
  procedure Led_Toggle (Led : Board_Led_Type);

  procedure Top_Led_On;
  procedure Top_Led_Off;

  procedure Set_Color_Led (Color : Common.Types.Color_Type);
  procedure Set_Color_Led_Off;
end Hw.Led;

