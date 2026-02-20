-module(uuid_tests).
-include_lib("eunit/include/eunit.hrl").

nil_uuid_test() ->
    ?assertEqual(<<"00000000-0000-0000-0000-000000000000">>, uuidv8:common_format(uuidv8:nil())).

max_uuid_test() ->
    ?assertEqual(<<"ffffffff-ffff-ffff-ffff-ffffffffffff">>, uuidv8:common_format(uuidv8:max())).
