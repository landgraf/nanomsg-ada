with Nanomsg.Socket;
with Ada.Containers.Ordered_Maps;
package Nanomsg.Socket_Pools is
   type Pool_T is tagged private;
   procedure Add_Socket (Self   : in out Pool_T;
                         Socket : in     Nanomsg.Socket.Socket_T);
   
   procedure Remove_Socket (Self   : in out Pool_T;
                            Socket : in     Nanomsg.Socket.Socket_T);
   function Has_Socket (Self   : in Pool_T;
                        Socket : in Nanomsg.Socket.Socket_T) return Boolean;
   
   function Has_Message (Self : in Pool_T) return Pool_T;
   function Ready_To_Receive (Self : in Pool_T) return Pool_T renames Has_Message;
   
   function Ready_To_Send (Self : in Pool_T) return Pool_T;
   function Ready_To_Send_Receive (Self : in Pool_T) return Pool_T;
   
private
   
   package Pool_Container_P is new Ada.Containers.Ordered_Maps (Element_Type => Nanomsg.Socket.Socket_T,
                                                                "=" => Nanomsg.Socket."=", 
                                                                Key_Type => Natural);
   subtype Pool_Container_T is Pool_Container_P.Map;
   
   type Pool_T is tagged record
      Pool : Pool_Container_T;
   end record;

end Nanomsg.Socket_Pools;
