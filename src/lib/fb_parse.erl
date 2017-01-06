-module(fb_parse).
-compile(export_all).


get_entries([{<<"object">>, <<"page">>},  {<<"entry">>, Entries}]) ->
    Entries;

get_entries(_Data) ->
    [].
