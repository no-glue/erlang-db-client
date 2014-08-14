-module(database_client).
-export([start/0, init/0, loop/0, stop/0, get_key/1]).

start()->register(database_client, spawn(database_client, init, [])).
% start database client

stop()->me(stop).
% tell me to stop

get_key(Key)->me({get, Key}).
% tell me to get key

init()->loop().
% start looping and receiveing messages

loop()->
  receive
    {request, Pid, Message}->
      received(request, Pid, Message)
  end.
% loop and receive messages

me(Message)->tell:tell(database_client, Message).
% tell me something

received(request, Pid, stop)->tell:reply(Pid, ok);
% received stop
received(request, Pid, {get, Key})->tell:tell(database, {get, Key}), loop().
% received request to get key
% to this with a queue