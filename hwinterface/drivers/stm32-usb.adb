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

with Stm32.NVIC; use Stm32.NVIC;

package body Stm32.USB is

  -- The size of the USB queue.
  Queue_Size : constant Integer := 100;
  Queue : String (1 .. Queue_Size);
  Read_Pos : Integer := 1;
  Write_Pos : Integer := 1;

  -- This is the list of characters received.
  -- There is no check for buffer overflow, someone has to read or
  -- data will be lost.
  protected Usb_Queue is
    entry Read (C : out Character);
    procedure Interrupt_Handler;
    pragma Attach_Handler (Interrupt_Handler, OTG_FS_IRQn);
  private
    Non_Empty : Boolean := False;
  end Usb_Queue;

  -- A protected to be sure that 'Send' is thread safe.
  protected Usb_Sender is
    procedure Send (S : String);
  end Usb_Sender;

  --------------
  -- Init_Usb --
  --------------

  procedure Init_Usb;
  pragma Import (C, Init_Usb, "UsbInit");

  -----------------
  -- Usb_Data_Rx --
  -----------------

  procedure Usb_Data_Rx (C : Character);
  pragma Export (C, Usb_Data_Rx, "USB_DataRx");
  procedure Usb_Data_Rx (C : Character) is
    -- When there is a character to read, the C calls this function.
    -- When called, we have the lock of Usb_Queue.
  begin
    Queue (Write_Pos) := C;
    Write_Pos := Write_Pos + 1;
    if Write_Pos = Queue_Size then
      Write_Pos := 1;
    end if;
  end Usb_Data_Rx;

  ---------------
  -- Usb_Queue --
  ---------------

  protected body Usb_Queue is

    --------------------
    -- Usb_Queue.Read --
    --------------------

    entry Read (C : out Character) when Non_Empty is
    begin
      C := Queue (Read_Pos);
      Read_Pos := Read_Pos + 1;
      if Read_Pos = Queue_Size then
        Read_Pos := 1;
      end if;
      Non_Empty := Read_Pos /= Write_Pos;
    end Read;

    -----------------------
    -- Interrupt_Handler --
    -----------------------

    procedure Interrupt_Handler is
      -- Here, we call the C function to handle the interrupt.
      -- If there is something to read, the C code will call
      -- back 'USB_DataRx' that is exported above.
      procedure HandleInterrupt;
      pragma Import (C, HandleInterrupt, "HandleUsbInterrupt");
    begin
      HandleInterrupt;
      Non_Empty := Read_Pos /= Write_Pos;
    end Interrupt_Handler;

  end Usb_Queue;

  ----------------
  -- Usb_Sender --
  ----------------

  protected body Usb_Sender is

    ---------------------
    -- Usb_Sender.Send --
    ---------------------

    procedure Send (S : String) is
      -- Just pass the character to send to the C function.
      procedure Usb_Send (C : Character);
      pragma Import (C, Usb_Send, "UsbSend");
    begin
      for I in S'Range loop
        Usb_Send (S (I));
      end loop;
    end Send;
  end Usb_Sender;

  ----------
  -- Read --
  ----------

  function Read return Character is
    C : Character;
  begin
    Usb_Queue.Read (C);
    return C;
  end Read;

  ----------
  -- Send --
  ----------

  procedure Send (S : String) is
  begin
    Usb_Sender.Send (S);
  end Send;

begin
   Init_Usb;
end Stm32.USB;
