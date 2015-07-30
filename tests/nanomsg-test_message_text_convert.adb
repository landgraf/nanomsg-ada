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
