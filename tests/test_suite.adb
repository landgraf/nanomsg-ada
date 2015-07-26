with Aunit.Test_Suites; use Aunit.Test_Suites; 
with Nanomsg.Test_Socket_Create_Close;
with Nanomsg.Test_Socket_Bind_Connect;
with Nanomsg.Test_Message_Send_Receive;
function Test_Suite return Access_Test_Suite is
   TS_Ptr : constant Access_Test_Suite := new Aunit.Test_Suites.Test_Suite; 
begin
   Ts_Ptr.Add_Test (new Nanomsg.Test_Socket_Create_Close.Tc);
   Ts_Ptr.Add_Test (new Nanomsg.Test_Socket_Bind_Connect.Tc);
   Ts_Ptr.Add_Test (new Nanomsg.Test_Message_Send_Receive.Tc);
   return Ts_Ptr;
end Test_Suite;
