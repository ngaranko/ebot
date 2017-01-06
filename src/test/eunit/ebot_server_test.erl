-module(ebot_server_test).
-include_lib("eunit/include/eunit.hrl").

%%%============================================================================
%%% API
%%%============================================================================

suite_test_()->
    Suite =
    {foreach,
      fun start/0,
      fun stop/1,
      [fun tests/1]
     },
    Suite.



tests(Pid) ->
    io:format("Starting test ~p~n", [Pid]),
    [
     {"Checks if empty entries result in list",
      ?_test(check_empty_entries(Pid))}
    ].

check_empty_entries(Pid) ->
    ?assertEqual([], [Pid]).


%% ===================================================================
%% Internal functions
%% ===================================================================

%%--------------------------------------------------------------------
%% @doc Setup each test set
%%--------------------------------------------------------------------
start() ->
    {ok, Pid} = ebot_server:start_link(),
    Pid.

stop(Pid) ->
    ebot_server:stop(Pid).
