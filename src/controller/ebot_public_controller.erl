-module(ebot_public_controller, [Req, SessionID]).
-compile(export_all).


index('GET', [], Context) ->
    case application:get_env(faceballs, api_token) of
        {ok, Token} ->
            io:format("~nFound token ~p~n", [Token]),
            %% Resp = etelegram:send_message(Token, '162344122', "Wgiasgiagsid!@#"),
            Resp = faceballs:text_message(Token, '1227983120609787', "WASGHASZZA!"),
            %% Resp = etelegram:get_me(Token),
            io:format("~n~n~p~n~n", [Resp]);
        Resp ->
            io:format("Failed to fetch API Token for telegram ~n~p", [Resp])
    end,
    {ok, Context};

index('POST', [], Context) ->
    io:format("REq: ~p~n~n", [Req:params()]),
    {json, [{status, "ok"}], Context}.
