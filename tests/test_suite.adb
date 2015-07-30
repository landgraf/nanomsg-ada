--  The MIT License (MIT)

--  Copyright (c) 2015 Pavel Zhukov <landgraf@fedoraproject.org>

--  Permission is hereby granted, free of charge, to any person obtaining a copy
--  of this software and associated documentation files (the "Software"), to deal
--  in the Software without restriction, including without limitation the rights
--  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
--  copies of the Software, and to permit persons to whom the Software is
--  furnished to do so, subject to the following conditions:

--  The above copyright notice and this permission notice shall be included in all
--  copies or substantial portions of the Software.

--  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
--  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
--  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
--  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
--  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
--  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
--  SOFTWARE.

with Aunit.Test_Suites; use Aunit.Test_Suites; 
with Nanomsg.Test_Socket_Create_Close;
with Nanomsg.Test_Socket_Bind_Connect;
with Nanomsg.Test_Message_Send_Receive;
with Nanomsg.Test_Send_Binary_File;
with Nanomsg.Test_Message_Long_Text;
with Nanomsg.Test_Message_Text_Convert;
with Nanomsg.Test_Req_Rep;
with Nanomsg.Test_Pair;
with Nanomsg.Test_Pub_sub;
with Nanomsg.Test_Survey;
with Nanomsg.Test_Socket_Name;
with Nanomsg.Test_Message_Send_Receive_Million;
function Test_Suite return Access_Test_Suite is
   TS_Ptr : constant Access_Test_Suite := new Aunit.Test_Suites.Test_Suite; 
begin
   Ts_Ptr.Add_Test (new Nanomsg.Test_Socket_Create_Close.Tc);
   Ts_Ptr.Add_Test (new Nanomsg.Test_Socket_Name.Tc);
   Ts_Ptr.Add_Test (new Nanomsg.Test_Socket_Bind_Connect.Tc);
   Ts_Ptr.Add_Test (new Nanomsg.Test_Message_Text_Convert.Tc);
   Ts_Ptr.Add_Test (new Nanomsg.Test_Message_Long_Text.Tc);
   Ts_Ptr.Add_Test (new Nanomsg.Test_Message_Send_Receive.Tc);
   Ts_Ptr.Add_Test (new Nanomsg.Test_Req_Rep.Tc);
   Ts_Ptr.Add_Test (new Nanomsg.Test_Pair.Tc);
   Ts_Ptr.Add_Test (new Nanomsg.Test_Pub_Sub.Tc);
   Ts_Ptr.Add_Test (new Nanomsg.Test_Survey.Tc);
   Ts_Ptr.Add_Test (new Nanomsg.Test_Message_Send_Receive_Million.Tc);
   return Ts_Ptr;
end Test_Suite;
