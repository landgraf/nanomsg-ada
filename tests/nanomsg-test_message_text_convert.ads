with Aunit; use Aunit;
with Aunit.Simple_Test_Cases;
with Nanomsg.Messages;
package Nanomsg.Test_Message_Text_Convert is 
   
   type TC is new Simple_Test_Cases.Test_Case with record
      Message : Nanomsg.Messages.Message_T;
   end record;
   
   overriding
   procedure Run_Test (T : in out TC); 
   
   overriding
   function Name (T : TC) return Message_String;
private
   Text : constant String := "Hello world!";

end Nanomsg.Test_Message_Text_Convert;
