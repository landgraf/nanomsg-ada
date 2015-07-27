with Ada.Unchecked_Conversion;
package body Nanomsg.Sockopt is

   function To_C (Obj : in Socket_Option_T) return C.Int is
      function To_Int is new Ada.Unchecked_Conversion (Option_Type_T, C.Int);
   begin
      return To_Int (Obj.Option);
   end To_C;
   
   function Is_Int (Obj : in Socket_Option_T) return Boolean
   is 
   begin
      return Obj.Option in Int_Option_T;
   end Is_Int;
   
end Nanomsg.Sockopt;
