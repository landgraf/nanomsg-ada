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


with Nanomsg.Domains;
with Nanomsg.Messages;
with Nanomsg.Sockopt;
package Nanomsg.Socket is 
   Socket_Exception : exception;
   
   type Socket_T is tagged private;
   type Socket_Access_T is access all Socket_T;
   
   function Is_Null (Obj : in Socket_T) return Boolean;
   
   procedure Init (Obj      :    out Socket_T;
                   Domain   : in     Nanomsg.Domains.Domain_T;
                   Protocol :        Protocol_T
                  )
   with Post => not Obj.Is_Null;
   
   procedure Close (Obj : in out Socket_T)
   with Post => Obj.Is_Null;
   
   procedure Bind (Obj     : in out Socket_T;
                   Address : in     String)
   with Pre => not Obj.Is_Null;
   
   procedure Connect (Obj     : in out Socket_T;
                      Address : in     String)
   with Pre => not Obj.Is_Null;
   
   function Get_Fd (Obj : in Socket_T) return Integer;
   
   procedure Send (Obj     : in Socket_T;
                   Message :    Nanomsg.Messages.Message_T);
   
   procedure Receive (Obj          : in out Socket_T;
                      Message      :    out Nanomsg.Messages.Message_T;
                      Non_Blocking : in     Boolean := False);
   
   function Receive (Obj          : in out Socket_T;
                     Message      :    out Nanomsg.Messages.Message_T;
                     Non_Blocking : in     Boolean := False) return Natural;

   procedure Delete_Endpoint (Obj : in out Socket_T);
   
   function Get_Option (Obj   : in Socket_T;
                        Level : in Nanomsg.Sockopt.Option_Level_T;
                        Name  : in Nanomsg.Sockopt.Option_Type_T) return String;
   
   function Get_Option (Obj   : in Socket_T;
                        Level : in Nanomsg.Sockopt.Option_Level_T;
                        Name  : in Nanomsg.Sockopt.Option_Type_T) return Natural;
   
   procedure Set_Option (Obj   : in out Socket_T;
                         Level : in     Nanomsg.Sockopt.Option_Level_T;
                         Name  : in     Nanomsg.Sockopt.Option_Type_T;
                         Value : in     Natural);
   
   procedure Set_Option (Obj   : in out Socket_T;
                         Level : in     Nanomsg.Sockopt.Option_Level_T;
                         Name  : in     Nanomsg.Sockopt.Option_Type_T;
                         Value : in     String);
   
   function Is_Ready (Obj        : in Socket_T;
                      To_Send    :    Boolean := False;
                      To_Receive :    Boolean := True) return Boolean;
   
   function "=" (Left, Right : in Socket_T) return Boolean;
private
   type Socket_T is tagged record
      Fd       : Integer := -1; -- File Descriptor
      Domain   : Nanomsg.Domains.Domain_T;
      Protocol : Protocol_T;
      Endpoint : Integer := -1;
   end record;
end Nanomsg.Socket;
