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
with Nanomsg.Pair;
with Aunit.Assertions;
with Nanomsg.Messages;

package body Nanomsg.Test_Pair is
   procedure Run_Test (T : in out TC) is
      use Aunit.Assertions;
      Address : constant String := "tcp://127.0.0.1:5555";
      Request : constant String := "Calculate : 2 + 2";
      Reply : constant String := "Answer: 4";
         
      Req_Send : Nanomsg.Messages.Message_T;
      Req_Rcv : Nanomsg.Messages.Message_T := Nanomsg.Messages.Empty_Message;
      Rep_Send : Nanomsg.Messages.Message_T;
      Rep_Rcv : Nanomsg.Messages.Message_T := Nanomsg.Messages.Empty_Message;
   begin
      Nanomsg.Messages.From_String (Req_Send, Request);
      Nanomsg.Messages.From_String (Rep_Send, Reply);
      
      Nanomsg.Socket.Init (T.Socket1, Nanomsg.Domains.Af_Sp, Nanomsg.Pair.Nn_PAIR);
      Nanomsg.Socket.Init (T.Socket2, Nanomsg.Domains.Af_Sp, Nanomsg.Pair.Nn_PAIR);
      Assert (Condition => not T.Socket1.Is_Null, Message => "Failed to initialize socket1");
      Assert (Condition => not T.Socket2.Is_Null, Message => "Failed to initialize socket2");
      Assert (Condition => T.Socket1.Get_Fd /= T.Socket2.Get_Fd, 
              Message   => "Descriptors collision!");
      Nanomsg.Socket.Bind (T.Socket2, "tcp://*:5555");
      Nanomsg.Socket.Connect (T.Socket1, Address);
      
      Assert (Condition => T.Socket1.Is_Ready (To_Send => True, To_Receive => False),
              Message => "Socket 1 is not ready");
      Assert (Condition => T.Socket2.Is_Ready (To_Send => True, To_Receive => False),
              Message => "Socket 2 is not ready");
      
      -- Pair is bi-directional communication
      -- Sendting few messages 
      for I in 1 .. 10 loop
         T.Socket1.Send (Req_Send); 
         T.Socket2.Receive (Req_Rcv);
         Assert (Condition => Req_Rcv.Text = Request,
                 Message   => "Request damaged in tranmission");
      end loop;
      

      -- Sending messages in reverse direction
      for I in 1 .. 10 loop
         T.Socket2.Send (Rep_Send);
         T.Socket1.Receive (Rep_Rcv);
         Assert (Condition => Rep_Rcv.Text = Reply,
                 Message   => "Reply damaged in tranmission");
      end loop;
      
   end Run_Test;
   
   function Name (T : TC) return Message_String is
   begin
      return Aunit.Format ("Test case name : Pair pattern test");
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

end Nanomsg.Test_Pair;
