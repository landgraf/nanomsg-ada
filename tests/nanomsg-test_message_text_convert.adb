with Aunit.Assertions;
package body Nanomsg.Test_Message_Text_Convert is
   
   function Name (T : TC) return Message_String is
   begin
      return Aunit.Format ("Test case name : Message from_string/to_string test");
   end Name;
   
   procedure Run_Test (T : in out TC) is
      use Aunit.Assertions;
   begin
      Nanomsg.Messages.From_String (T.Message, Text);
      Assert (Condition => T.Message.Text = Text,
              Message => "Message convert failed");
   end Run_Test;
      
end Nanomsg.Test_Message_Text_Convert;
