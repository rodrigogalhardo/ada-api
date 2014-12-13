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

-- with Ada.Text_IO; use Ada.Text_IO;
with Ada.Unchecked_Conversion;
with Bot_Position; use Bot_Position;
with Common.Types; use Common.Types;
with Config; use Config;
with Current_Bot;
with Hw.PWM;
with Interfaces.C; use Interfaces.C;
with Math; use Math;
with Point; use Point;

--with GNAT.Exception_Traces;  use GNAT.Exception_Traces;

package body Hw.Counter_Simu is
  pragma Linker_Options ("-lmotor");

  procedure Engine_Loop(Left : access Integer_16;
                        Right : access Integer_16;
                        Time : C_float);
  pragma Import (C, Engine_Loop, "engine_loop");

  procedure Init_Robot;
  pragma Import (C, Init_Robot, "init_robot");

  function Integer_To_Unsigned is
          new Ada.Unchecked_Conversion (Source => Integer_16,
                                        Target => Unsigned_16);

  Old_Motor_Left : Unsigned_16 := 0;
  Old_Motor_Right : Unsigned_16 := 0;

  Simu_Left : Unsigned_16 := 0;
  Simu_Right : Unsigned_16 := 0;

  ------------------------
  -- Point_In_Direction --
  ------------------------

  function Point_In_Direction (P : Point_Type;
                               Theta : Float;
                               Dist : Integer) return Point_Type is
  begin
    return (X => P.X + Integer (Float (Dist) * Cos (Theta * Pi / 180.0)),
            Y => P.Y + Integer (Float (Dist) * Sin (Theta * Pi / 180.0)));
  end Point_In_Direction;

  --------------
  -- In_Table --
  --------------

  Robots_Width : constant array (Own_Bot_Type) of Integer
      := (Big => 300, Small => 160);
  Robots_Height : constant array (Own_Bot_Type) of Integer
      := (Big => 280, Small => 150);

  function In_Table (X : Integer; Y : Integer;
                     Theta : Float) return Boolean is
    Width : constant Integer := 3000;
    Height : constant Integer := 2000;
    Robot_Width : constant Integer := Robots_Width (Current_Bot);
    Robot_Height : constant Integer := Robots_Height (Current_Bot);
    Robot_Back : constant Integer := Config.Back_Size;

    Robot_Middle : constant Point_Type := (X => X, Y => Y);
    Wheel_G : constant Point_Type := Point_In_Direction (
        Robot_Middle, Theta + 90.0, Robot_Width / 2);
    Wheel_D : constant Point_Type := Point_In_Direction (
        Robot_Middle, Theta - 90.0, Robot_Width / 2);
    Up_Left : constant Point_Type := Point_In_Direction (
        Wheel_G, Theta, Robot_Height - Robot_Back);
    Up_Right : constant Point_Type := Point_In_Direction (
        Wheel_D, Theta, Robot_Height - Robot_Back);
    Down_Left : constant Point_Type := Point_In_Direction (
        Wheel_G, 180.0 + Theta, Robot_Back);
    Down_Right : constant Point_Type := Point_In_Direction (
        Wheel_D, 180.0 + Theta, Robot_Back);

    function Check (P : Point_Type) return Boolean is
      Result : Boolean;
    begin
      Result := P.X >= 0 and P.Y >= 0
        and P.X <= Width and P.Y <= Height;

      -- Check the drop zones.
      Result := Result and not (P.X > 400 and P.X < 1100 and P.Y < 300);
      Result := Result and not (P.X > 1900 and P.X < 2600 and P.Y < 300);

      -- Check the middle of the table.
      Result := Result and not (Distance (P, (1500, 1050)) < 150);
      return Result;
    end Check;

  begin
    return Check (Up_Left) and Check (Down_Left)
        and Check (Up_Right) and Check (Down_Right);
  end In_Table;

  -----------------------
  -- Get_Next_Counters --
  -----------------------

  procedure Get_Next_Counters (Raw_Left : out Unsigned_16;
                               Raw_Right : out Unsigned_16) is
    Motor_Delta_Left : Unsigned_16;
    Motor_Delta_Right : Unsigned_16;

    function Test_Table (Delta_Left : Unsigned_16;
                         Delta_Right : Unsigned_16) return Boolean is
      X : Integer;
      Y : Integer;
      Theta : Float;
      Counter_Left : constant Unsigned_16 := Simu_Left + Delta_Left;
      Counter_Right : constant Unsigned_16 := Simu_Right + Delta_Right;
    begin
      Bot_Position.Get_New_Position (Counter_Left,
                                     Counter_Right,
                                     X, Y, Theta);
      return In_Table (X, Y, Theta);
    end Test_Table;

    procedure Limit_To_Table (Blocked_Left : out Unsigned_16;
                              Blocked_Right : out Unsigned_16) is
    begin
      if Test_Table (Motor_Delta_Left, Motor_Delta_Right) then
        Blocked_Left := Motor_Delta_Left;
        Blocked_Right := Motor_Delta_Right;
      elsif Test_Table (Motor_Delta_Left, 0) then
        Blocked_Left := Motor_Delta_Left;
        Blocked_Right := 0;
      elsif Test_Table (0, Motor_Delta_Right) then
        Blocked_Left := 0;
        Blocked_Right := Motor_Delta_Right;
      elsif Test_Table (Motor_Delta_Left, Motor_Delta_Left) then
        Blocked_Left := Motor_Delta_Left;
        Blocked_Right := Motor_Delta_Left;
      elsif Test_Table (Motor_Delta_Right, Motor_Delta_Right) then
        Blocked_Left := Motor_Delta_Right;
        Blocked_Right := Motor_Delta_Right;
      else
        Blocked_Left := 0;
        Blocked_Right := 0;
      end if;
    end Limit_To_Table;

    Cmd_Left : Integer_32;
    Cmd_Right : Integer_32;
    Left : aliased Integer_16;
    Right : aliased Integer_16;
    Blocked_Left : Unsigned_16;
    Blocked_Right : Unsigned_16;

  begin
    Hw.PWM.Get_Engine_Commands (Cmd_Left, Cmd_Right);
    Left := Integer_16 (Cmd_Left);
    Right := Integer_16 (Cmd_Right);
    Engine_Loop (Left'Access, Right'Access, 1.0 / C_float (Counter_Freq));
    Motor_Delta_Left := Integer_To_Unsigned (Left) - Old_Motor_Left;
    Motor_Delta_Right := Integer_To_Unsigned (Right) - Old_Motor_Right;

    Old_Motor_Left := Old_Motor_Left + Motor_Delta_Left;
    Old_Motor_Right := Old_Motor_Right + Motor_Delta_Right;

    Limit_To_Table (Blocked_Left, Blocked_Right);
    Simu_Left := Simu_Left + Blocked_Left;
    Simu_Right := Simu_Right + Blocked_Right;

    Raw_Left := Simu_Left;
    Raw_Right := Simu_Right;
  end Get_Next_Counters;

begin
  Init_Robot;
--  Trace_On (Unhandled_Raise);
end Hw.Counter_Simu;
