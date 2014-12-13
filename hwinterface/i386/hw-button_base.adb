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

package body Hw.Button_Base is
  ----------------------
  -- PUBLIC FUNCTIONS --
  ----------------------

  function User_Button return Boolean is
  begin
    return False;
  end User_Button;

  function Top_Switch return Boolean is
  begin
    return False;
  end Top_Switch;

  function Start_Button return Boolean is
  begin
    return False;
  end Start_Button;

  function Red_Button return Boolean is
  begin
    return False;
  end Red_Button;

  function Color_Button return Boolean is
  begin
    return False;
  end Color_Button;
end Hw.Button_Base;
