with Aunit; use Aunit;
with Aunit.Simple_Test_Cases;
with Nanomsg.Socket;
package Nanomsg.Test_Pair is 
   type TC is new Simple_Test_Cases.Test_Case with record
      Socket1 : Nanomsg.Socket.Socket_T;
      Socket2 : Nanomsg.Socket.Socket_T;
   end record;
   
   overriding 
   procedure Tear_Down (T : in out Tc);
   
   overriding
   procedure Run_Test (T : in out TC); 
   
   overriding
   function Name (T : TC) return Message_String;
end Nanomsg.Test_Pair;