-module(mechanic_engine_server).
-author("yt").
-behaviour(gen_server).

-export([start_link/1]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, code_change/3, terminate/2]).

start_link(Configuration) ->
  gen_server:start_link({local, mechanic_engine_server}, mechanic_engine_server,Configuration,[]).

init(Configuration) ->
  {ok,{[],Configuration}}.


handle_call(get_state, _From, State) ->
  {reply, State, State}.


handle_info({'DOWN', _, process, _Pid, _}, State) ->
    {noreply, State}.


handle_cast({process_action, move, EntityRef, Vector}, State) ->
  gen_server:cast(physical_engine_server, {process_action, move, EntityRef, Vector}),
  {noreply, State}.

code_change(_,_,_) -> ok.

terminate(_,_) -> ok.
