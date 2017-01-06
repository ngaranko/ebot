-module(ebot_server).
-behaviour(gen_server).

-export([start_link/0, stop/1]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).


%%% Client API
start_link() ->
    gen_server:start_link(?MODULE, [], []).

stop(Pid) ->
    gen_server:call(Pid, stop).


%%% Server functions
init([]) -> {ok, []}. %% no treatment of info here!

handle_call(Call, From, State) ->
    io:format("Call: ~p, From: ~p, State: ~p", [Call, From, State]),
    {reply, "ok", State}.

handle_cast(Cast, State) ->
    io:format("Cast: ~p", [Cast, State]),
    {noreply, State}.

handle_info(Msg, State) ->
    io:format("Unexpected message: ~p~n",[Msg]),
    {noreply, State}.

terminate(normal, State) ->
    io:format("Terminating. State: ~p", [State]),
    ok.

code_change(_OldVsn, State, _Extra) ->
    %% No change planned. The function is there for the behaviour,
    %% but will not be used. Only a version on the next
    {ok, State}. 

%%% Private functions
