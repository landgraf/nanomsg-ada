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
with Nanomsg.Pubsub;
with Aunit.Assertions;
with Nanomsg.Messages;

package body Nanomsg.Test_Pub_Sub is 
   procedure Run_Test (T : in out TC) is
      use Aunit.Assertions;
      Address            : constant String := "tcp://127.0.0.1:5555";
      Subscribe          : constant String := "HELPME" ;
      Publish           : constant String := "HELPME: Hello world";
      Not_Publish        : constant String := "XHELPME: You shouldn't see that";
      
      Publish_Message     : Nanomsg.Messages.Message_T;
      Not_Publish_Message : Nanomsg.Messages.Message_T;
      
      Finished : Boolean := False with Volatile;
      
      task Sender is
         entry Start;
      end Sender;
      
      task body Sender is
      begin
         accept Start;
         while not Finished loop
            Nanomsg.Socket.Send (T.Server, Publish_Message);
            Nanomsg.Socket.Send (T.Server, Not_Publish_Message);
            delay 0.1;
         end loop;
      end Sender;

   begin
      Nanomsg.Messages.From_String (Publish_Message, Publish);
      Nanomsg.Messages.From_String (Not_Publish_Message, Not_Publish);
      
      
      Nanomsg.Socket.Init (T.Server, Nanomsg.Domains.Af_Sp, Nanomsg.Pubsub.Nn_PUB);
      Nanomsg.Socket.Init (T.Client, Nanomsg.Domains.Af_Sp, Nanomsg.Pubsub.Nn_SUB);
      
      Assert (Condition => not T.Server.Is_Null, Message => "Failed to initialize socket1");
      Assert (Condition => not T.Client.Is_Null, Message => "Failed to initialize socket2");
      Assert (Condition => T.Server.Get_Fd /= T.Client.Get_Fd, 
              Message           => "Descriptors collision!");
      
      Nanomsg.Socket.Bind (T.Server, "tcp://*:5555");
      Sender.Start;
      
      Nanomsg.Pubsub.Subscribe (T.Client, Subscribe);
      Nanomsg.Socket.Connect (T.Client, Address);
      declare
         Msg : Nanomsg.Messages.Message_T;
      begin
         for X in 1 .. 100 loop
            select
               delay 2.0;
               Assert (False, "Aborted by timeout");
               Finished := True;
            then abort
               T.Client.Receive (Msg);
               declare
                  Text : constant String := Msg.Text;
               begin
                  Assert (Text (Text'First .. Subscribe'Length) = Subscribe, "Received not subscribed!");
               end;
            end select;
         end loop;
         Finished := True;
      end;
      
   end Run_Test;
   
   function Name (T : TC) return Message_String is
   begin
      return Aunit.Format ("Test case name : Publisher/Subsriber test");
   end Name;
   
   procedure Tear_Down (T : in out Tc) is
   begin
      if T.Server.Get_Fd >= 0 then
         T.Server.Close;
      end if;
      if T.Client.Get_Fd >= 0 then
         T.Client.Close;
      end if;
   end Tear_Down;

end Nanomsg.Test_Pub_Sub;
