with Nanomsg.Socket;
with Nanomsg.Sockopt;
package Nanomsg.Pubsub is 
   Nn_Pubsub_Proto : constant            := 2;
   Nn_Pub          : constant Protocol_T := Nn_Pubsub_Proto * 16 + 0;
   Nn_Sub          : constant Protocol_T := Nn_Pubsub_Proto * 16 + 1;
   
   Nn_Sub_Subscribe   : constant Nanomsg.Sockopt.Option_Type_T := 1;
   Nn_Sub_UnSubscribe : constant Nanomsg.Sockopt.Option_Type_T := 2;
   
   procedure Subscribe (Socket : in out Nanomsg.Socket.Socket_T;
                        Topic  : in String);
   
   procedure Unsubscribe (Socket : in out Nanomsg.Socket.Socket_T;
                          Topuc  : in String);
   
end Nanomsg.Pubsub;
