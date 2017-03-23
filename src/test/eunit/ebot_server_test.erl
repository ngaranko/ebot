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
     {"Checks if basic messaging works",
      ?_test(check_basic_messaging(Pid))},
     {"Checks is service registration works",
      ?_test(check_service_registration(Pid))}
    ].


check_basic_messaging(Pid) ->
    Response = ebot_server:user_message(Pid, <<"/start">>),
    ?assertEqual(command_not_found, Response).

check_service_registration(Pid) ->
    ?assertEqual(added, ebot_server:add_service(Pid, "^tasks", fun test_tasks/1)),
    ?assertEqual({ok, ["tasks"]}, ebot_server:user_message(Pid, "tasks")).



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


test_tasks(Message) ->
    Message.
