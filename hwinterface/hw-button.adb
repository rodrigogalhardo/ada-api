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

with Hw.Button_Base;

package body Hw.Button is

  Start_Override_Value : Boolean := False;
  Start_Override : Boolean := False;

  Red_Override_Value : Boolean := False;
  Red_Override : Boolean := False;

  Color_Override_Value : Boolean := False;
  Color_Override : Boolean := False;

  -----------------
  -- User_Button --
  -----------------

  function User_Button return Boolean is
  begin
    return Hw.Button_Base.User_Button;
  end User_Button;

  ----------------
  -- Top_Switch --
  ----------------

  function Top_Switch return Boolean is
  begin
    return Hw.Button_Base.Top_Switch;
  end Top_Switch;

  ------------------
  -- Start_Button --
  ------------------

  function Start_Button return Boolean is
  begin
    if Start_Override then
      return Start_Override_Value;
    else
      return Hw.Button_Base.Start_Button;
    end if;
  end Start_Button;

  -------------------------------
  -- Set_Start_Button_Override --
  -------------------------------

  procedure Set_Start_Button_Override (Value : Boolean) is
  begin
    Start_Override_Value := Value;
    Start_Override := True;
  end Set_Start_Button_Override;

  ---------------------------------
  -- Clear_Start_Button_Override --
  ---------------------------------

  procedure Clear_Start_Button_Override is
  begin
    Start_Override := False;
  end Clear_Start_Button_Override;

  ------------------
  -- Red_Button --
  ------------------

  function Red_Button return Boolean is
  begin
    if Red_Override then
      return Red_Override_Value;
    else
      return Hw.Button_Base.Red_Button;
    end if;
  end Red_Button;

  -------------------------------
  -- Set_Red_Button_Override --
  -------------------------------

  procedure Set_Red_Button_Override (Value : Boolean) is
  begin
    Red_Override_Value := Value;
    Red_Override := True;
  end Set_Red_Button_Override;

  ---------------------------------
  -- Clear_Red_Button_Override --
  ---------------------------------

  procedure Clear_Red_Button_Override is
  begin
    Red_Override := False;
  end Clear_Red_Button_Override;

  ------------------
  -- Color_Button --
  ------------------

  function Color_Button return Boolean is
  begin
    if Color_Override then
      return Color_Override_Value;
    else
      return Hw.Button_Base.Color_Button;
    end if;
  end Color_Button;

  -------------------------------
  -- Set_Color_Button_Override --
  -------------------------------

  procedure Set_Color_Button_Override (Value : Boolean) is
  begin
    Color_Override_Value := Value;
    Color_Override := True;
  end Set_Color_Button_Override;

  ---------------------------------
  -- Clear_Color_Button_Override --
  ---------------------------------

  procedure Clear_Color_Button_Override is
  begin
    Color_Override := False;
  end Clear_Color_Button_Override;

end Hw.Button;
