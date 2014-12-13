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

with Ada.Exceptions; use Ada.Exceptions;
with Ada.Text_IO; use Ada.Text_IO;
with GNAT.Sockets; use GNAT.Sockets;

package body Network_Serial is

  ------------
  -- Socket --
  ------------

  protected Socket is
    procedure Set_Socket (Sock : Socket_Type);
    procedure Get_Socket (Sock : out Socket_Type);
    procedure Send (Msg : String);
  private
    S : Socket_Type := No_Socket;
  end Socket;

  ------------
  -- Socket --
  ------------

  protected body Socket is

    -----------------------
    -- Socket.Set_Socket --
    -----------------------

    procedure Set_Socket (Sock : Socket_Type) is
    begin
      if Sock = No_Socket and S /= No_Socket then
        Net.Close_Connection;
      end if;
      S := Sock;
    end Set_Socket;

    ----------------------
    --Socket.Get_Socket --
    ----------------------

    procedure Get_Socket (Sock : out Socket_Type) is
    begin
      Sock := S;
    end Get_Socket;

    -----------------
    -- Socket.Send --
    -----------------

    procedure Send (Msg : String) is
    begin
      begin
        if S /= No_Socket then
          for I in Msg'Range loop
            Character'Write (Stream (S), Msg (I));
          end loop;
        end if;
      exception
        when others =>
          Put_Line (Net.Module_Name & ": Unable to write");
          Set_Socket (No_Socket);
      end;
    end Send;
  end Socket;

  ----------------------
  -- PUBLIC FUNCTIONS --
  ----------------------

  ----------
  -- Read --
  ----------

  function Read return Character is
    Sock : Socket_Type;
    C : Character;
  begin
    loop
      begin
        Socket.Get_Socket (Sock);
        if Sock = No_Socket then
          Sock := Net.Wait_Connection;
          Put_Line (Net.Module_Name & " Wait_Connection done");
          Socket.Set_Socket (Sock);
        end if;
        Character'Read (Stream (Sock), C);
        return C;
      exception
        when E : others =>
          Put_Line (Net.Module_Name & ": Error reading: " & Exception_Information (E));
          Socket.Set_Socket (No_Socket);
      end;
    end loop;
  end Read;

  ----------
  -- Send --
  ----------

  procedure Send (S : String) is
  begin
    Socket.Send (S);
  end Send;

begin
  Net.Init_Networking (Port);
end Network_Serial;
