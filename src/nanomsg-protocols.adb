package body Nanomsg.Protocols is 
   function To_C (Obj : in Protocol_T) return C.Int is (Obj.Int);
end Nanomsg.Protocols;
