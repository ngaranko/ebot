-module(faceballs_tests).
-include_lib("eunit/include/eunit.hrl").

%%%============================================================================
%%% API
%%%============================================================================

suite_test_()->
    Suite =
    {foreach, local,
      fun setup/0,
      tests()
     },
    Suite.

tests() ->
    [
     {"Checks if empty entries result in list",
      ?_test(check_empty_entries())},
     {"Validations of first_name & last_name",
      ?_test(check_one_entry())}
    ].

check_empty_entries() ->
    Payload = [
               {<<"object">>, <<"page">>},
               {<<"entry">>, []}
              ],
    ?assertEqual([], fb_parse:get_entries(Payload)).


check_one_entry() ->
    Payload = [{<<"object">>, <<"page">>},
               {<<"entry">>, [[{<<"id">>, <<"PAGE_ID">>},
                               {<<"time">>, <<"1458692752478">>},
                               {<<"messaging">>, [[{<<"timestamp">>, <<"1481742969278">>},
                                                   {<<"message">>, [{<<"text">>, <<"/all">>},
                                                                    {<<"mid">>, <<"mid.1481742969278:cdb3627819">>},
                                                                    {<<"seq">>, <<"229">>}
                                                                   ]},
                                                   {<<"recipient">>, [{<<"id">>, <<"1562484253967232">>}
                                                                     ]},
                                                   {<<"sender">>, [{<<"id">>, <<"1227983120609787">>}]}
                                                  ]]}
                              ]]}
              ],

    Expected = [
                {<<"id">>, <<"PAGE_ID">>},
                {<<"time">>, <<"1458692752478">>},
                {<<"messaging">>, [[{<<"timestamp">>, <<"1481742969278">>},
                                    {<<"message">>, [{<<"text">>, <<"/all">>},
                                                     {<<"mid">>, <<"mid.1481742969278:cdb3627819">>},
                                                     {<<"seq">>, <<"229">>}
                                                    ]},
                                    {<<"recipient">>, [{<<"id">>, <<"1562484253967232">>}
                                                      ]},
                                    {<<"sender">>, [{<<"id">>, <<"1227983120609787">>}]}
                                   ]]}
               ],

    ?assertEqual([Expected], fb_parse:get_entries(Payload)).


%% ===================================================================
%% Internal functions
%% ===================================================================

%%--------------------------------------------------------------------
%% @doc Setup each test set
%%--------------------------------------------------------------------
setup()->
    ok.
