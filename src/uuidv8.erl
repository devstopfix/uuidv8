-module(uuidv8).
-moduledoc """
Generators of UUID versions 1, 4, 6, 7 & 8 as per REF-9562.

See https://www.rfc-editor.org/rfc/rfc9562.html

## Timestamp considerations 

We use the monotonic time feature of the BEAM to ensure timestamps never
reverse if the system clock is adjusted.

See https://www.rfc-editor.org/rfc/rfc9562.html#name-timestamp-considerations

## Monotonicity and counters

We use the unique integer generation of the BEAM. We do not attempt to reset 
the sequence when the timestamp ticks over, or initialize the sequence with
a random value. Therefore node start times should be staggered to prevent
generating the first UUID in the same time interval, or use a UUID version
that incorporates the (unique) node name.

The sequence may leak how many UUIDs have been generated, of no other part
of your application uses unique_integer/1

The sequence will wrap over when used as a 12 or 14 bit sequence, if this 
happens and the clock does not tick over then two timestamps may be out of
order though a database ORDER BY on a timestamp could be used for ordering. For
62 bit sequences it can be assumed the sequence will be unique during the
runtime of the nodes.

See https://www.rfc-editor.org/rfc/rfc9562.html#name-monotonicity-and-counters
See https://www.erlang.org/docs/20/efficiency_guide/advanced

## Cryptographically secure pseudorandom UUIDs

We use the BEAM's strong_rand_bytes from the crypto module.

See https://www.rfc-editor.org/rfc/rfc9562.html#name-unguessability

## Distributed Generation

> The node id SHOULD NOT be an IEEE 802 MAC 

We use the BEAM's node() name which can be set with 

    $ erl -name "abc456@`hostname`"
    Erlang/OTP 28 [erts-16.2] 

    (abc456@FREDs-MacBook-Air-M1.local)1> node().
    'abc456@FREDs-MacBook-Air-M1.local'

    (abc456@FREDs-MacBook-Air-M1.local)2> erlang:phash2(node(),4294967296).
    76469452

See https://www.rfc-editor.org/rfc/rfc9562.html#name-distributed-uuid-generation

""".


