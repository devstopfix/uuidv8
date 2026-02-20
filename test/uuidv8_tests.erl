-module(uuidv8_tests).
-include_lib("eunit/include/eunit.hrl").



random_v8_common_format_test() ->
    assert_valid_uuid_v8(generate_v8_random()).

tagged_v8_common_format_test() ->
    Generator = generate_v8_tagged(),
    assert_valid_uuid_v8(Generator()).

tagged_v8_contains_tag_test() ->
    Tag = rand:uniform(16#FFF),
    ExpectedHex = io_lib:format("~3.16.0B", [Tag]),
    UUID = binary:encode_hex(uuidv8:tagged_v8(Tag)),
    ?assertNotEqual(string:find(UUID, ExpectedHex), nomatch).


random_v8_tagged_uniqueness_test() ->
    assert_distinct_pair(generate_v8_tagged()).

random_v8_uniqueness_test() ->
    assert_distinct_pair(fun generate_v8_random/0).

%% https://www.rfc-editor.org/rfc/rfc9562.html#name-example-of-a-uuidv8-value-t
uuidv8_bits_test() ->
    UUID = uuidv8:uuidv8_bits(16#2489E9AD2EE2, 16#E00,  16#00EC932D5F69181C0),
    ?assertEqual(<<"2489e9ad-2ee2-8e00-8ec9-32d5f69181c0">>, uuidv8:common_format(UUID)).



%% https://www.rfc-editor.org/rfc/rfc9562.html#name-example-of-a-uuidv8-value-t
uuidv8_tagged_minimum_test() ->
    ?assert(generate_v8_tagged() > "2489e9ad-2ee2-8e00-8ec9-32d5f69181c0").

%% Characteristics



%% Half the bits should differ in two random v8 UUIDs
random_v8_entropy_test() ->
    U1 = uuidv8:random_v8(),
    U2 = uuidv8:random_v8(),
    Distance = hamming_distance(U1, U2),
    ?assert (Distance > 40),
    ?assert (Distance < 88).




generate_v8_random() ->
    uuidv8:common_format(uuidv8:random_v8()).

generate_v8_tagged() ->
    Tag = rand:uniform(16#FFF),
    fun () -> uuidv8:common_format(uuidv8:tagged_v8(Tag)) end.

%% Assertion helpers

assert_distinct_pair(Generator) ->
    U1 = Generator(),
    U2 = Generator(),
    ?assertNotEqual(U1, U2).


assert_valid_uuid_v8(U) ->
    Regex = "^[0-9a-f]{8}-[0-9a-f]{4}-8[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$",
    ?assertMatch({match, _}, re:run(U, Regex, [unicode])).


%% Entropy 
hamming_distance(<<Bin1:128>>, <<Bin2:128>>) ->
    Diff = Bin1 bxor Bin2,
    count_set_bits(Diff).

count_set_bits(0) -> 0;
count_set_bits(N) ->
    (N band 1) + count_set_bits(N bsr 1).