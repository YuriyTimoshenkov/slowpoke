-module(physical_engine_server).
-author("yt").
-behaviour(gen_server).

-export([start_link/1]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, code_change/3, terminate/2]).

start_link(Configuration) ->
  gen_server:start_link({local, physical_engine_server}, physical_engine_server,Configuration,[]).

init(Configuration) ->
  {ok,{[],Configuration}}.


handle_call(get_state, _From, State) ->
  {reply, State, State}.



handle_cast({process_action, move, EntityRef, {X,Y}, {DX,DY}}, State) ->
  Objects = gen_server:call(map_server, {get_current_region_objects, {X,Y}}),
  CurrentObject = {Y+5+DY,Y-5+DY,X-5+DX,X+5+DX},
  FilteredObects = lists:dropwhile(
    fun(Z) -> not collide(CurrentObject, Z) end,
    Objects),

  case FilteredObects of
    [] ->
      gen_server:call(EntityRef, {change_position, {X + DX,Y + DY},{DX,DY}}),
      io:fwrite("No collizion: ~p ~p ~n",[DX,DY]),
      {noreply, State};
    [CO|_] ->
      {DXc,DYc} = get_correction_vector(CurrentObject, CO, {erlang:abs(DX),erlang:abs(DY)}),
      gen_server:call(EntityRef, {change_position, {X + DXc,Y + DYc},{DXc,DYc}}),
      io:fwrite("Collizion with ~p, DX ~p, DY, ~p  ~n",[CO, DXc,DYc]),
      {noreply, State}
  end.



handle_info({'DOWN', _, process, _Pid, _}, State) ->
    {noreply, State}.


code_change(_,_,_) -> ok.

terminate(_,_) -> ok.

collide({T1, B1, L1, R1},
    {T2, B2, L2, R2}) ->
  if
    T1 < B2 -> false;
    B1 > T2 -> false;
    L1 > R2 -> false;
    R1 < L2 -> false;
    true ->  io:fwrite("~p ~p ~p ~p, ~p ~p ~p ~p ~n",[T1,B1,L1,R1,T2,B2,L2,R2]), true
  end.

get_correction_vector({T1,B1,L1,R1},{T2,B2,L2,R2}, {DX,DY}) ->
  X1 = erlang:abs(R1-L2),
  X2 = erlang:abs(L1-R2),
  Y1 = erlang:abs(B1-T2),
  Y2 = erlang:abs(T1-B2),

  DXc = case {X1,X2} of
   {X1,X2} when X1 < X2 ->  -DX;
    _ ->  DX
  end,

  DYc = case {Y1,Y2} of
    {Y1,Y2} when Y1 < Y2 -> DY;
    _ ->  -DY
    end,

  {DXc,DYc}.

