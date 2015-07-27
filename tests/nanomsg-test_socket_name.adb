with Nanomsg.Domains;
with Nanomsg.Protocols;
with Aunit.Assertions;
with Nanomsg.Sockopt;
package body Nanomsg.Test_Socket_Name is 
      
   procedure Run_Test (T : in out TC) is
      -- Download attachments based on number selection
      -- Download attachments based on timestamp selection
      use Aunit.Assertions;
      use Nanomsg.Sockopt;
      
      Option : Socket_Option_T (Nn_Socket_Name);

   begin
      Option.Set_Value (Socket_Name);
      Nanomsg.Socket.Init (T.Socket, Nanomsg.Domains.Af_Sp, Nanomsg.Protocols.Nn_Pair);
      Nanomsg.Socket.Set_Option (T.Socket, Option);
      Assert (Condition => not T.Socket.Is_Null, Message => "Failed to initialize socket");
      
   end Run_Test;
   
   function Name (T : TC) return Message_String is
   begin
      return Aunit.Format ("Test case name : Test socket option");
   end Name;
   
   procedure Tear_Down (T : in out Tc) is 
   begin
      Nanomsg.Socket.Close (T.Socket);
   end Tear_Down;

end Nanomsg.Test_Socket_Name;

