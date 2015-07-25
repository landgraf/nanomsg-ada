with Interfaces.C;
package Nanomsg.Domains is
   package C renames Interfaces.C;
   type Domain_T is tagged private;
   
   function To_C (Obj : Domain_T) return C.Int;
private
   
   type Domain_T is tagged record
      Int : C.Int;
   end record;
end Nanomsg.Domains;
