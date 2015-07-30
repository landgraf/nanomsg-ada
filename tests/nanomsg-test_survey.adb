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
with Nanomsg.Survey;
with Aunit.Assertions;
with Nanomsg.Messages;
with Ada.Text_Io;

package body Nanomsg.Test_Survey is 
   procedure Run_Test (T : in out TC) is
      use Aunit.Assertions;
      Address            : constant String := "tcp://127.0.0.1:5555";
      Ping : constant String := "PING";
      Pong : constant String := "PONG";
      
      task Server is 
         entry Start;
      end Server;
      
      task body Server is 
      begin
         T.Server.Init (Nanomsg.Domains.Af_Sp, Nanomsg.Survey.Nn_Surveyor);
         T.Server.Bind ("tcp://*:5555");
         delay 1.0;
         accept Start;
         declare
            Msg : Nanomsg.Messages.Message_T;
         begin
            Msg.From_String (Ping);
            T.Server.Send (Msg);
         end;
         for X in T.Clients'Range loop
            declare
               Msg : Nanomsg.Messages.Message_T;
            begin
               select
                  delay 2.0;
                  Assert (False, "Abort in server");
         then abort
            T.Server.Receive (Msg);
               end select;
            end;
         end loop;
      end Server;
      
      
   begin
      for Client of T.Clients loop
         Client.Init (Nanomsg.Domains.Af_Sp, Nanomsg.Survey.Nn_Respondent);
         Client.Connect (Address);
      end loop;
      Server.Start;
      for Client of T.Clients loop
         declare
            Msg : Nanomsg.Messages.Message_T;
         begin
            select 
               delay 2.0;
               Assert (False, "Recv aborted");
            then abort
               Client.Receive (Msg);
            end select;
            Assert (Msg.Text = Ping, "Ping request doesn't match");
         end;
      end loop;
      for Client of T.Clients loop
         declare 
            Msg : Nanomsg.Messages.Message_T;
         begin
            Msg.From_String (Pong);
            Client.Send (Msg);
         end;
      end loop;
      
   end Run_Test;
   
   function Name (T : TC) return Message_String is
   begin
      return Aunit.Format ("Test case name : Survey test");
   end Name;
   
   procedure Tear_Down (T : in out Tc) is
   begin
      if T.Server.Get_Fd >= 0 then
         T.Server.Close;
      end if;
      for Client of T.Clients loop
         if Client.Get_Fd >= 0 then
            Client.Close;
         end if;
      end loop;
      
   end Tear_Down;

end Nanomsg.Test_Survey;
