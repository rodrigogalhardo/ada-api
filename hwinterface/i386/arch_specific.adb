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

with Ada.Command_Line; use Ada.Command_Line;
with Ada.Exceptions; use Ada.Exceptions;
with Ada.Text_IO; use Ada.Text_IO;
with Hw.Button;
pragma Elaborate_All (Hw.Button);
with Common.Types; use Common.Types;
with Communication;
pragma Elaborate_All (Communication);
with Current_Bot;
with Match_Runner; use Match_Runner;
pragma Elaborate_All (Match_Runner);
with Readline; with Readline.Completion;
pragma Elaborate_All (Readline);
pragma Elaborate_All (Readline.Completion);

with Dump_Core;
pragma Elaborate_All (Dump_Core);
pragma Warnings (Off, Dump_Core);

package body Arch_Specific is
  Start_Value : Boolean := False;
  Red_Value : Boolean := False;
  Color_Value : Boolean := True;

  type Commands is (Start, Red, Color);

  task Keyboard_Reader;

  function Get_State return String is
    Bool : constant array (Boolean) of String (1 .. 1) := ("0", "1");
  begin
    return Current_Bot'Img & ": Start: " & Bool (Start_Value) &
           "; Red: " & Bool (Red_Value) &
           "; Color: " & Match_Runner.My_Color'Img &
           "; Stage: " & Match_Runner.Current_Stage'Img;
  end Get_State;

  task body Keyboard_Reader is
    Read_Keyboard : Boolean := True;
  begin
    Hw.Button.Set_Start_Button_Override (Start_Value);
    Hw.Button.Set_Red_Button_Override (Red_Value);
    Hw.Button.Set_Color_Button_Override (Color_Value);
    for I in 1 .. Argument_Count loop
      if Argument (I) = "--background" then
        Put_Line ("Not reading keyboard");
        Read_Keyboard := False;
      end if;
    end loop;

    for I in Commands loop
      Readline.Completion.Add_Word (I'Img);
    end loop;
    if Read_Keyboard then
      loop
        declare
          Cmd : constant String := Readline.Read_Line (Get_State & "> ");
        begin
          if Cmd /= "" then
            case Commands'Value (Cmd) is
              when Start =>
                Start_Value := not Start_Value;
                Hw.Button.Set_Start_Button_Override (Start_Value);
              when Red =>
                Red_Value := not Red_Value;
                Hw.Button.Set_Red_Button_Override (Red_Value);
              when Color =>
                Color_Value := not Color_Value;
                Hw.Button.Set_Color_Button_Override (Color_Value);
            end case;
          end if;
        exception
          when E : others =>
            Put_Line ("??? " & Exception_Information (E));
        end;
      end loop;
    end if;
  end Keyboard_Reader;

  ---------
  -- Log --
  ---------

  procedure Log (Bot : Bot_Type; Msg : String) is
  begin
    Put_Line (Bot'Img & ": " & Msg);
  end Log;

begin
  Communication.Set_Extra_Logging_Callback (Log'Access);
end Arch_Specific;
