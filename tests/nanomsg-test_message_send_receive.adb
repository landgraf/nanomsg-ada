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


with Nanomsg.Domains;
with Aunit.Assertions;
with Nanomsg.Messages;
with Nanomsg.Pipeline;
package body Nanomsg.Test_Message_Send_Receive is
      
   procedure Run_Test (T : in out TC) is
      use Aunit.Assertions;
      Address : constant String := "tcp://127.0.0.1:5555";
      Msg1 : Nanomsg.Messages.Message_T;
      Msg2 : Nanomsg.Messages.Message_T := Nanomsg.Messages.Empty_Message;
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
      
      Assert (not T.Socket2.Is_Ready (To_Send    => False,
                                      To_Receive => True), 
              "Socket has message before other side send one");
      Assert ( T.Socket1.Is_Ready (To_Send       => True,
                                   To_Receive    => False), 
              "Socket has message before other side send one");
      T.Socket1.Send (Msg1); 
      if  T.Socket2.Is_Ready (To_Send => False,
                              To_Receive => True)  then
         T.Socket2.Receive (Msg2);
      else
         Assert (False, "Socket 2 doesn't have messages");
      end if;
      Assert (Condition => Msg1.Text = Msg2.Text,
              Message => "Message transfer failed. Texts are not identical" & Ascii.Lf & 
                "Sent: " & Msg1.Text & "; Received: " & Msg2.Text);
   end Run_Test;
   
   function Name (T : TC) return Message_String is
   begin
      return Aunit.Format ("Test case name : Message send/receive test");
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
   
end Nanomsg.Test_Message_Send_Receive;
