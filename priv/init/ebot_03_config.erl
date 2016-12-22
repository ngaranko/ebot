-module(ebot_03_config).
-export([init/0]).
-define(CONFIG_LOCAL_FILE, "boss.local.config").

init() ->
    case file:consult(?CONFIG_LOCAL_FILE) of
        {ok, [Config]}  -> config(Config);
        {error, enoent} -> ok
    end.


config(Config) ->
    true = lists:all(fun app_config/1, Config),
    ok.

app_config({App, Config}) ->
    %lists:all(fun({Par, Val}) -> app_config_set_env(App, Par, Val) end, Config).
    io:format("App: ~p~n", [App]),
    io:format("Conf: ~p~n", [Config]).

app_config_set_env(App, Par, Val) ->
    application:set_env(App, Par, Val),
    true.
