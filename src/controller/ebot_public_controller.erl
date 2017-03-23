-module(ebot_public_controller, [Req, SessionID]).
-compile(export_all).


index('GET', [], Context) ->
    case application:get_env(etelegram, api_token) of
        {ok, Token} ->
            io:format("~nFound token ~p~n", [Token]),
            Resp = etelegram:get_updates(Token),
            case Resp of
                {ok, Messages} ->
                    reply_to_messages(Token, Messages);
                {error, Reason} ->
                    io:format("ERROR:!!! ~n~n~p~n~n", [Reason])
            end;
        Fail ->
            io:format("Failed to fetch API Token for telegram ~n~p", [Fail])
    end,
    {ok, Context};

index('POST', [], Context) ->
    io:format("REq: ~p~n~n", [get_params()]),
    {json, [{status, "ok"}], Context}.


fb('POST', [], Context) ->
    io:format("REq: ~p~n~n", [get_params()]),
    {json, [{status, "ok"}], Context}.


%% internal shit
reply_to_messages(_Token, []) ->
    ok;
reply_to_messages(Token, [Update | Updates]) ->
    case Update of
        [{<<"update_id">>, _UpdateId}, {<<"message">>, [_TheId, From, _Chat, _Date, TextData]}] ->
            {<<"from">>, [{<<"id">>, ReplyToId}, {<<"first_name">>, ReplyToName} | _]} = From,
            case TextData of
                {<<"text">>, <<"/start">>} ->
                    Message = lists:flatten(io_lib:format("Hello ~s, howdy?", [binary_to_list(ReplyToName)])),
                    etelegram:send_message(Token, ReplyToId, Message);
                _ ->
                    io:format("Boo ~p~n", [TextData])
            end;
        SomethingElse ->
            io:format("Not sure what to do, skip: ~p~n", [SomethingElse])
    end,
    reply_to_messages(Token, Updates).



get_params() ->
    %% Nasty technique helps reducing syntax errors highlighted in code.
    Req:params().
