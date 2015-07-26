with Ada.Unchecked_Deallocation;
with Interfaces.C.Strings;
package body Nanomsg.Messages is
   
   package C renames Interfaces.C;
   function Is_Empty (Obj : in Message_T) return Boolean is (Obj.Length = 0);
   
   
   procedure From_String (Message :    out Message_T;
                          Text    : in     String) is
      Payload                     : Bytes_Array_T (Text'Range);
      for Payload'Address use Text'Address;
   begin
      Message.Payload := new Bytes_Array_T'(Payload);
      Message.Length  := Text'Length; 
   end From_String;
   
   function Text (Obj : in Message_T) return String is
   begin
      if Obj.Is_Empty then
         return "";
      end if;
      declare
         Retval : String (1 .. Obj.Length);
--         for Retval'Address use Obj.Payload'Address;
      begin
         for Index in Retval'Range loop
            Retval (Index) := Obj.Payload (Index);
         end loop;
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
      procedure Free_Payload is new Ada.Unchecked_Deallocation (Bytes_Array_T, Bytes_Array_Access_T);
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
                          Payload : in     Bytes_Array_Access_T) is
   begin
      Obj.Payload := Payload;
   end Set_Payload;
   
   procedure Finalize (Obj : in out Message_T) is 
   begin
      Free (Obj);
   end Finalize;
   
end Nanomsg.Messages;
