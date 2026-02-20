-module(uuidv6_tests).

-include_lib("eunit/include/eunit.hrl").

uuid_v6_test() ->
    assert_valid_uuid_v6(generate_v6()).

%% Pairs are different

uuid_v6_uniqueness_test() ->
    U1 = generate_v6(),
    U2 = generate_v6(),
    ?assertNotEqual(U1, U2).

%% https://www.rfc-editor.org/rfc/rfc9562.html#name-example-of-a-uuidv8-value-t
uuidv8_bits_test() ->
    UUID = uuidv8:uuidv8_bits(16#2489E9AD2EE2, 16#E00, 16#00EC932D5F69181C0),
    ?assertEqual(<<"2489e9ad-2ee2-8e00-8ec9-32d5f69181c0">>, uuidv8:common_format(UUID)).

%% https://www.rfc-editor.org/rfc/rfc9562.html#name-example-of-a-uuidv6-value
uuidv6_minimum_test() ->
    ?assert(generate_v6() > "1ec9414c-232a-6b00-b3c8-9f6bdeced846").

%% Generators

generate_v6() ->
    uuidv8:common_format(
        uuidv8:uuid_v6()).

assert_valid_uuid_v6(U) ->
    Regex = "^[0-9a-f]{8}-[0-9a-f]{4}-6[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$",
    ?assertMatch({match, _}, re:run(U, Regex, [unicode])).
