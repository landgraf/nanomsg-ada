with Interfaces.C;

package body Nanomsg.Pubsub is 
package C renames Interfaces.C;

   procedure Subscribe (Socket : in out Nanomsg.Socket.Socket_T;
                        Topic  : in     String) is
   begin
      Nanomsg.Socket.Set_Option (Socket,
                                 Level => Nanomsg.Sockopt.Option_Level_T (Nn_Sub),
                                 Name  => Nn_Sub_Subscribe,
                                 Value => Topic);
   end Subscribe;
   
   procedure Unsubscribe (Socket : in out Nanomsg.Socket.Socket_T;
                          Topuc  : in     String) is
   begin
      null;
   end Unsubscribe;
   
end Nanomsg.Pubsub;
