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

package body Nanomsg.Pubsub is 
package C renames Interfaces.C;

   procedure Subscribe (Socket : in out Nanomsg.Socket.Socket_T;
                        Topic  : in     String) is
   begin
      Nanomsg.Socket.Set_Option (Socket,
                                 Level => Nanomsg.Sockopt.Option_Level_T (Nn_Sub),
                                 Name  => Nn_Sub_Subscribe,
                                 Value => Topic);
   end Subscribe;
   
   procedure Unsubscribe (Socket : in out Nanomsg.Socket.Socket_T;
                          Topuc  : in     String) is
   begin
      null;
   end Unsubscribe;
   
end Nanomsg.Pubsub;
