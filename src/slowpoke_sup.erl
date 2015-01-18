-module(slowpoke_sup).
-behaviour(supervisor).
-export([start_link/0]).
-export([init/1]).

start_link() ->
	supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init([]) ->
	Procs = [
		{mechanic_engine_server, {mechanic_engine_server, start_link,[bob]}, permanent, 60000, worker, [mechanic_engine_server]},
		{physical_engine_server, {physical_engine_server, start_link,[bob]}, permanent, 60000, worker, [physical_engine_server]},
    {map_server, {map_server, start_link,[bob]}, permanent, 60000, worker, [map_server]},
		{entities_sup, {entities_sup, start_link,[]}, permanent, infinity, supervisor, [entities_sup]}
	],
	{ok, {{one_for_one, 10, 1}, Procs}}.
