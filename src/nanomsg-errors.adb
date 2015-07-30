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


with Interfaces.C.Strings;
package body Nanomsg.Errors is
package C renames Interfaces.C;

   function Errno return Integer
   is
      function C_Errno return C.Int with Import, Convention => C, External_Name => "nn_errno";
   begin
      return Integer (C_Errno);
   end Errno;
   
   function Errno_Text return String is 
      function Strerror (Err : in C.Int) return C.Strings.Chars_Ptr
      with Import, Convention => C, External_Name => "nn_strerror";
      Err : constant Integer  := Errno;
   begin
      return "Errno = " & Integer'Image (Err) & " : " & C.Strings.Value (Strerror (C.Int (Err)));
   end Errno_Text;
   
   function Errno_Id return String is 
   begin
      raise Not_Implemented_Exception;
      return "";
   end Errno_Id;
   
end Nanomsg.Errors;
