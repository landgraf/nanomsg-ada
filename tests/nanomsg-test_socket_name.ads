with Aunit; use Aunit;
with Nanomsg.Socket;
with Aunit.Simple_Test_Cases;

package Nanomsg.Test_Socket_Name is 
   type TC is new Simple_Test_Cases.Test_Case with record
       Socket : Nanomsg.Socket.Socket_T;
   end record;
   
   overriding
   procedure Run_Test (T : in out TC); 
   
   overriding
   procedure Tear_Down (T : in out Tc);
   
   overriding
   function Name (T : TC) return Message_String;
private
   Socket_Name : constant String := "Test";
end Nanomsg.Test_Socket_Name;
 
