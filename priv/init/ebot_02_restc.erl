-module(ebot_02_restc).
-export([init/0, stop/1]).


init() ->
    application:start(inets),
    application:start(asn1),
    application:start(ssl),
    application:start(public_key),
    application:start(idna),
    application:start(mimerl),
    application:start(certifi),
    application:start(ssl_verify_fun),
    application:start(metrics),
    application:start(hackney),
    hackney:start(),
    io:format("~nALL DONE~n"),
    ok.

stop(ListOfWatchIDs) ->
    lists:map(fun boss_news:cancel_watch/1, ListOfWatchIDs).
