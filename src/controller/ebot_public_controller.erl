-module(ebot_public_controller, [Req, SessionID]).
-compile(export_all).


index('GET', [], Context) ->
    Resp = etelegram:send_message('162344122', "Wgiasgiagsid!@#"),
    io:format("~n~n~p~n~n", [Resp]),
    {ok, Context};
index('POST', [], Context) ->
    io:format("REq: ~p~n~n", [Req:params()]),
    {json, [{status, "ok"}], Context}.
