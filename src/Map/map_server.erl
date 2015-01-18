-module(map_server).
-author("yt").
-behaviour(gen_server).

-export([start_link/1]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, code_change/3, terminate/2]).

start_link(Configuration) ->
  gen_server:start_link({local, map_server}, map_server,Configuration,[]).

init(Configuration) ->
  {ok,Configuration}.


handle_call({get_current_region_objects, _}, _From, State) ->
  Objects = [
    {0,-10,0,100},
    {110,100,0,100},
    {100,0,-10,0},
    {100,0,100,110}
  ],
  {reply, Objects, State}.


handle_info({'DOWN', _, process, _Pid, _}, State) ->
    {noreply, State}.


handle_cast(_, State) ->
  {noreply, State}.

code_change(_,_,_) -> ok.

terminate(_,_) -> ok.
