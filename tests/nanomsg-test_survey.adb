with Nanomsg.Domains;
with Nanomsg.Survey;
with Aunit.Assertions;
with Nanomsg.Messages;
with Ada.Text_Io;

package body Nanomsg.Test_Survey is 
   procedure Run_Test (T : in out TC) is
      use Aunit.Assertions;
      Address            : constant String := "tcp://127.0.0.1:5555";
      Ping : constant String := "PING";
      Pong : constant String := "PONG";
      
      task Server is 
         entry Start;
      end Server;
      
      task body Server is 
      begin
         T.Server.Init (Nanomsg.Domains.Af_Sp, Nanomsg.Survey.Nn_Surveyor);
         T.Server.Bind ("tcp://*:5555");
         delay 1.0;
         accept Start;
         declare
            Msg : Nanomsg.Messages.Message_T;
         begin
            Msg.From_String (Ping);
            T.Server.Send (Msg);
         end;
         for X in T.Clients'Range loop
            declare
               Msg : Nanomsg.Messages.Message_T;
            begin
               select
                  delay 2.0;
                  Assert (False, "Abort in server");
         then abort
            T.Server.Receive (Msg);
               end select;
            end;
         end loop;
      end Server;
      
      
   begin
      for Client of T.Clients loop
         Client.Init (Nanomsg.Domains.Af_Sp, Nanomsg.Survey.Nn_Respondent);
         Client.Connect (Address);
      end loop;
      Server.Start;
      for Client of T.Clients loop
         declare
            Msg : Nanomsg.Messages.Message_T;
         begin
            select 
               delay 2.0;
               Assert (False, "Recv aborted");
            then abort
               Client.Receive (Msg);
            end select;
            Assert (Msg.Text = Ping, "Ping request doesn't match");
         end;
      end loop;
      for Client of T.Clients loop
         declare 
            Msg : Nanomsg.Messages.Message_T;
         begin
            Msg.From_String (Pong);
            Client.Send (Msg);
         end;
      end loop;
      
   end Run_Test;
   
   function Name (T : TC) return Message_String is
   begin
      return Aunit.Format ("Test case name : Publisher/Subsriber test");
   end Name;
   
   procedure Tear_Down (T : in out Tc) is
   begin
      if T.Server.Get_Fd >= 0 then
         T.Server.Close;
      end if;
      
   end Tear_Down;

end Nanomsg.Test_Survey;
