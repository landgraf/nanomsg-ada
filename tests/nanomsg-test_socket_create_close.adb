with Nanomsg.Domains;
with Nanomsg.Protocols;
with Aunit.Assertions;
package body Nanomsg.Test_Socket_Create_Close is
   
   procedure Run_Test (T : in out TC) is
      -- Download attachments based on number selection
      -- Download attachments based on timestamp selection
      use Aunit.Assertions;
   begin
      Nanomsg.Socket.Init (T.Socket, Nanomsg.Domains.Af_Sp, Nanomsg.Protocols.Nn_Pair);
      Assert (Condition => not T.Socket.Is_Null, Message => "Failed to initialize socket");
      Nanomsg.Socket.Close (T.Socket);
      Assert (Condition => T.Socket.Is_Null, Message => "Failed to close socket");
   end Run_Test;
   
   function Name (T : TC) return Message_String is
   begin
      return Aunit.Format ("Test case name : Basic socket tests");
   end Name;
      
   
end Nanomsg.Test_Socket_Create_Close;
