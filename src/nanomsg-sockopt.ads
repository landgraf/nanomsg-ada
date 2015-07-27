with Interfaces.C.Strings;
with Ada.Finalization;
package Nanomsg.Sockopt is 
   package C renames Interfaces.C;
   
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

   type Socket_Option_T (Option : Option_Type_T) is new Ada.Finalization.Controlled with private;
                    
   subtype Int_Option_T is Option_Type_T range NN_LINGER .. NN_IPV4ONLY;
   subtype Str_Option_T is Option_Type_T range NN_SOCKET_NAME .. NN_SOCKET_NAME;
   
   type Socket_Option_Level_T is (Generic_Socket_Level, 
                                  Type_Specific_Socket_Level,
                                  Transport_Specific_Socket_Level) with Size => C.Int'Size;

   Option_Level : constant array (Option_Type_T) of Socket_Option_Level_T := (
                                                                              NN_LINGER            => Generic_Socket_Level,
                                                                              NN_SNDBUF            => Generic_Socket_Level,
                                                                              NN_RCVBUF            => Generic_Socket_Level,
                                                                              NN_SNDTIMEO          => Generic_Socket_Level,
                                                                              NN_RCVTIMEO          => Generic_Socket_Level,
                                                                              NN_RECONNECT_IVL     => Transport_Specific_Socket_Level,
                                                                              NN_RECONNECT_IVL_MAX => Transport_Specific_Socket_Level,
                                                                              NN_SNDPRIO           => Type_Specific_Socket_Level,
                                                                              NN_RCVPRIO           => Type_Specific_Socket_Level,
                                                                              NN_IPV4ONLY          => Generic_Socket_Level,
                                                                              NN_SOCKET_NAME       => Generic_Socket_Level);

   

   
   not overriding
   function To_C (Obj : in Socket_Option_T) return C.Int;
   
   not overriding
   function Is_Int_Option (Obj : in Socket_Option_T) return Boolean is (Obj.Option in Int_Option_T);
   
   not overriding
   function Is_Str_Option (Obj : in Socket_Option_T) return Boolean is (Obj.Option in Str_Option_T);
   
   not overriding
   function Get_Int_Value (Obj : in Socket_Option_T) return C.Int;
   
   not overriding
   function Get_Str_Value (Obj : in Socket_Option_T) return C.Strings.Chars_Ptr;
   
   procedure Set_Value (Obj   : in out Socket_Option_T;
			Value : in     Integer);
   
   procedure Set_Value (Obj   : in out Socket_Option_T;
			Value : in     String);
   
   not overriding
   function Get_Level (Obj : in Socket_Option_T) return Socket_Option_Level_T;
   
   
   
private
   type Socket_Option_T (Option : Option_Type_T) is new Ada.Finalization.Controlled with record
      Level : Socket_Option_Level_T := Option_Level (Option);
      case Option is
         when Int_Option_T => 
            Int_Value : C.Int;
         when Str_Option_T =>
            Str_Value : C.Strings.Chars_Ptr;
      end case;
   end record;
   
   overriding
   procedure Finalize (Obj : in out Socket_Option_T);
end Nanomsg.Sockopt;
