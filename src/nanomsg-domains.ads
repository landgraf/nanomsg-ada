with Interfaces.C;
with Ada.Unchecked_Conversion;
package Nanomsg.Domains is
   package C renames Interfaces.C;
   
   type Domain_T is (Af_Sp, Af_Sp_Raw) with Convention => C, Size => C.Int'Size;
   for Domain_T use (Af_Sp => 1, Af_Sp_Raw => 2);
   function To_C is new Ada.Unchecked_Conversion (Domain_T, C.Int);

end Nanomsg.Domains;
