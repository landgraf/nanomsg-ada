with Ada.Calendar;
with Ada.Text_Io;
with Nanomsg.Domains;
with Nanomsg.Protocols;
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

   begin
      Nanomsg.Messages.From_String (Msg1, "Hello world");
      Nanomsg.Socket.Init (T.Socket1, Nanomsg.Domains.Af_Sp, Nanomsg.Protocols.Nn_Push);
      Nanomsg.Socket.Init (T.Socket2, Nanomsg.Domains.Af_Sp, Nanomsg.Protocols.Nn_Pull);
      Assert (Condition => not T.Socket1.Is_Null, Message => "Failed to initialize socket1");
      Assert (Condition => not T.Socket2.Is_Null, Message => "Failed to initialize socket2");
      Assert (Condition => T.Socket1.Get_Fd /= T.Socket2.Get_Fd, 
              Message => "Descriptors collision!");
      Nanomsg.Socket.Connect (T.Socket1, Address);
      Nanomsg.Socket.Bind (T.Socket2, "tcp://*:5555");
      Begun := Ada.Calendar.Clock;
      for X in 1 .. 1_000_000 loop
         T.Socket1.Send (Msg1); 
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
