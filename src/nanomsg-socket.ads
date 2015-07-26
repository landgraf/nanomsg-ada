with Nanomsg.Domains;
with Nanomsg.Protocols;
with Nanomsg.Messages;

package Nanomsg.Socket is 
   Socket_Exception : exception;
   
   type Socket_T is tagged private;
   type Socket_Access_T is access all Socket_T;
   
   function Is_Null (Obj : in Socket_T) return Boolean;
   
   procedure Init (Obj      :    out Socket_T;
                   Domain   : in     Nanomsg.Domains.Domain_T;
                   Protocol :        Nanomsg.Protocols.Protocol_T
                  )
   with Post => not Obj.Is_Null;
   
   procedure Close (Obj : in out Socket_T)
   with Post => Obj.Is_Null;
   
   procedure Bind (Obj     : in  Socket_T;
                   Address : in String)
   with Pre => not Obj.Is_Null;
   
   procedure Connect (Obj : in Socket_T;
                      Address : in String)
   with Pre => not Obj.Is_Null;
   
   function Get_Fd (Obj : in Socket_T) return Integer;
   
   procedure Send (Obj     : in Socket_T;
                   Message :    Nanomsg.Messages.Message_T);
   
   procedure Receive (Obj     : in out Socket_T;
                      Message :    out Nanomsg.Messages.Message_T);
                
   
private
   type Socket_T is tagged record
      Fd : Integer := -1; -- File Descriptor
      Domain : Nanomsg.Domains.Domain_T;
      Protocol : Nanomsg.Protocols.Protocol_T;
   end record;
end Nanomsg.Socket;
