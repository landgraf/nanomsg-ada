with Nanomsg.Domains;
with Nanomsg.Protocols;
with Aunit.Assertions;
with Nanomsg.Messages;
package body Nanomsg.Test_Message_Long_Text is 
   
   procedure Run_Test (T : in out TC) is
      use Aunit.Assertions;
      Address : constant String := "tcp://127.0.0.1:5555";
      Text : constant String (1 .. 2 ** 16 ) := ( others => 'K');
      Msg1 : Nanomsg.Messages.Message_T;
      Msg2 : Nanomsg.Messages.Message_T := Nanomsg.Messages.Empty_Message;
      begin
         Msg1 :=  Nanomsg.Messages.From_String (Text);
         
         Nanomsg.Socket.Init (T.Socket1, Nanomsg.Domains.Af_Sp, Nanomsg.Protocols.Nn_Push);
         Nanomsg.Socket.Init (T.Socket2, Nanomsg.Domains.Af_Sp, Nanomsg.Protocols.Nn_Pull);
         Assert (Condition => not T.Socket1.Is_Null, Message => "Failed to initialize socket1");
         Assert (Condition => not T.Socket2.Is_Null, Message => "Failed to initialize socket2");
         Assert (Condition => T.Socket1.Get_Fd /= T.Socket2.Get_Fd, 
                 Message => "Descriptors collision!");
         Nanomsg.Socket.Connect (T.Socket1, Address);
         Nanomsg.Socket.Bind (T.Socket2, "tcp://*:5555");
         T.Socket1.Send (Msg1); 
         T.Socket2.Receive (Msg2);
         Assert (Condition => Msg1.Text = Msg2.Text,
                 Message => "Message transfer failed. Texts are not identical" & Ascii.Lf & 
                   "Sent: " & Msg1.Text & "; Received: " & Msg2.Text);
         
   end Run_Test;
   
   function Name (T : TC) return Message_String is
   begin
      return Aunit.Format ("Test case name : Long message send/receive");
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
   
end Nanomsg.Test_Message_Long_Text;