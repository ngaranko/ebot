-module(ebot_public_controller, [Req, SessionID]).
-compile(export_all).


index('GET', [], Context) ->
    io:format("~n~n----------------------------~nREq: ~p~n~n--------------------~n~n", [Req:params()]),
    {json, [{status, "ok"}]};

index('POST', [], Context) ->
    {json, [{status, "ok"}]}.


fb('GET', [], Context) ->
    case application:get_env(etelegram, api_token) of
        {ok, Token} ->
            io:format("~nFound token ~p~n", [Token]),
            Resp = etelegram:get_updates(Token, 505024041),
            case Resp of
                {ok, Messages} ->
                    reply_to_messages(Token, Messages);
                {error, Reason} ->
                    io:format("ERROR:!!! ~n~n~p~n~n", [Reason])
            end;
        Fail ->
            io:format("Failed to fetch API Token for telegram ~n~p", [Fail])
    end,
    {json, [{status, "ok"}]};
fb('POST', [], Context) ->
    io:format("REq: ~p~n~n", [Req:params()]),
    {json, [{status, "ok"}]}.


%% internal shit
reply_to_messages(_Token, []) ->
    ok;
reply_to_messages(Token, [Update | Updates]) ->
    case Update of
        [{<<"update_id">>, _UpdateId}, {<<"message">>, [_TheId, From, _Chat, _Date, TextData]}] ->
            {<<"from">>, [{<<"id">>, ReplyToId}, {<<"first_name">>, ReplyToName} | _]} = From,
            reply_to_message(Token, ReplyToId, ReplyToName, TextData);
        [{<<"update_id">>, UpdateId}, {<<"message">>, [TheId, From, Chat, Date, TextData, Entities]}] ->
            {<<"from">>, [{<<"id">>, ReplyToId}, {<<"first_name">>, ReplyToName} | _]} = From,
            reply_to_message(Token, ReplyToId, ReplyToName, TextData);
        SomethingElse ->
            io:format("Not sure what to do, skip: ~p~n", [SomethingElse])
    end,
    reply_to_messages(Token, Updates).


reply_to_message(Token, ReplyToId, ReplyToName, Message) ->
    case Message of
        {<<"text">>, Text} ->
            StrText = binary:bin_to_list(Text),
            case re:run(StrText, "^\\+ (?<Message>[A-Z-a-z0-9\ \.]+) (?<Scheduled>[0-9\-]+)", [{capture, [1, 2]}]) of
                {match, Matches} ->
                    [TaskText, Scheduled] = get_matched_strings(StrText, lists:reverse(Matches)),
                    Task = task:new(id, TaskText, Scheduled, 0, false),
                    Task:save(),
                    ReplyMessage = lists:flatten(io_lib:format("Saved ~s.", [Task:id()])),
                    etelegram:send_message(Token, ReplyToId, ReplyMessage);
                Rere ->
                    io:format("~nRere: ~p~n~n", [Rere])
            end;
            % ReplyMessage = lists:flatten(io_lib:format("Hello ~s, howdy?", [binary_to_list(ReplyToName)]));
            %% etelegram:send_message(Token, ReplyToId, ReplyMessage);
        Message ->
            io:format("Boo ~p~n", [Message])
    end.


get_matched_strings(Text, Matches) ->
    get_matched_strings(Text, Matches, []).

get_matched_strings(Text, [{MatchStart, MatchStop} | Matches], Result) ->
    get_matched_strings(Text, Matches, [string:substr(Text, MatchStart + 1, MatchStop) | Result]);
get_matched_strings(Text, [], Result) ->
    Result.



get_params() ->
    %% Nasty technique helps reducing syntax errors highlighted in code.
    Req:params().
