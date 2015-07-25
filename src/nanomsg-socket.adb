with Interfaces.C;
package body  Nanomsg.Socket is
   package C renames Interfaces.C;
   
   function Is_Null (Obj : in Socket_T) return Boolean is (Obj.Fd = 0);
   
   procedure Init (Obj      :    out Socket_T;
                   Domain   : in     Nanomsg.Domains.Domain_T;
                   Protocol : in     Nanomsg.Protocols.Protocol_T
                  ) is
      
      function C_Nn_Socket (Domain : in C.Int; Protocol : in C.Int) return C.Int
      with Import, Convention => C, External_Name => "nn_socket";
      
   begin
      Obj.Fd := Integer (C_Nn_Socket (Domain.To_C, Protocol.To_C));
   end Init;
   
   procedure Close (Obj : in out Socket_T) is 
   begin
      null;
   end Close;


end Nanomsg.Socket;
