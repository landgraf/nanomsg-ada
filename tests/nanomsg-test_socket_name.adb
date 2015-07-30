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
      Nanomsg.Socket.Init (T.Socket, Nanomsg.Domains.Af_Sp, Nanomsg.Pair.Nn_Pair);
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

