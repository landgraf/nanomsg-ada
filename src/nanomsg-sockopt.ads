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
