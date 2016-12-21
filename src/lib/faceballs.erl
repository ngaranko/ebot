-module(faceballs).
-compile(export_all).


send_message(Access_Token, Message) ->
    %% Send message via faceballs api.
    Url = restc:construct_url("https://graph.facebook.com/", "v2.6/me/messages", [{access_token, Access_Token}]),

    Response = restc:request(post, json,  Url, [], [], Message),
    Response.
