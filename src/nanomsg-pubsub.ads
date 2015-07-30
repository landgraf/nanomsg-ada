package Nanomsg.Pubsub is 
   Nn_Pubsub_Proto : constant            := 2;
   Nn_Pub          : constant Protocol_T := Nn_Pubsub_Proto * 16 + 0;
   Nn_Sub          : constant Protocol_T := Nn_Pubsub_Proto * 16 + 1;
   
end Nanomsg.Pubsub;
