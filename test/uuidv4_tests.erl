-module(uuidv4_tests).

-include_lib("eunit/include/eunit.hrl").

random_v4_test() ->
    assert_valid_uuid_v4(generate_v4()).

random_v4_uniqueness_test() ->
    U1 = uuidv8:uuid_v4(),
    U2 = uuidv8:uuid_v4(),
    ?assertNotEqual(U1, U2).

%% Half the bits should differ in two random v4 UUIDs
random_v4_entropy_test() ->
    U1 = uuidv8:uuid_v4(),
    U2 = uuidv8:uuid_v4(),
    Distance = hamming_distance(U1, U2),
    ?assert(Distance > 40),
    ?assert(Distance < 88).

%% Generators

generate_v4() ->
    uuidv8:common_format(
        uuidv8:uuid_v4()).

%% Assertion helpers

assert_valid_uuid_v4(U) ->
    Regex = "^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$",
    ?assertMatch({match, _}, re:run(U, Regex, [unicode])).

%% Entropy
hamming_distance(<<Bin1:128>>, <<Bin2:128>>) ->
    Diff = Bin1 bxor Bin2,
    count_set_bits(Diff).

count_set_bits(0) ->
    0;
count_set_bits(N) ->
    N band 1 + count_set_bits(N bsr 1).
