-module(entities_sup).
-behaviour(supervisor).

-export([start_link/0]).
-export([init/1]).

start_link() ->
	supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init([]) ->
	Procs = [
	{npc_square1, {npc_square, start_link,[{{20,10},{-1,-1}}]}, permanent, 60000, worker, [npc_square]},
    {npc_square2, {npc_square, start_link,[{{30,20},{-1,-1}}]}, permanent, 60000, worker, [npc_square]}
	],
	{ok, {{one_for_one, 10, 1}, Procs}}.
