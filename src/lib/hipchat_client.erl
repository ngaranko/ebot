-module(hipchat_client).
-compile(export_all).


% HIPCHAT_API_URL = 'https://api.hipchat.com/v2'

get_access_token(OauthId, OauthSecret) ->
    Payload = [{grant_type, client_credentials}, {scope, send_notification}],
    AuthHeader = [{"Authorization",
                   "Basic " ++ base64:encode_to_string(OauthId ++ ":" ++ OauthSecret)}],
    post_request("https://api.hipchat.com/", "v2/oauth/token", Payload, AuthHeader).

post_request(Host, Url, Params) ->
    post_request(Host, Url, Params, []).

post_request(Host, Url, Params, Headers) ->
    TheUrl = lists:concat([Host, Url]),

    Response = restc:request(post, json,  TheUrl, [], Headers, Params),
    io:format("Yeah, response: ~p~n~n~n", [Response]),
    Response.

% res = requests.post(
%                  '{}/oauth/token'.format(HIPCHAT_API_URL),
%                  data=payload,
%                  auth=(str(installation.oauth_id), installation.oauth_secret)
%                 )
% 
% if res.status_code == 200:
%    token_info = res.json()
%    return token_info.get('access_token', None)
% 
%    return None
