with Nanomsg.Domains;
with Nanomsg.Protocols;
with Nanomsg.Messages;
with Nanomsg.Sockopt;
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
   
   procedure Bind (Obj     : in out Socket_T;
                   Address : in     String)
   with Pre => not Obj.Is_Null;
   
   procedure Connect (Obj     : in out Socket_T;
                      Address : in     String)
   with Pre => not Obj.Is_Null;
   
   function Get_Fd (Obj : in Socket_T) return Integer;
   
   procedure Send (Obj     : in Socket_T;
                   Message :    Nanomsg.Messages.Message_T);
   
   procedure Receive (Obj     : in out Socket_T;
                      Message :    out Nanomsg.Messages.Message_T);
   
   procedure Delete_Endpoint (Obj : in out Socket_T);
   
   function Get_Option (Obj   : in Socket_T;
                        Level : in Nanomsg.Sockopt.Option_Level_T;
                        Name  : in Nanomsg.Sockopt.Option_Type_T) return String;
   
   function Get_Option (Obj   : in Socket_T;
                        Level : in Nanomsg.Sockopt.Option_Level_T;
                        Name  : in Nanomsg.Sockopt.Option_Type_T) return Natural;
   
   procedure Set_Option (Obj   : in out Socket_T;
                         Level : in     Nanomsg.Sockopt.Option_Level_T;
                         Name  : in     Nanomsg.Sockopt.Option_Type_T;
                         Value : in     Natural);
   
   procedure Set_Option (Obj   : in out Socket_T;
                         Level : in     Nanomsg.Sockopt.Option_Level_T;
                         Name  : in     Nanomsg.Sockopt.Option_Type_T;
                         Value : in     String);
   
private
   type Socket_T is tagged record
      Fd : Integer := -1; -- File Descriptor
      Domain : Nanomsg.Domains.Domain_T;
      Protocol : Nanomsg.Protocols.Protocol_T;
      Endpoint : Integer := -1;
   end record;
end Nanomsg.Socket;
