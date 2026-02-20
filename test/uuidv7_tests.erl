-module(uuidv7_tests).
-include_lib("eunit/include/eunit.hrl").



random_v7_test() ->
    assert_valid_uuid_v7(generate_v7()).


random_v7_uniqueness_test() ->
    U1 = generate_v7(),
    U2 = generate_v7(),
    ?assertNotEqual(U1, U2).   

    

%% https://www.rfc-editor.org/rfc/rfc9562.html#name-example-of-a-uuidv7-value
uuidv7_minimum_test() ->
    ?assert(generate_v7() > "017f22e2-79b0-7cc3-98c4-dc0c0c07398f").



random_uuid_v7_have_similar_prefix_test() ->
    U1 = generate_v7(),
    U2 = generate_v7(),
    Prefix1 = binary:part(U1, 0, 10),
    Prefix2 = binary:part(U2, 0, 10),
    Score = string:jaro_similarity(Prefix1, Prefix2),
    ?assert(Score > 0.95).



generate_v7() ->
    uuidv8:common_format(uuidv8:random_v7()).



assert_valid_uuid_v7(U) ->
    Regex = "^[0-9a-f]{8}-[0-9a-f]{4}-7[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$",
    ?assertMatch({match, _}, re:run(U, Regex, [unicode])).



%% Entropy 
hamming_distance(<<Bin1:128>>, <<Bin2:128>>) ->
    Diff = Bin1 bxor Bin2,
    count_set_bits(Diff).

count_set_bits(0) -> 0;
count_set_bits(N) ->
    (N band 1) + count_set_bits(N bsr 1).