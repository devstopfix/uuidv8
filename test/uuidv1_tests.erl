-module(uuidv1_tests).
-include_lib("eunit/include/eunit.hrl").

nil_uuid_test() ->
    ?assertEqual(<<"00000000-0000-0000-0000-000000000000">>, uuidv8:common_format(uuidv8:nil())).

max_uuid_test() ->
    ?assertEqual(<<"ffffffff-ffff-ffff-ffff-ffffffffffff">>, uuidv8:common_format(uuidv8:max())).

v1_test() ->
    assert_valid_uuid_v1(generate_v1()).

v1_distinct_pair_test(Generator) ->
    U1 = generate_v1(),
    U2 = generate_v1(),
    ?assertNotEqual(U1, U2).


%% Generators

generate_v1() ->
    uuidv8:common_format(uuidv8:uuid_v1()).

%% Assertion helpers

assert_valid_uuid_v1(U) ->
    Regex = "^[0-9a-f]{8}-[0-9a-f]{4}-1[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$",
    ?assertMatch({match, _}, re:run(U, Regex, [unicode])).
