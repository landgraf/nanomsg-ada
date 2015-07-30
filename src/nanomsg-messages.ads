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


with System;
with Ada.Finalization;
with Ada.Streams;
package Nanomsg.Messages is
   
   type Bytes_Array_Access_T is access all Ada.Streams.Stream_Element_Array with Convention => C, Size => System.Word_Size;   

   type Message_T is new Ada.Finalization.Controlled with private;
   
   Empty_Message : constant Message_T;
   
   procedure Init (Obj     :    out Message_T;
                   Payload : in     Bytes_Array_Access_T;
                   Length  : in     Integer);
   
   procedure Free (Obj : in out Message_T);
   function Is_Empty (Obj : in Message_T) return Boolean;
   
   procedure From_String (Message :    out Message_T;
                          Text    : in     String);
   
   function Text (Obj : in Message_T) return String;
   
   function Get_Payload (Obj : in Message_T) return Bytes_Array_Access_T;
   
   function Get_Length (Obj : in Message_T) return Natural;
   
   procedure Set_Length (Obj    : in out Message_T;
                         Length : in Natural);
   
   procedure Set_Payload (Obj     : in out Message_T;
                          Payload :    Bytes_Array_Access_T);
   
   procedure Set_Payload (Obj     : in out Message_T;
                          Payload : in     Ada.Streams.Stream_Element_Array);

private
   
   overriding
   procedure Finalize (Obj : in out Message_T);

   type Message_T is new Ada.Finalization.Controlled with  record
      Payload : Bytes_Array_Access_T := null;
      Length  : Natural;
   end record;
   
   Empty_Message : constant Message_T := (Ada.Finalization.Controlled with Payload => null, Length => 0);
   
end Nanomsg.Messages;
