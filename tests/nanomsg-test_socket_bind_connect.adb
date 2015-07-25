with Nanomsg.Domains;
with Nanomsg.Protocols;
with Aunit.Assertions;
package body Nanomsg.Test_Socket_Bind_Connect is
      
   procedure Run_Test (T : in out TC) is
      -- Download attachments based on number selection
      -- Download attachments based on timestamp selection
      use Aunit.Assertions;
      Address : constant String := "tcp://127.0.0.1:5555";
   begin
      Nanomsg.Socket.Init (T.Socket1, Nanomsg.Domains.Af_Sp, Nanomsg.Protocols.Nn_Pair);
      Nanomsg.Socket.Init (T.Socket2, Nanomsg.Domains.Af_Sp, Nanomsg.Protocols.Nn_Pair);
      Assert (Condition => not T.Socket1.Is_Null, Message => "Failed to initialize socket1");
      Assert (Condition => not T.Socket2.Is_Null, Message => "Failed to initialize socket2");
      Assert (Condition => T.Socket1.Fd /= T.Socket2.Fd, Message => "Descriptors collision!");
      Nanomsg.Socket.Bind (T.Socket1, "tcp://*:5555");
      Nanomsg.Socket.Connect (T.Socket2, Address);
   end Run_Test;
   
   function Name (T : TC) return Message_String is
   begin
      return Aunit.Format ("Test case name : Socket bind/connect tests");
   end Name;
   
   procedure Tear_Down (T : in out Tc) is
   begin
      T.Socket1.Close;
      T.Socket2.Close;
   end Tear_Down;
   
end Nanomsg.Test_Socket_Bind_Connect;