-define(VARIANT, 2#10).   
-define(V1_VERSION, 2#0001). 
-define(V4_VERSION, 2#0100). 
-define(V6_VERSION, 2#0110). 
-define(V7_VERSION, 2#0111). 
-define(V8_VERSION, 2#1000). 

-export([common_format/1, generate_with_format/2, nil/0, max/0, node_tagged_v8/1, uuid_v4/0, uuid_v7/0, uuid_v8_random/0, uuid_v8_tag/1, uuid_v1/0, uuid_v6/0, uuidv8_bits/3]).

-spec generate_with_format(fun(() -> binary()), fun((binary()) -> binary())) -> binary().
generate_with_format(Generator, Formatter) ->
    Formatter(Generator()).

-doc "Lower case, dash-separated, hexadecimal".
-spec common_format(binary()) -> binary().
common_format(<<B1:4/binary, B2:2/binary, B3:2/binary, B4:2/binary, B5:6/binary>>) ->
    H1 = binary:encode_hex(B1, lowercase),
    H2 = binary:encode_hex(B2, lowercase),
    H3 = binary:encode_hex(B3, lowercase),
    H4 = binary:encode_hex(B4, lowercase),
    H5 = binary:encode_hex(B5, lowercase),
    
    <<H1/binary, "-", H2/binary, "-", H3/binary, "-", H4/binary, "-", H5/binary>>.

-doc "Generate the Nil UUID (all zeros)".
-spec nil() -> binary().
nil() ->
    << 
        0:128
    >>.

-doc "Generate the Max UUID".
-spec max() -> binary().
max() ->
    << 
        16#FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF:128
    >>.

-doc "UUID v4 with 122 bits of strong random data".
-spec uuid_v4() -> binary().
uuid_v4() ->    
    << 
        A:48/bitstring, 
        _OldVer:4, 
        B:12/bitstring, 
        _OldVar:2, 
        C:62/bitstring 
    >> = crypto:strong_rand_bytes(16),
    
    << 
        A:48/bitstring, 
        (?V4_VERSION):4, 
        B:12/bitstring, 
        (?VARIANT):2, 
        C:62/bitstring 
    >>.

-doc "UUID v6 with 60 bits of Gregorian time (μs), 14 bits of monotonic sequence, and 48 bits of the BEAMs hashed node name. The sequence does not reset when the time ticks over.".
-spec uuid_v6() -> binary().
uuid_v6() ->
    Timestamp = gregorian_timestamp(),
    <<A:48, B:12>> = <<Timestamp:60>>,
    C = erlang:unique_integer([positive, monotonic]),
    <<D:48, _Rest/bitstring>> = node_long_hash(),

    << 
        A:48, 
        (?V6_VERSION):4, 
        B:12, 
        (?VARIANT):2, 
        C:14,
        D:48
    >>.

-doc "UUID v7 with 48 bits of monotonic UNIX time (ms), 12 bits of monotonic sequence, and 62 bits of strong random data. The sequence does not reset when the time ticks over.".
-spec uuid_v7() -> binary().
uuid_v7() ->
    RandomBytes = crypto:strong_rand_bytes(8),
    
    << 
        _:2, 
        C:62/bitstring 
    >> = RandomBytes,

    A = unix_monotonic_time_ms(),
    B = erlang:unique_integer([positive, monotonic]),
    
    << 
        A:48, 
        (?V7_VERSION):4, 
        B:12, 
        (?VARIANT):2, 
        C:62/bitstring 
    >>.


-doc "UUID v8 with 122 bits of strong random data".
-spec uuid_v8_random() -> binary().
uuid_v8_random() ->
    RandomBytes = crypto:strong_rand_bytes(16),
    
    << 
        A:48/bitstring, 
        _OldVer:4, 
        B:12/bitstring, 
        _OldVar:2, 
        C:62/bitstring 
    >> = RandomBytes,
    
    << 
        A:48/bitstring, 
        (?V8_VERSION):4, 
        B:12/bitstring, 
        (?VARIANT):2, 
        C:62/bitstring 
    >>.

-doc "UUID v8 with 48 bits of monotonic UNIX time (ms), 12 bit tag, and 62 bits of unique sequence".
-spec uuid_v8_tag(pos_integer()) -> binary().
uuid_v8_tag(B) ->
    A = unix_monotonic_time_ms(),
    C = erlang:unique_integer([]),
    
    << 
        A:48, 
        (?V8_VERSION):4, 
        B:12, 
        (?VARIANT):2, 
        C:62 
    >>.

-doc "UUID v8 with 48 bits of monotonic UNIX time (ms), 12 bit tag, 32 bits of BEAM node name, and 30 bits of sequence".
-spec node_tagged_v8(pos_integer()) -> binary().
node_tagged_v8(B) ->
    A = unix_monotonic_time_ms(),
    C = node_short_hash(),
    D = erlang:unique_integer([positive]),
    
    << 
        A:48, 
        (?V8_VERSION):4, 
        B:12, 
        (?VARIANT):2, 
        C:32, 
        D:30 
    >>.


-doc "UUID v6 with 60 bits of Gregorian time (100μs), 14 bits of monotonic sequence, and 48 bits of hashed node name".
-spec uuid_v1() -> bitstring().
uuid_v1() ->
    TS = gregorian_timestamp(),
    <<High:12, Mid:16, Low:32>> = <<TS:60>>,
    ClockSeq = erlang:unique_integer([positive, monotonic]),
    <<NodeID:48, _Rest/bitstring>> = node_long_hash(),

    << 
      Low:32, 
      Mid:16, 
      (?V1_VERSION):4, 
      High:12,             
      (?VARIANT):2, 
      ClockSeq:14,     
      NodeID:48 
    >>.


-doc "Custom UUID v8 generator".
-spec uuidv8_bits(non_neg_integer(), non_neg_integer(), non_neg_integer()) -> bitstring().
uuidv8_bits(A, B, C) ->
    << 
        A:48, 
        (?V8_VERSION):4, 
        B:12, 
        (?VARIANT):2, 
        C:62 
    >>.

node_long_hash() ->
    NodeBin = atom_to_binary(node(), utf8),
    crypto:hash(sha256, NodeBin).

node_short_hash() ->
    erlang:phash2(erlang:node(), 4294967296).


-define(GREGORIAN_OFFSET, 122192928000000000).

gregorian_timestamp() ->
    Nanoseconds = erlang:system_time(nanosecond),
    Nanoseconds100 = Nanoseconds div 100,
    Nanoseconds100 + ?GREGORIAN_OFFSET.

unix_monotonic_time_ms() ->
    erlang:monotonic_time(millisecond) + erlang:time_offset(millisecond).
