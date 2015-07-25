package body Nanomsg.Domains is
   function To_C (Obj : Domain_T) return C.Int is (Obj.Int);
end Nanomsg.Domains;
