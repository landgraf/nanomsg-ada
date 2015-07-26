with Interfaces.C.Strings;
package body Nanomsg.Messages is
   
   package C renames Interfaces.C;
   function Is_Empty (Obj : in Message_T) return Boolean is (Obj.Length = 0);
   
   function From_String (Text : in String) return Message_T is
      Retval                  : Message_T;
      Payload                 : Bytes_Array_T (Text'Range);
      for Payload'Address use Text'Address;
   begin
      Retval.Payload := new Bytes_Array_T'(Payload);
      Retval.Length  := Text'Length; -- \0 terminated
      return Retval;
   end From_String;
   
   function Text (Obj : in Message_T) return String is
   begin
      if Obj.Is_Empty then
         return "";
      end if;
      declare
         Retval : String (1 .. Obj.Length);
         for Retval'Address use Obj.Payload'Address;
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
   
   function Payload (Obj : in Message_T) return Bytes_Array_Access_T is (Obj.Payload);
   function Length (Obj : in Message_T) return Natural is (Obj.Length);
   
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
end Nanomsg.Messages;
