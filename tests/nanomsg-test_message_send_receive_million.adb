--  The MIT License (MIT)

--  Copyright (c) 2015 Pavel Zhukov <landgraf@fedoraproject.org>

--  Permission is hereby granted, free of charge, to any person obtaining a copy
--  of this software and associated documentation files (the "Software"), to deal
--  in the Software without restriction, including without limitation the rights
--  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
--  copies of the Software, and to permit persons to whom the Software is
--  furnished to do so, subject to the following conditions:

--  The above copyright notice and this permission notice shall be included in all
--  copies or substantial portions of the Software.

--  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
--  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
--  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
--  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
--  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
--  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
--  SOFTWARE.


with Ada.Calendar;
with Ada.Text_Io;
with Nanomsg.Domains;
with Nanomsg.Pipeline;
with Aunit.Assertions;
with Nanomsg.Messages;
package body Nanomsg.Test_Message_Send_Receive_Million is 
      
   procedure Run_Test (T : in out TC) is
      use Aunit.Assertions;
      Address : constant String := "tcp://127.0.0.1:5555";
      Msg1 : Nanomsg.Messages.Message_T;
      Msg2 : Nanomsg.Messages.Message_T := Nanomsg.Messages.Empty_Message;
      Begun : Ada.Calendar.Time;
      use type Ada.Calendar.Time;
      Dur : Duration;
      
      task Sender is
         entry Start;
      end Sender;
      
      task body Sender is
      begin
         accept Start;
         for X in 1 .. 1_000_000 loop
            T.Socket1.Send (Msg1);
         end loop;
      end Sender;
   begin
      Nanomsg.Messages.From_String (Msg1, "Hello world");
      Nanomsg.Socket.Init (T.Socket1, Nanomsg.Domains.Af_Sp, Nanomsg.Pipeline.Nn_Push);
      Nanomsg.Socket.Init (T.Socket2, Nanomsg.Domains.Af_Sp, Nanomsg.Pipeline.Nn_Pull);
      Assert (Condition => not T.Socket1.Is_Null, Message => "Failed to initialize socket1");
      Assert (Condition => not T.Socket2.Is_Null, Message => "Failed to initialize socket2");
      Assert (Condition => T.Socket1.Get_Fd /= T.Socket2.Get_Fd, 
              Message => "Descriptors collision!");
      Nanomsg.Socket.Connect (T.Socket1, Address);
      Nanomsg.Socket.Bind (T.Socket2, "tcp://*:5555");
      Begun := Ada.Calendar.Clock;
      Sender.Start;
      for X in 1 .. 1_000_000 loop
           T.Socket2.Receive (Msg2);
      end loop;
      Dur := Ada.Calendar.Clock - Begun;
      Ada.Text_Io.Put_Line ("Sending of million messages in pipeline mode took: " & Duration'Image (Dur) & " seconds");
      Assert (Condition => Msg1.Text = Msg2.Text,
              Message => "Message transfer failed. Texts are not identical" & Ascii.Lf & 
                "Sent: " & Msg1.Text & "; Received: " & Msg2.Text);
   end Run_Test;
   
   function Name (T : TC) return Message_String is
   begin
      return Aunit.Format ("Test case name : Message send/receive million messages");
   end Name;
   
   procedure Tear_Down (T : in out Tc) is
   begin
      if T.Socket1.Get_Fd >= 0 then
         T.Socket1.Close;
      end if;
      if T.Socket2.Get_Fd >= 0 then
         T.Socket2.Close;
      end if;
   end Tear_Down;
   
end Nanomsg.Test_Message_Send_Receive_Million;
