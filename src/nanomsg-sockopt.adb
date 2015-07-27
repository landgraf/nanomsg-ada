with Ada.Unchecked_Conversion;
package body Nanomsg.Sockopt is

   function To_C (Obj : in Socket_Option_T) return C.Int is
      function To_Int is new Ada.Unchecked_Conversion (Option_Type_T, C.Int);
   begin
      return To_Int (Obj.Option);
   end To_C;
   
   function Get_Level (Obj : in Socket_Option_T) return Socket_Option_Level_T is (Obj.Level);
   
   function Get_Int_Value (Obj : in Socket_Option_T) return C.Int is (Obj.Int_Value);
   
   function Get_Str_Value (Obj : in Socket_Option_T) return C.Strings.Chars_Ptr is (Obj.Str_Value);
   
   procedure Set_Value (Obj : in out Socket_Option_T;
			Value : in Integer) is
   begin
      Obj.Int_Value := C.Int (Value);
   end Set_Value;
   
   procedure Set_Value (Obj : in out Socket_Option_T;
			Value : in String) is
   begin
      Obj.Str_Value := C.Strings.New_String (Value);
   end Set_Value;
   
   procedure Finalize (Obj : in out Socket_Option_T) is
   begin
      if Obj.Option in Str_Option_T then
	 C.Strings.Free (Obj.Str_Value);
      end if;
   end Finalize;
end Nanomsg.Sockopt;
