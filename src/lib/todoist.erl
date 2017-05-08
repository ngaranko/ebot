-module(todoist).
-export([get_access_token_url/1, get_access_token_url/2, get_access_token_url/3]).
-export([login/2, sync/1]).
-define(TODOIST_URL, "https://todoist.com/").
-define(TODOIST_API_URL, "https://todoist.com/API/v7/").

get_access_token_url(ClientId) ->
    get_access_token_url(ClientId, "data:read").

get_access_token_url(ClientId, Scope) ->
    get_access_token_url(ClientId, Scope, "Test").

get_access_token_url(ClientId, Scope, State) ->
    Url = lists:concat([?TODOIST_URL, "oauth/authorize"]),
    Params = [{client_id, ClientId}, {scope, Scope}, {state, State}],
    Url.

login(Email, Password) ->
    Url = lists:concat([?TODOIST_API_URL, "user/login"]),
    Payload = [{email, Email}, {password, Password}],
    Response = restc:request(post, percent, Url, [], [], Payload),
    io:format("YEAH, response!~n~n~p~n~n", [Response]),
    Response.

sync(Token) ->
    Url = lists:concat([?TODOIST_API_URL, "sync"]),
    Params = [{token, Token}],
    Response = restc:request(post, percent, Url, [], [], Params),
    io:format("YEAH, sync response!~n~n~p~n~n", [Response]),
    Response.
