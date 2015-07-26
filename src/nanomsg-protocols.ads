with Interfaces.C;
with Ada.Unchecked_Conversion;
package Nanomsg.Protocols is 
   
   package C renames Interfaces.C;
   
   Nn_Proto_Pair : constant := 1;
   Nn_Proto_Pipeline : constant := 5;
   type Protocol_T is (Nn_Pair, Nn_Push, Nn_Pull) with Convention => C, Size => C.Int'Size;
   for Protocol_T use (Nn_Pair => Nn_Proto_Pair * 16 + 0,
                       Nn_Push => Nn_Proto_Pipeline * 16 + 0,
                       Nn_Pull => Nn_Proto_Pipeline * 16 + 1
                      );
   function To_C is new Ada.Unchecked_Conversion (Protocol_T, C.Int);
   
end Nanomsg.Protocols;
