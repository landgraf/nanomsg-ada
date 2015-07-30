with Ada.Unchecked_Conversion;
with Ada.Unchecked_Deallocation;
with Ada.Streams;
with Interfaces.C.Strings;
with Interfaces.C.Pointers;
with Nanomsg.Errors;
with Nanomsg.Sockopt;
with System;
package body  Nanomsg.Socket is
   package C renames Interfaces.C;
   use type C.Int;
   
   function Is_Null (Obj : in Socket_T) return Boolean is (Obj.Fd = -1);
   
   procedure Init (Obj      :    out Socket_T;
                   Domain   : in     Nanomsg.Domains.Domain_T;
                   Protocol : in     Nanomsg.Protocols.Protocol_T
                  ) is
      
      function C_Nn_Socket (Domain : in C.Int; Protocol : in C.Int) return C.Int
      with Import, Convention => C, External_Name => "nn_socket";
      
   begin
      Obj.Fd := Integer (C_Nn_Socket (Nanomsg.Domains.To_C (Domain), 
                                      Nanomsg.Protocols.To_C (Protocol)));
      if Obj.Fd < 0 then 
         raise Socket_Exception with "Init: " & Nanomsg.Errors.Errno_Text;
      end if;
   end Init;
   
   procedure Close (Obj : in out Socket_T) is 
      function C_Nn_Close (Socket : in C.Int) return C.Int
      with Import, Convention => C, External_Name => "nn_close";
      
   begin
      Obj.Delete_Endpoint;
      if C_Nn_Close (C.Int (Obj.Fd)) /= 0 then
         raise Socket_Exception with "Close: " & Nanomsg.Errors.Errno_Text;
      end if;
      Obj.Fd := -1;
   end Close;

   procedure Bind (Obj     : in out Socket_T;
                   Address : in     String) is
      
      function C_Bind (Socket : in C.Int; Address : in C.Strings.Chars_Ptr) return C.Int
      with Import, Convention => C, External_Name => "nn_bind";
      C_Address : C.Strings.Chars_Ptr := C.Strings.New_String (Address);
   begin
      Obj.Endpoint := Integer (C_Bind(C.Int (Obj.Fd), C_Address));
      C.Strings.Free (C_Address);
      if Obj.Endpoint < -1 then
         raise Socket_Exception with "Bind: "  & Nanomsg.Errors.Errno_Text;
      end if;
      -- FIXME 
      -- Add endpoints container
   end Bind;
   
   procedure Connect (Obj     : in out Socket_T;
                      Address : in     String) is
      
      function C_Connect (Socket : in C.Int; Address : in C.Strings.Chars_Ptr) return C.Int
      with Import, Convention => C, External_Name => "nn_connect";
      C_Address : C.Strings.Chars_Ptr := C.Strings.New_String (Address);
   begin
      Obj.Endpoint := Integer (C_Connect(C.Int (Obj.Fd), C_Address));
      C.Strings.Free (C_Address);
      if Obj.Endpoint < 0 then
         raise Socket_Exception with "Connect: " & Nanomsg.Errors.Errno_Text;
      end if;
   end Connect;

   function Get_Fd (Obj : in Socket_T) return Integer is (Obj.Fd);   
   
   procedure Receive (Obj : in out Socket_T;
                      Message : out Nanomsg.Messages.Message_T) is      
      
      
      Payload : System.Address;
      use type System.Address;
      
      Received : Integer;
      use type C.Size_T;      
      Flags : constant C.Int := 0;
      Nn_Msg : constant C.Size_T := C.Size_T'Last;
      
      function Nn_Recv (Socket     :     C.Int;
                        Buf_Access : out System.Address;
                        Size       :     C.Size_T;
                        Flags      :     C.Int
                       ) return C.Int with Import, Convention => C, External_Name => "nn_recv";
      
      function Free_Msg (Buf_Access :System.Address) return C.Int
      with Import, Convention => C, External_Name => "nn_freemsg";
   begin
      Received := Integer (Nn_Recv (C.Int (Obj.Fd), Payload, Nn_Msg, Flags));
      if Received < 0 then
         raise Socket_Exception with "Receive: " & Nanomsg.Errors.Errno_Text;
      end if;
      Message.Set_Length (Received);
      declare
         Data :  Ada.Streams.Stream_Element_Array (1 .. Ada.Streams.Stream_Element_Offset (Received));
         for Data'Address use Payload;
      begin
         Message.Set_Payload (Data);
      end;
      if Free_Msg (Payload) < 0 then
         raise Socket_Exception with "Deallocation failed";
      end if;
   end Receive;
   
   procedure Send (Obj : in Socket_T; Message : Nanomsg.Messages.Message_T) is
      Flags : C.Int := 0;
      function Nn_Send (Socket     : C.Int;
                        Buf_Access : Ada.Streams.Stream_Element_Array;
                        Size       : C.Size_T;
                        Flags      : C.Int
                       ) return C.Int with Import, Convention => C, External_Name => "nn_send";
      Sent : Integer;
   begin
      
      Sent := Integer (Nn_Send (C.Int (Obj.Fd),
                                Message.Get_Payload.all,
                                C.Size_T (Message.Get_Length),
                                Flags));
      if Sent < 0 then 
         raise Socket_Exception with "Send: " & Nanomsg.Errors.Errno_Text;
      end if;
      if Sent /= Message.Get_Length then
         raise Socket_Exception with "Send/Receive count doesn't match";
      end if;
   end Send;
   
   procedure Delete_Endpoint (Obj : in out Socket_T) is
      function Nn_Shutdown (Socket : C.Int;
                            Endpoint : C.Int) return C.Int
      with Import, Convention => C, External_Name => "nn_shutdown";
   begin
      if Obj.Endpoint > 0 then
         if Nn_Shutdown (C.Int (Obj.Fd), C.Int (Obj.Endpoint)) < 0 then
            raise Socket_Exception with "Shutdown Error" &  Nanomsg.Errors.Errno_Text;
         end if;
         Obj.Endpoint := -1;
      end if;
   end Delete_Endpoint;
   
   function C_Setsockopt (Socket : C.Int;
                          Level  : C.Int;
			  Option : C.Int;
			  Value  : System.Address;
			  Size   : C.Size_T) return C.Int with Import, Convention => C, External_Name => "nn_setsockopt";
   
   procedure Set_Option (Obj   : in out Socket_T;
                         Level : in     Nanomsg.Sockopt.Option_Level_T;
                         Name  : in     Nanomsg.Sockopt.Option_Type_T;
                         Value : in     Natural)
   is     
      use Nanomsg.Sockopt;
      Size : C.Size_T := C.Size_T (C.Int'Size);
   begin
      begin
         if C_Setsockopt (C.Int (Obj.Fd), 
                          C.Int (Level), 
                          C.Int (Name), 
                          Value'Address,
                          Size) < 0 then
            raise Socket_Exception with "Setopt error";
         end if;
      end;
   end Set_Option;
   
   procedure Set_Option (Obj   : in out Socket_T;
                         Level : in     Nanomsg.Sockopt.Option_Level_T;
                         Name  : in     Nanomsg.Sockopt.Option_Type_T;
                         Value : in     String) is
      C_Value : C.Strings.Char_Array_Access := new C.Char_Array'(C.To_C (Value)) with Convention => C;
      procedure Free is new Ada.Unchecked_Deallocation (Name	=> C.Strings.Char_Array_Access, 
							Object	=> C.Char_Array);
      Size	: C.Size_T	:= C_Value'Length;
   begin
      if C_Setsockopt (C.Int (Obj.Fd),
                       C.Int (Level), 
                       C.Int (Name), 
                       C_Value.all'Address,
                       Size) < 0 then
         raise Socket_Exception with "Setopt error"  &  Nanomsg.Errors.Errno_Text;
      end if;
      Free (C_Value);
   end Set_Option;
   

   

   function Get_Option (Obj   : in Socket_T;
                        Level : in Nanomsg.Sockopt.Option_Level_T;
                        Name  : in Nanomsg.Sockopt.Option_Type_T) return String is
      type String_Access_T is access all String;
      procedure Free is new Ada.Unchecked_Deallocation (Name => String_Access_T,
							Object => String);
      
      function Nn_Getsockopt (Socket	  : in 	   C.Int;
			      Level	  : in 	   C.Int;
			      Option_Name : in 	   C.Int;
			      Value	  : in out String_Access_T;
			      Size	  : in 	   System.Address) return C.Int
      with Import, Convention => C, External_Name => "nn_getsockopt";      
      
      
      use Nanomsg.Sockopt;
      Max_Size : constant := 63;
      Ptr : String_Access_T := new String(1..Max_Size);
      Size	: C.Size_T := Max_Size;
      use type C.Size_T;
   begin
      if Nn_Getsockopt (Socket		=> C.Int (Obj.Fd),
			Level		=> C.Int (Level),
			Option_Name	=> C.Int (Name),
			Value		=> Ptr,
			Size		=> Size'Address) < 0 then
	 raise Socket_Exception with "Getopt error"  &  Nanomsg.Errors.Errno_Text;
      end if;
      declare
         Retval : constant String := Ptr.all(1.. Integer (Size)); 
      begin
	 Free (Ptr);
         return Retval;
      end;
   end Get_Option;
   
   function Get_Option (Obj   : in Socket_T;
                        Level : in Nanomsg.Sockopt.Option_Level_T;
                        Name  : in Nanomsg.Sockopt.Option_Type_T) return Natural is
      Retval : Natural;
      Size : C.Size_T := C.Int'Size;
      function Nn_Getsockopt (Socket	  : in 	   C.Int;
			      Level	  : in 	   C.Int;
			      Option_Name : in 	   C.Int;
			      Value	  : in out C.Int;
			      Size	  : in 	   System.Address) return C.Int
      with Import, Convention => C, External_Name => "nn_getsockopt";      
   begin
      if Nn_Getsockopt (Socket		=> C.Int (Obj.Fd),
			Level		=> C.Int (Level),
			Option_Name	=> C.Int (Name),
			Value		=> C.Int (Retval),
			Size		=> Size'Address) < 0 then
	 raise Socket_Exception with "Getopt error"  &  Nanomsg.Errors.Errno_Text;
      end if;
      return Retval;
   end Get_Option;      
   
end Nanomsg.Socket;
