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

package body Hw.Gyroscope is

  Initialized : Boolean := False;
  WhoAmIData : Unsigned_8;
  procedure Init is
  begin
    Initialized := True;

    Configure_Pins (Hw.Hw_Config.Gyroscope.I2C,
                    Hw.Hw_Config.Gyroscope.SDA,
                    Hw.Hw_Config.Gyroscope.SCL);
    I2C_Init (Hw.Hw_Config.Gyroscope.I2C,
              (Clock_Speed => 10000,
               Mode => I2C,
               Duty_Cycle => Duty_Cycle_2,
               Own_Address_1 => 0,
               Ack => Disable,
               Ack_Address => Seven_Bits));
    delay until Clock + To_Time_Span (0.1);

	    -- Read the Gyroscope WhoAmI register, compare it to expected value
		Stm32.I2C.Read (Hw.Hw_Config.Gyroscope.I2C,
                              WHO_AM_I,
							  WhoAmIData,
                              Success);
      if WhoAmIData /= 16#D3#  then
        Hw.Led.Led_On (Common.Types.Error);
        Initialized := False;
      end if;
	
	
    -- Configure the Gyroscope. output rate (ODR) is 200Hz, cut off is 50 Hz, Enable all axes
      if not Stm32.I2C.Write (Hw.Hw_Config.Gyroscope.I2C,
                              Gyroscope_Address,
                              (CTRL_REG1, 16#6F#)) then
        Hw.Led.Led_On (Common.Types.Error);
        Initialized := False;
      end if;
    -- Configure the Gyroscope. Block data update little endian, Full scale 500 dps
      if not Stm32.I2C.Write (Hw.Hw_Config.Gyroscope.I2C,
                              Gyroscope_Address,
                              (CTRL_REG4, 16#90#)) then
        Hw.Led.Led_On (Common.Types.Error);
        Initialized := False;
      end if;  
	  
    if Initialized then
      Hw.Led.Led_Off (Common.Types.Error);
    end if;
  end Init;

  
  function Get_Gyroscope_Next_Data  return Gyroscope_Data_3axis is
    Data : Unsigned_16;
	G_Data_3axis : Gyroscope_Data_3axis;
  begin
    if not Initialized then
      Init;
    end if;
	
	-- Wait until new data ready
	while( Get_Gyroscope_Status  /= Full) loop
		delay until Clock + To_Time_Span (0.001);-- 1 ms wait to avoid overloading the processor, new data will be available each 5 ms at 200 Hz
	end loop; 
	Stm32.I2C.Read (Hw.Hw_Config.Gyroscope.I2C, OUT_X,  G_Data_3axis.X , Success);
	Stm32.I2C.Read (Hw.Hw_Config.Gyroscope.I2C, OUT_Y,  G_Data_3axis.Y , Success);
	Stm32.I2C.Read (Hw.Hw_Config.Gyroscope.I2C, OUT_Z,  G_Data_3axis.Z , Success);
	return G_Data_3axis;
  end Get_Gyroscope_Next_Data;
  
  function Get_Gyroscope_Status  return Gyroscope_Status is
    Data : Unsigned_8;
	G_Status : Gyroscope_Status;
  begin
    if not Initialized then
      Init;
    end if;
	-- Read status register
	Stm32.I2C.Read (Hw.Hw_Config.Gyroscope.I2C, STATUS_REG, Data, Success);
    if not Success then
      Hw.Led.Led_On (Common.Types.Error);
    end if;
	if( Data & 16#04#) then-- Check ZYXDA bit
		G_Status := Full;
	else
		G_Status := Empty;
	end if;
	return G_Status;
  end Get_Gyroscope_Status;
  
  
  

end Hw.Gyroscope;
