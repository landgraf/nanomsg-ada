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

with Aunit; use Aunit;
with Aunit.Simple_Test_Cases;
with Nanomsg.Socket;
package Nanomsg.Test_Survey is 
   
   type Clients_T is array (1 .. 10) of Nanomsg.Socket.Socket_T;
   type TC is new Simple_Test_Cases.Test_Case with record
      Server  : Nanomsg.Socket.Socket_T;
      Clients : Clients_T;
   end record;
   
   overriding 
   procedure Tear_Down (T : in out Tc);
   
   overriding
   procedure Run_Test (T : in out TC); 
   
   overriding
   function Name (T : TC) return Message_String;
   
end Nanomsg.Test_Survey;
