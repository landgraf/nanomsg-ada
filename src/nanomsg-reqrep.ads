package Nanomsg.Reqrep is 
   Nn_Proto_Reqrep : constant := 3;
   Nn_Req : constant Protocol_T := Nn_Proto_Reqrep * 16 + 0;
   Nn_Rep : constant Protocol_T := Nn_Proto_Reqrep * 16 + 1;
end Nanomsg.Reqrep;
