-module(slack_client).
-compile(export_all).


chat_me_message(Channel, Text, Token) ->
    get_url("https://slack.com/", "api/chat.meMessage", [{channel, Channel}, {text, Text}], Token).

get_url(Host, Url, Token) ->
    the_get_url(Host, Url, [{token, Token}]).

get_url(Host, Url, Params, Token) ->
    the_get_url(Host, Url, Params ++ [{token, Token}]).

the_get_url(Host, Url, Params) ->
    io:format("~n~nParams~p~n~n", [Params]),

    NewUrl = restc:construct_url(Host, Url, Params),
    {ok, _, _, Response} = restc:request(get, NewUrl),
    io:format("~n~n~nRESPONSE:~p~n~n~n", [Response]),
    {ok, Response}.
