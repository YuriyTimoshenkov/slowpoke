%%%-------------------------------------------------------------------
%%% @author yt
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 18. Jan 2015 14:42
%%%-------------------------------------------------------------------
-module(http_handler).
-author("yt").

%% API
-export([init/2]).


init(Req, Opts) ->
  Action = cowboy_req:binding(action, Req),

  Result = case Action of
  <<"getviewstate">> -> get_view_state();
  _ -> <<"None">>
  end,


  io:fwrite("GetState: ~p ~n",[get_view_state()]),

  Req2 = cowboy_req:reply(200, [
    {<<"content-type">>, <<"text/plain">>}
  ], Result, Req),
  {ok, Req2, Opts}.

get_view_state() ->
  Childs = supervisor:which_children(entities_sup),

  States = lists:filtermap(
     fun(Elem) ->
       {_,Pid,_,_} = Elem,
       {{X,Y},{DX,DY}} = gen_server:call(Pid, get_position),
       {true, {list_to_binary(pid_to_list(Pid)),{[{x, X},{y,Y},{dx,DX},{dy,DY}]}}}
       end, Childs),

  io:fwrite("States: ~p ~n",[States]  ),

  jiffy:encode({States}).

