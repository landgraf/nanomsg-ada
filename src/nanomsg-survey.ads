package Nanomsg.Survey is 
   Nn_Proto_Survey : constant            := 6;
   Nn_Surveyor     : constant Protocol_T := Nn_Proto_Survey * 16 + 0;
   Nn_respondent   : constant Protocol_T := Nn_Proto_Survey * 16 + 1;
   Nn_Surveyor_Deadline : constant := 1;
end Nanomsg.Survey;
