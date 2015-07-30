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
