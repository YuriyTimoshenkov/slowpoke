-module(npc_square).
-author("yt").
-define(INTERVAL, 1000). % One minute
-behaviour(gen_server).

-export([start_link/1]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, code_change/3, terminate/2]).

start_link(Configuration) ->
  gen_server:start_link({local, npc_square}, npc_square,Configuration,[]).

init(Configuration) ->
  erlang:send_after(?INTERVAL, self(), trigger_move_timer),
  {ok,{[],Configuration}}.


handle_call({change_position, NewPosition}, _From, _) ->
  io:fwrite("Position changed to: ~p ~n",[NewPosition]),
  {reply, ok, NewPosition}.


handle_info({'DOWN', _, process, _Pid, _}, State) ->
    {noreply, State};

handle_info(trigger_move_timer, State) ->
   gen_server:cast(mechanic_engine_server, {process_action, move, self(), {1,1}}),
   erlang:send_after(?INTERVAL, self(), trigger_move_timer),
   {noreply, State}.


handle_cast({move, entityRef, vector}, State) ->
  {noreply, State}.

code_change(_,_,_) -> ok.

terminate(_,_) -> ok.

