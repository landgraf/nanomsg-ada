package Nanomsg.Pipeline is
   Nn_Proto_Pipeline : constant            := 5;
   Nn_Push           : constant Protocol_T :=  Nn_Proto_Pipeline * 16 + 0;
   Nn_Pull           : constant Protocol_T :=  Nn_Proto_Pipeline * 16 + 1;
end Nanomsg.Pipeline;
