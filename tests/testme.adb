with Aunit.Reporter.Text; 
with Aunit.Run; 
with test_suite; 
procedure Testme is
   procedure Runner is new Aunit.Run.Test_Runner (test_Suite); 

   Reporter : Aunit.Reporter.Text.Text_Reporter; 
begin
   Aunit.Reporter.Text.Set_Use_ANSI_Colors(Reporter, True);
   Runner(Reporter); 
end Testme;
