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
      with Import, Convention => C;
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
