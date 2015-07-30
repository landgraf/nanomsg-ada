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
