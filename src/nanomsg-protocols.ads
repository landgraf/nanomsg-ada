with Interfaces.C;
package Nanomsg.Protocols is 
   package C renames Interfaces.C;
   type Protocol_T is tagged private;
   function To_C (Obj : in Protocol_T) return C.Int;
   
private
   type Protocol_T is tagged record
      Int : C.Int;
   end record;
   
end Nanomsg.Protocols;
