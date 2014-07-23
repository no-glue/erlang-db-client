-module(database_client).
-export([start/0, init/0, loop/0, stop/0, get_key/1]).

start()->register(database_client, spawn(database_client, init, [])).
% start database client

init()->loop().
% start looping and receiveing messages

loop()->
  receive
    {request, Pid, Message}->
      received(request, Pid, Message);
    {reply, Message}->
      received_reply(Message)
  end.
% loop and receive messages

received(request, Pid, stop)->tell:reply(Pid, ok).
% stop client

received_reply(Message)->io:format(Message), loop().
% received reply

me(Message)->tell:tell(database_client, Message).
% tell me something

stop()->me(stop).
% tell me to stop

tell_database(Message)->tell:tell_from(database, Message, database_client).
% tell something database

get_key(Key)->tell_database({get, [Key]}).
% get key value from database