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

with Protected_Queue;
pragma Elaborate_All (Protected_Queue);

package body Counter_Queue is
  type Raw_Counter_Type is record
    Left : Unsigned_16;
    Right : Unsigned_16;
  end record;

  package Queue_Pkg is new Protected_Queue (Raw_Counter_Type, 10);

  Queue : Queue_Pkg.Queue;

  ----------------------
  -- PUBLIC FUNCTIONS --
  ----------------------

  ---------
  -- Add --
  ---------

  procedure Add (Raw_Left : Unsigned_16;
                 Raw_Right : Unsigned_16) is
  begin
    Queue.Add ((Raw_Left, Raw_Right));
  end Add;

  ---------
  -- Get --
  ---------

  procedure Get (Raw_Left : out Unsigned_16;
                 Raw_Right : out Unsigned_16) is
    Counters : Raw_Counter_Type;
    Valid : Boolean := False;
  begin
    while not Valid loop
      Queue.Get (Counters, Valid);
    end loop;
    Raw_Left := Counters.Left;
    Raw_Right := Counters.Right;
  end Get;

end Counter_Queue;
