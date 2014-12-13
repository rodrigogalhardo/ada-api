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

-- A small wrapper around Hw.Button_Base to allow override.
package Hw.Button is
  function User_Button return Boolean;
  function Top_Switch return Boolean;

  function Start_Button return Boolean;
  function Red_Button return Boolean;
  function Color_Button return Boolean;

  procedure Set_Start_Button_Override (Value : Boolean);
  procedure Clear_Start_Button_Override;

  procedure Set_Red_Button_Override (Value : Boolean);
  procedure Clear_Red_Button_Override;

  procedure Set_Color_Button_Override (Value : Boolean);
  procedure Clear_Color_Button_Override;
end Hw.Button;
