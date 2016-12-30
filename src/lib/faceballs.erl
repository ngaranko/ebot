-module(faceballs).
-compile(export_all).


text_message(Access_Token, Recipient, Text) ->
    %% Send simple text message to FB recipient.
    Message = [{recipient, [{id, Recipient}]}, {message, [{text, list_to_binary(Text)}]}],
    send_message(Access_Token, Message).

send_message(Access_Token, Message) ->
    %% Send message via faceballs api.
    Url = restc:construct_url("https://graph.facebook.com/", "v2.6/me/messages", [{access_token, Access_Token}]),

    restc:request(post, json,  Url, [], [], Message).
