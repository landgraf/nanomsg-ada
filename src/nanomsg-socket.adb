with Interfaces.C.Strings;
with Nanomsg.Errors;

package body  Nanomsg.Socket is
   package C renames Interfaces.C;
   use type C.Int;
   
   function Is_Null (Obj : in Socket_T) return Boolean is (Obj.Fd = -1);
   
   procedure Init (Obj      :    out Socket_T;
                   Domain   : in     Nanomsg.Domains.Domain_T;
                   Protocol : in     Nanomsg.Protocols.Protocol_T
                  ) is
      
      function C_Nn_Socket (Domain : in C.Int; Protocol : in C.Int) return C.Int
      with Import, Convention => C, External_Name => "nn_socket";
      
   begin
      Obj.Fd := Integer (C_Nn_Socket (Nanomsg.Domains.To_C (Domain), 
                                      Nanomsg.Protocols.To_C (Protocol)));
   end Init;
   
   procedure Close (Obj : in out Socket_T) is 
      function C_Nn_Close (Socket : in C.Int) return C.Int
      with Import, Convention => C, External_Name => "nn_close";
      
   begin
      if C_Nn_Close (C.Int (Obj.Fd)) /= 0 then
         raise Socket_Exception with "Close: " & Nanomsg.Errors.Errno_Text;
      end if;
      Obj.Fd := -1;
   end Close;

   procedure Bind (Obj     : in Socket_T;
                   Address : in String) is
   
      function C_Bind (Socket : in C.Int; Address : in C.Strings.Chars_Ptr) return C.Int
      with Import, Convention => C, External_Name => "nn_bind";
      Endpoint : C.Int := -1;
   begin
      Endpoint := C_Bind(C.Int (Obj.Fd), C.Strings.New_String (Address));
      if Endpoint < -1 then
         raise Socket_Exception with "Bind: "  & Nanomsg.Errors.Errno_Text;
      end if;
      -- FIXME 
      -- Add endpoints container
   end Bind;
   
   procedure Connect (Obj     : in Socket_T;
                   Address : in String) is
   
      function C_Connect (Socket : in C.Int; Address : in C.Strings.Chars_Ptr) return C.Int
      with Import, Convention => C, External_Name => "nn_connect";
      Endpoint : C.Int := -1;
   begin
      Endpoint := C_Connect(C.Int (Obj.Fd), C.Strings.New_String (Address)) ;
      if Endpoint < 0 then
         raise Socket_Exception with "Connect: " & Nanomsg.Errors.Errno_Text;
      end if;
   end Connect;

   function Fd (Obj : in Socket_T) return Integer is (Obj.Fd);   
   
end Nanomsg.Socket;
