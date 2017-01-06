-module(fb_tests).

%%%============================================================================
%%% API
%%%============================================================================
-export([start/0]).


start() ->
    test_post_json("/public/fb", [{ok, "test"}], [{<<"status">>, <<"ok">>}]).


%%=========
%% Internal
%%=========
test_post_json(Path, Payload, Expected) ->
    boss_web_test:post_request(
      Path, [], mochiwebutil:urlencode(Payload),
      [fun(Response) ->
               case Response of
                   {200, _Path, _Headers, {struct, Json}} ->
                       case Json of
                           Expected ->
                               {true, "ok"};
                           Unexpected ->
                               {false, lists:flatten(io_lib:format("Got wrong json: ~p", [Unexpected]))}
                       end;
                   Incorrect ->
                       {false, lists:flatten(io_lib:format("Got wrong response: ~p", [Incorrect]))}
               end
       end], []).
