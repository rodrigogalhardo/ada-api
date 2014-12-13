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

package Hw.Gyroscope is
  type Gyroscope_Status is (Empty,Full );
  type Gyroscope_Data_3axis is record
	X : Integer_16;
	Y : Integer_16;
	Z : Integer_16;
  end record;
  function Get_Gyroscope_Status  return Gyroscope_Status;
   function Get_Gyroscope_Next_Data  return Gyroscope_Data_3axis;

end Hw.Gyroscope;
