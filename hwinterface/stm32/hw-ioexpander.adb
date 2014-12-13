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

with Ada.Real_Time; use Ada.Real_Time;
with Common.Types;
with Hw.Hw_Config; use Hw.Hw_Config;
with Hw.Led;
pragma Elaborate_All (Hw.Led);
with Stm32.I2C; use Stm32.I2C;
pragma Elaborate_All (Stm32.I2C);

package body Hw.IOExpander is
  IODIR : constant array (Port_Type) of Unsigned_8 :=
    (Port_A => 16#00#, Port_B => 16#01#);
  OLAT : constant array (Port_Type) of Unsigned_8 :=
    (Port_A => 16#14#, Port_B => 16#15#);

  Initialized : Boolean := False;

  procedure Init is
  begin
    Initialized := True;

    Configure_Pins (Hw.Hw_Config.IOExpander.I2C,
                    Hw.Hw_Config.IOExpander.SDA,
                    Hw.Hw_Config.IOExpander.SCL);
    I2C_Init (Hw.Hw_Config.IOExpander.I2C,
              (Clock_Speed => 10000,
               Mode => I2C,
               Duty_Cycle => Duty_Cycle_2,
               Own_Address_1 => 0,
               Ack => Disable,
               Ack_Address => Seven_Bits));
    delay until Clock + To_Time_Span (0.1);

    -- Configure the IOExpander.
    for Port in Port_Type loop
      if not Stm32.I2C.Write (Hw.Hw_Config.IOExpander.I2C,
                              IOExpander_Address,
                              (IODIR (Port), 16#00#)) then
        Hw.Led.Led_On (Common.Types.Error);
        Initialized := False;
      end if;
    end loop;
    if Initialized then
      Hw.Led.Led_Off (Common.Types.Error);
    end if;
  end Init;

  procedure Write (Port : Port_Type; Value : Unsigned_8) is
    Data : constant Stm32.I2C.Data_Array (1 .. 2) := (OLAT (Port), Value);
  begin
    if not Initialized then
      Init;
    end if;
    if not Stm32.I2C.Write (Hw.Hw_Config.IOExpander.I2C, IOExpander_Address, Data) then
      Hw.Led.Led_On (Common.Types.Error);
    end if;
  end Write;

end Hw.IOExpander;
