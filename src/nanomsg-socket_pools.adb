with Nanomsg.Socket;
with Interfaces.C;

package body Nanomsg.Socket_Pools is 
   procedure Add_Socket (Self   : in out Pool_T;
                         Socket : in     Nanomsg.Socket.Socket_T) is
   begin
      Pool_Container_P.Insert (Self.Pool, Socket.Get_Fd, Socket);
   end Add_Socket;
   
   procedure Remove_Socket (Self   : in out Pool_T;
                            Socket : in     Nanomsg.Socket.Socket_T) is
   begin
      Pool_Container_P.Delete (Self.Pool, Socket.Get_Fd);
   end Remove_Socket;
   
   function Check_Pool (Self    : in Pool_T;
                        Send    : in Boolean;
                        Receive : in Boolean) return Pool_T is
      Retval : Pool_T;      
      package C renames Interfaces.C;
      type Flags_T is mod 2**C.Short'Size with Size => C.Short'Size;
      nn_pollin  :  constant Flags_T := 1;
      nn_pollout :  constant Flags_T := 2;
      
      type Nn_Poll_T is record
         Fd      : C.Int;
         Events  : C.Short;
         Revents : C.Short;
      end record with Convention => C;
      
      type Nn_Poll_Array_T is array (1 .. Pool_Container_P.Length (Self.Pool)) of Nn_Poll_T with Convention => C;
      
      type Nn_Poll_Array_Access_T is access all Nn_Poll_Array_T with Convention => C;
      
      -- int nn_poll (struct nn_pollfd *fds, int nfds, int timeout);
      function Nn_Poll (Fds     : in out Nn_Poll_Array_T;
                        Nfds    :        C.Int;
                        Timeout :        C.Int) return C.Int
      with Import, Convention => C , External_Name => "nn_poll";
      
      Req       : Nn_Poll_Array_T; 
      In_Flags  : C.Short := C.Short ((if Send then NN_Pollin else 0) or (if Receive then NN_Pollout else 0));
      Out_Flags : C.Short := 0;
      use type C.Int;
                             
   begin
      declare
         Position :  Pool_Container_P.Cursor := Pool_Container_P.First (Self.Pool);
      begin
         for Index in Req'Range loop
            Req (Index) := (Fd      => C.Int (Pool_Container_P.Key (Position)), 
                            Events  => In_Flags,
                            Revents => Out_Flags);
         end loop;
      end;
      if Send then 
         Req(1).Events := C.Short (Flags_T (Req(1).Events) or Nn_Pollout);
      end if;
      if Receive then
         Req(1).Events := C.Short (Flags_T (Req(1).Events) or Nn_Pollin);
      end if;
      
      if Nn_Poll (Req,  Req'Length,  1000) < 0 then
         raise Nanomsg.Socket.Socket_Exception with "Nn_Poll failed";
      end if;
      
      for Element of Req loop
         declare
            Result : Flags_T := Flags_T (Element.Events) and Flags_T (Element.Revents);
         begin
            if Send and then Receive then
               if (Result or Nn_Pollin or Nn_Pollout) = (Nn_Pollin or Nn_Pollout) then
                  Pool_Container_P.Insert (Container => Retval.Pool, 
                                           Key       => Integer (Element.Fd), 
                                           New_Item  => Pool_Container_P.Element (Container => Self.Pool, 
                                                                                  Key => Integer (Element.Fd)));
               end if;
            else
               declare
               Is_Matched  : Boolean := (Result or (if Send then Nn_Pollout else Nn_Pollin)) = (if Send then Nn_Pollout else Nn_Pollin);
               begin
                  if Is_Matched then
                     Pool_Container_P.Insert (Container => Retval.Pool, 
                                              Key       => Integer (Element.Fd), 
                                              New_Item  => Pool_Container_P.Element (Container => Self.Pool, 
                                                                                     Key => Integer (Element.Fd)));
                     
                  end if;
               end ;

            end if;
         end;
      end loop;
      return Retval;
   end Check_Pool;
   
   function Has_Message (Self : in Pool_T) return Pool_T is 
   begin
      return Check_Pool (Self, Receive => True, Send => False);
   end Has_Message;
   
   function Ready_To_Send (Self : in Pool_T) return Pool_T is
   begin
      return Check_Pool (Self, Receive => True, Send => False);
   end Ready_To_Send;
   
   function Ready_To_Send_Receive (Self : in Pool_T) return Pool_T is
   begin
      return Check_Pool (Self, Receive => True, Send => True);
   end Ready_To_Send_Receive;
   
   function Has_Socket (Self   : in Pool_T;
                        Socket : in Nanomsg.Socket.Socket_T) return Boolean is (Pool_Container_P.Contains (Self.Pool, Socket.Get_Fd));
   
end Nanomsg.Socket_Pools;
