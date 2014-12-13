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
with System; use System;

package body Hw.Current_Bot is
  type UID_Type is array (1 .. 3) of Unsigned_32;
  UID : constant UID_Type;
  for UID'Address use System'To_Address (16#1FFF7A10#);
  pragma Import (Ada, UID);

--  Small_UID : constant UID_Type := (16#001f0021#, 16#31314715#, 16#31343533#);
--  Small_UID : constant UID_Type := (16#1B0034#, 16#32314714#, 16#31383435#);
  Small_UID : constant UID_Type := (16#1F002D#, 16#31314715#, 16#31343533#);
--  Small_UID : constant UID_Type := (16#41002A#, 16#32314717#, 16#31383435#);
--  Small_UID : constant UID_Type := (16#1A0025#, 16#31334710#, 16#30373039#);

  Current : Own_Bot_Type;
  Initialized : Boolean := False;

  ---------
  -- Get --
  ---------

  function Get return Own_Bot_Type is
  begin
    if not Initialized then
      if UID = Small_UID then
        Current := Small;
      else
        Current := Big;
      end if;
      Initialized := True;
    end if;
    return Current;
  end Get;
end Hw.Current_Bot;
