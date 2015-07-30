with Nanomsg.Domains;
with Nanomsg.Pipeline;
with Aunit.Assertions;
with Nanomsg.Messages;
package body Nanomsg.Test_Send_Binary_File is
      
   procedure Run_Test (T : in out TC) is
      use Aunit.Assertions;
      Address : constant String := "tcp://127.0.0.1:5555";
      Msg1 : Nanomsg.Messages.Message_T;--  := Nanomsg.Messages.From_File ("tests/data/test_send_binary_file.jpg");
      Msg2 : Nanomsg.Messages.Message_T := Nanomsg.Messages.Empty_Message;
   begin
      Assert (False, "Not Implemented yer");
      Nanomsg.Socket.Init (T.Socket1, Nanomsg.Domains.Af_Sp, Nanomsg.Pipeline.Nn_Push);
      Nanomsg.Socket.Init (T.Socket2, Nanomsg.Domains.Af_Sp, Nanomsg.Pipeline.Nn_Pull);
      Assert (Condition => not T.Socket1.Is_Null, Message => "Failed to initialize socket1");
      Assert (Condition => not T.Socket2.Is_Null, Message => "Failed to initialize socket2");
      Assert (Condition => T.Socket1.Get_Fd /= T.Socket2.Get_Fd, 
              Message => "Descriptors collision!");
      Nanomsg.Socket.Connect (T.Socket1, Address);
      Nanomsg.Socket.Bind (T.Socket2, "tcp://*:5555");

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
   
end Nanomsg.Test_Send_Binary_File;
