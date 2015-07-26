with System;
package Nanomsg.Messages is
   
   type Byte_T is range 0 .. (2 ** 8) - 1 with Convention => C, Size => 8, Alignment => 1;
   type Bytes_Array_T is array (Natural range <>) of Byte_T
   with Convention => C, Alignment => 1 ;
   type Bytes_Array_Access_T is access all Bytes_Array_T with Convention => C, Size => System.Word_Size;   

   type Message_T is tagged private;
   
   Empty_Message : constant Message_T;
   
   procedure Init (Obj     :    out Message_T;
                   Payload : in     Bytes_Array_Access_T;
                   Length  : in     Integer);
   
   function Is_Empty (Obj : in Message_T) return Boolean;
   
   function From_String (Text : in String) return Message_T;
   
   function Text (Obj : in Message_T) return String;
   function Payload (Obj : in Message_T) return Bytes_Array_Access_T;
   function Length (Obj : in Message_T) return Natural;
   procedure Set_Length (Obj    : in out Message_T;
                         Length : in Natural);
   procedure Set_Payload (Obj     : in out Message_T;
                          Payload :    Bytes_Array_Access_T);
      
private


   type Message_T is tagged record
      Payload : Bytes_Array_Access_T := null;
      Length  : Natural;
   end record;
   
   Empty_Message : constant Message_T := Message_T'(Payload => null, Length => 0);
   
end Nanomsg.Messages;
