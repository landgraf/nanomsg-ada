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
      Option_Send	: Socket_Option_T (Nn_Socket_Name);
      Option_Recv	: Socket_Option_T (Nn_Socket_Name);
   begin
      Option_Send.Set_Value (Socket_Name);
      Nanomsg.Socket.Init (T.Socket, Nanomsg.Domains.Af_Sp, Nanomsg.Protocols.Nn_Pair);
      Assert (Condition => not T.Socket.Is_Null, 
	      Message	=> "Failed to initialize socket");
      Nanomsg.Socket.Set_Option (T.Socket, 
				 Option_Send);
      Option_Recv	:=  Nanomsg.Socket.Get_Option (T.Socket, 
						       Nn_Socket_Name);
      Assert (Condition => Option_Send.Get_Str_Value = Option_Recv.Get_Str_Value, 
	      Message	=> "Options value are not identical" & Ascii.Lf & 
		"Set value: " & Option_Send.Get_Str_Value & Ascii.Lf &
		"Get value: " & Option_Recv.Get_Str_Value);
      
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

