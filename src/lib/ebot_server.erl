-module(ebot_server).
-behaviour(gen_server).

-export([start_link/0, stop/1, user_message/2, add_service/3]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).


%%% Client API
start_link() ->
    gen_server:start_link(?MODULE, [], []).

stop(Pid) ->
    gen_server:call(Pid, stop).

user_message(Pid, Message) ->
    gen_server:call(Pid, {message, Message}).

add_service(Pid, CommandRegex, Command) ->
    gen_server:call(Pid, {add_service, CommandRegex, Command}).


%%% Server functions
init([]) -> {ok, #{"services"=>[]}}.

handle_call({message, Message}, From, State) ->
    io:format("Message: ~p, From: ~p, State: ~p", [Message, From, State]),
    case reply_to_message(Message, State) of
        {ok, Reply} ->
            {reply, {ok, Reply}, State};
        Other ->
            {reply, Other, State}
    end;

handle_call({add_service, CommandRegex, Command}, _From, #{"services" := Services}=State) ->
    io:format("Registering service: ~p~n~p", [CommandRegex, Command]),
    {reply, added, State#{"services" := lists:append(Services, [{CommandRegex, Command}])}};

handle_call(Call, From, State) ->
    io:format("Call: ~p, From: ~p, State: ~p", [Call, From, State]),
    {reply, "ok", State}.

handle_cast(Cast, State) ->
    io:format("Cast: ~p | ~p", [Cast, State]),
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
reply_to_message(Message, State) ->
    {ok, Services} = maps:find("services", State),
    case find_services(Message, Services) of
        [] ->
            command_not_found;
        Commands ->
            {ok, call_commands(Commands, Message)}
    end.


find_services(Message, Services) ->
    find_services(Message, Services, []).

find_services(Message, [{REX, Command} | Services], Commands) ->
    case re:run(REX, Message) of
        {match, _Matches} ->
            find_services(Message, Services, lists:append(Commands, [Command]));
        [] ->
            find_services(Message, Services, Commands)
    end;
find_services(_Message, [], Commands) ->
    Commands.


call_commands(Commands, Message) ->
    call_commands(Commands, Message, []).

call_commands([Command | Commands], Message, Response) ->
    call_commands(Commands, Message, lists:append(Response, [Command(Message)]));
call_commands([], _Message, Response) ->
    Response.
