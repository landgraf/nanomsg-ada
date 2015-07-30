with Nanomsg.Domains;
with Nanomsg.Protocols;
with Aunit.Assertions;
with Nanomsg.Sockopt;
with Interfaces.C.Strings;
package body Nanomsg.Test_Socket_Name is 
      
   procedure Run_Test (T : in out TC) is
      -- Download attachments based on number selection
      -- Download attachments based on timestamp selection
      use Aunit.Assertions;
      use Nanomsg.Sockopt;
      use type Interfaces.C.Strings.Chars_Ptr;
      package C_Strings renames Interfaces.C.Strings;
   begin
      Nanomsg.Socket.Init (T.Socket, Nanomsg.Domains.Af_Sp, Nanomsg.Protocols.Nn_Pair);
      Assert (Condition => not T.Socket.Is_Null, 
	      Message	=> "Failed to initialize socket");
      Nanomsg.Socket.Set_Option (T.Socket, 
                                 0,
                                 Nn_Socket_Name,
                                 Socket_Name);
              
      
      declare
         Option_Recv	: String :=  Nanomsg.Socket.Get_Option (T.Socket,
                                                                0,
						                Nn_Socket_Name);
      begin
         Assert (Condition => Socket_Name = Option_Recv,
	         Message	=> "Options value are not identical" & Ascii.Lf & 
		   "Set value: " & Socket_Name &  Ascii.Lf &
		   "Get value: " & Option_Recv);
         
      end;
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

