with Interfaces.C.Strings;
package Nanomsg.Sockopt is 
   
   type Option_Type_T is (NN_LINGER,
                          NN_SNDBUF,
                          NN_RCVBUF,
                          NN_SNDTIMEO,
                          NN_RCVTIMEO,
                          NN_RECONNECT_IVL,
                          NN_RECONNECT_IVL_MAX,
                          NN_SNDPRIO,
                          NN_RCVPRIO,
                          NN_IPV4ONLY,
                          NN_SOCKET_NAME
                    );
   for Option_Type_T use (NN_LINGER            => 1,
                          NN_SNDBUF            => 2,
                          NN_RCVBUF            => 3,
                          NN_SNDTIMEO          => 4,
                          NN_RCVTIMEO          => 5,
                          NN_RECONNECT_IVL     => 6,
                          NN_RECONNECT_IVL_MAX => 7,
                          NN_SNDPRIO           => 8,
                          NN_RCVPRIO           => 9,
                          NN_IPV4ONLY          => 14,
                          NN_SOCKET_NAME       => 15
                    );

   type Socket_Option_T (Option : Option_Type_T) is tagged private;
                    
   subtype Int_Option_T is Option_Type_T range NN_LINGER .. NN_IPV4ONLY;
   subtype Str_Option_T is Option_Type_T range NN_SOCKET_NAME .. NN_SOCKET_NAME;
   
   package C renames Interfaces.C;
   
   not overriding
   function To_C (Obj : in Socket_Option_T) return C.Int;
   
   not overriding
   function Is_Int (Obj : in Socket_Option_T) return Boolean;
   
private
   type Socket_Option_T (Option : Option_Type_T) is tagged record
      case Option is
         when Int_Option_T => 
            Int_Value : C.Int;
         when Str_Option_T =>
            Str_Value : C.Strings.Chars_Ptr;
      end case;
   end record;
end Nanomsg.Sockopt;
