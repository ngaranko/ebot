-module(etelegram).
-compile(export_all).


send_message(Token, Peer, Message) ->
    post_request(Token, "sendMessage",
                 [{chat_id, Peer}, {text, list_to_binary(Message)}]).


get_me(Token) ->
    get_request(Token, "getMe").

get_updates(Token) ->
    get_request(Token, "getUpdates").

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
