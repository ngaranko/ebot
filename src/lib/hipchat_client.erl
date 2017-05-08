-module(hipchat_client).
-compile(export_all).
-define(HIPCHAT_API_URL, "https://api.hipchat.com/").


get_access_token(OauthId, OauthSecret) ->
    Payload = [{grant_type, client_credentials}, {scope, send_notification}],
    AuthHeader = [{<<"Authorization">>,
                   erlang:list_to_binary("Basic " ++ base64:encode_to_string(OauthId ++ ":" ++ OauthSecret))}],
    post_request(?HIPCHAT_API_URL, "v2/oauth/token", Payload, AuthHeader).


send_room_notification(Message, RoomId, AuthToken) ->
    post_request(?HIPCHAT_API_URL,
                 "v2/room/" ++ RoomId ++ "/notification?auth_token=" ++ AuthToken,
                 Message).


update_room_glance(Glance, RoomId, AuthToken) ->
    Headers = [{<<"Authorization">>, erlang:list_to_binary("Bearer " ++ AuthToken)}],
    post_request(?HIPCHAT_API_URL,
                 "v2/addon/ui/room/" ++ RoomId,
                 Glance,
                 Headers).


%% Private stuff.

post_request(Host, Url, Params) ->
    post_request(Host, Url, Params, []).

post_request(Host, Url, Params, Headers) ->
    TheUrl = lists:concat([Host, Url]),
    io:format("Headers: ~p~n", [Headers]),

    Response = restc:request(post, json,  TheUrl, [], Headers, Params),
    io:format("Yeah, response: ~p~n~n~n", [Response]),
    Response.
