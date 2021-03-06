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


with Ada.Unchecked_Deallocation;
with Interfaces.C.Strings;
package body Nanomsg.Messages is
   use Ada.Streams;
   package C renames Interfaces.C;
   function Is_Empty (Obj : in Message_T) return Boolean is (Obj.Length = 0 or Obj.Payload = null);
   
   
   procedure From_String (Message :    out Message_T;
                          Text    : in     String) is
      Payload                     : Stream_Element_Array (Stream_Element_Offset (Text'First) .. Stream_Element_Offset (Text'Last));
      for Payload'Address use Text'Address;
   begin
      Message.Payload := new Stream_Element_Array'(Payload);
      Message.Length  := Text'Length; 
   end From_String;
   
   function Text (Obj : in Message_T) return String is
   begin
      if Obj.Is_Empty then
         return "";
      end if;
      declare
         Tmp : Stream_Element_Array := Obj.Payload.all;
         Retval : String (1 .. Obj.Length);
         for Retval'Address use Tmp'Address;
      begin
         return Retval;
      end;
   end Text;
   
   procedure Init (Obj     :    out Message_T;
                   Payload : in     Bytes_Array_Access_T;
                   Length  : in     Integer) is
   begin
      Obj.Payload := Payload;
      Obj.Length := Length;
   end Init;
   
   procedure Free (Obj : in out Message_T) is 
      procedure Free_Payload is new Ada.Unchecked_Deallocation (Stream_Element_Array, Bytes_Array_Access_T);
   begin
      Free_Payload (Obj.Payload);
      Obj.Length := 0;
   end Free;
   
   function Get_Payload (Obj : in Message_T) return Bytes_Array_Access_T is (Obj.Payload);
   
   function Get_Length (Obj : in Message_T) return Natural is (Obj.Length);
   
   procedure Set_Length (Obj    : in out Message_T;
                         Length : in     Natural) is
   begin
      Obj.Length := Length;
   end Set_Length;
   
   procedure Set_Payload (Obj     : in out Message_T;
                          Payload : in     Stream_Element_Array) is
   begin
      Obj.Payload := new Stream_Element_Array'(Payload);
   end Set_Payload;
   
   procedure Set_Payload (Obj     : in out Message_T;
                          Payload :    Bytes_Array_Access_T) is
   begin
      Obj.Payload := Payload;
   end Set_Payload;
      
   procedure Finalize (Obj : in out Message_T) is 
   begin
      Free (Obj);
   end Finalize;
   
end Nanomsg.Messages;
