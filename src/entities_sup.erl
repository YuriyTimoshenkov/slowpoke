-module(entities_sup).
-behaviour(supervisor).

-export([start_link/0]).
-export([init/1]).

start_link() ->
	supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init([]) ->
	Procs = [
	{npc_square, {npc_square, start_link,[bob]}, permanent, 60000, worker, [npc_square]}
	],
	{ok, {{one_for_one, 1, 5}, Procs}}.
