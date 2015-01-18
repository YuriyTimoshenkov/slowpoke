-module(slowpoke_app).
-behaviour(application).

-export([stop/1, start_deps/0,start/2]).

start(_Type, _Args) ->
  Dispatch = cowboy_router:compile([
    {'_', [
      {"/:action/", http_handler, []}
    ]}
  ]),
  {ok, _} = cowboy:start_http(http, 100, [{port, 8083}], [
    {env, [{dispatch, Dispatch}]}
  ]),

	slowpoke_sup:start_link().

stop(_State) ->
	ok.

start_deps()->
  lists:foreach(fun(App) ->
    ok = application:start(App)
  end,
    [crypto,
      ranch,
      cowlib, cowboy]),
  ok.
