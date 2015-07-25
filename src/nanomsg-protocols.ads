with Interfaces.C;
with Ada.Unchecked_Conversion;
package Nanomsg.Protocols is 
   
   package C renames Interfaces.C;
   
   type Protocol_T is (Nn_PAIR) with Convention => C, Size => C.Int'Size;
   for Protocol_T use (Nn_Pair => 1 * 16 + 0);
   function To_C is new Ada.Unchecked_Conversion (Protocol_T, C.Int);
   
end Nanomsg.Protocols;
