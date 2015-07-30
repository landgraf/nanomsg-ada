with Interfaces.C;
with Ada.Finalization;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
package Nanomsg.Sockopt is 
   package C renames Interfaces.C;
   
   type Option_Level_T is new C.Int;
   
   type Option_Type_T is new C.Int;

   NN_LINGER            : constant Option_Type_T :=  1;
   NN_SNDBUF            : constant Option_Type_T :=  2;
   NN_RCVBUF            : constant Option_Type_T :=  3;
   NN_SNDTIMEO          : constant Option_Type_T :=  4;
   NN_RCVTIMEO          : constant Option_Type_T :=  5;
   NN_RECONNECT_IVL     : constant Option_Type_T :=  6;
   NN_RECONNECT_IVL_MAX : constant Option_Type_T :=  7;
   NN_SNDPRIO           : constant Option_Type_T :=  8;
   NN_RCVPRIO           : constant Option_Type_T :=  9;
   NN_IPV4ONLY          : constant Option_Type_T :=  14;
   NN_SOCKET_NAME       : constant Option_Type_T :=  15;

end Nanomsg.Sockopt;
