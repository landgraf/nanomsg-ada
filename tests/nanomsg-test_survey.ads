with Aunit; use Aunit;
with Aunit.Simple_Test_Cases;
with Nanomsg.Socket;
package Nanomsg.Test_Survey is 
   
   type Clients_T is array (1 .. 10) of Nanomsg.Socket.Socket_T;
   type TC is new Simple_Test_Cases.Test_Case with record
      Server  : Nanomsg.Socket.Socket_T;
      Clients : Clients_T;
   end record;
   
   overriding 
   procedure Tear_Down (T : in out Tc);
   
   overriding
   procedure Run_Test (T : in out TC); 
   
   overriding
   function Name (T : TC) return Message_String;
   
end Nanomsg.Test_Survey;
