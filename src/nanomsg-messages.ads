with System;
with Ada.Finalization;
package Nanomsg.Messages is
   
   type Bytes_Array_T is array (Natural range <>) of Character
   with Convention => C, Alignment => 1 ;
   type Bytes_Array_Access_T is access all Bytes_Array_T with Convention => C, Size => System.Word_Size;   

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
   
private
   
   overriding
   procedure Finalize (Obj : in out Message_T);

   type Message_T is new Ada.Finalization.Controlled with  record
      Payload : Bytes_Array_Access_T := null;
      Length  : Natural;
   end record;
   
   Empty_Message : constant Message_T := (Ada.Finalization.Controlled with Payload => null, Length => 0);
   
end Nanomsg.Messages;
