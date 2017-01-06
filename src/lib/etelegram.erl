-module(etelegram).
-export([send_message/3, get_me/1, get_updates/1, get_updates/2]).


send_message(Token, Peer, Message) ->
    post_request(Token, "sendMessage",
                 [{chat_id, Peer}, {text, list_to_binary(Message)}]).


get_me(Token) ->
    get_request(Token, "getMe").

get_updates(Token) ->
    get_updates(Token, 0).

get_updates(Token, Offset) ->
    case get_request(Token, "getUpdates") of
        {ok, 200, _Headers, [{<<"ok">>, true}, {<<"result">>, Results}]} ->
            {ok, Results};
        Other ->
            {error, Other}
    end.


%%% Internal


get_request(Token, APIMethod) ->
    get_request(Token, APIMethod, []).

get_request(Token, APIMethod, Params) ->
    NewUrl = lists:concat(["https://api.telegram.org/", "bot", Token, "/", restc:construct_url(APIMethod, Params)]),
    io:format("URL ~p~n~n", [NewUrl]),
    Response = restc:request(get, json, NewUrl, [], [], [], [{ versions, [ 'tlsv1.2' ] }]),
    io:format("Yeah, response: ~p~n~n~n", [Response]),
    Response.


post_request(Token, APIMethod, Params) ->
    Url = lists:concat(["https://api.telegram.org/", "bot", Token, "/", APIMethod]),

    Response = restc:request(post, json,  Url, [], [], Params),
    io:format("Yeah, response: ~p~n~n~n", [Response]),
    Response.
