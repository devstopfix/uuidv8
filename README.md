# UUIDv8

BEAM library for generating UUID versions 1, 4, 6, 7 and 8.

Core Erlang libraries have functions for secure random data, unique integer 
sequences, and distributed node names.

Given these functions are so simple it is possible to just copy/paste the few
required into your code rather than including this library.


## Build

    $ rebar3 compile

## Test

    $ rebar3 eunit

## Erlang

Generate a hexadecimal tagged UUID:

```erlang
UUID = binary:encode_hex(uuidv8:node_tagged_v8(16#81D))
```

## Elixir integration

Generate a hexadecimal UUID from Elixir:

```elixir
defmodule YourApp.Identifiers do
    import Base, only: [encode16: 1]
    defdelegate random_v8, to: :uuidv8

    def random_uuidv8_hex, do: encode16(random_v8())
end
```

## Gleam integration

Generate a hexadecimal UUID from Gleam:

```gleam
import gleam/bit_array.{base16_encode}

pub fn random_uuid_v8_hex() -> String {
    base16_encode(random_v8())
}

@external(erlang, "uuidv8", "random_v8")
pub fn random_v8() -> BitArray
```

# UUID Versions

## UUID v1

[UUIDv1][v1] is a time-based UUID featuring a 60-bit timestamp represented by 
Coordinated Universal Time (UTC) as a count of 100-nanosecond intervals 
since 1582-10-15T00:00:00.00Z. Not recommended, surpassed by [UUIDv6][v6].

Contains:
* 60 bits of timestamp (low bits first, not good for database indexing)
* 14 bits of monotonic integers
* 48 bits of node identifier (hash of BEAM node name)

```bash
./gen_uuid v1 4 
9cc76c44-0e93-11f1-8001-d6659d452b34
9cc839cb-0e93-11f1-8002-d6659d452b34
9cc83f02-0e93-11f1-8003-d6659d452b34
9cc84400-0e93-11f1-8004-d6659d452b34
```

## UUID v4

[UUIDv4][v4] is meant for generating UUIDs from truly random or pseudorandom numbers.

Contains 122 bits of strong random bytes:

```bash
$ ./gen_uuid v4 2
9f33f7a7-b066-476c-8b82-6f9968d59e62
c30f8a24-96e7-4a56-8c46-f62488ae81fe
```

## UUID v6

[UUIDv6][v6] is a field-compatible version of UUIDv1, reordered for improved 
DB locality. It is expected that UUIDv6 will primarily be implemented in 
contexts where UUIDv1 is used. Systems that do not involve legacy UUIDv1 
SHOULD use UUIDv7 instead.

Contains:
* 60 bits of Gregorian monotonic timestamp (in microseconds)
* 14 bits of monotonic integers
* 48 bits of node identifier (hash of BEAM node name)

```bash
$ ./gen_uuid v6 16384
0e328083-bf10-65ff-8001-d6659d452b34
0e328083-bf11-6901-8002-d6659d452b34
0e328083-bf11-6947-8003-d6659d452b34
0e328083-bf11-69ad-8004-d6659d452b34
...
0e328083-e406-6968-bffd-d6659d452b34
0e328083-e406-6973-bffe-d6659d452b34
0e328083-e406-697e-bfff-d6659d452b34
0e328083-e406-6989-8000-d6659d452b34
```

## UUID v7

[UUIDv7][v7] features a time-ordered value field derived from the widely implemented and well-known Unix Epoch timestamp source, the number of milliseconds since midnight 1 Jan 1970 UTC, leap seconds excluded. Generally, UUIDv7 has improved entropy characteristics over UUIDv1.

Contains:
* 48 bits of monotonic UNIX timestamp
* 12 bits of monotonic unique integers
* 62 bits of strong random data

```bash
$ ./gen_uuid v7 4096
019c67db-6ef1-7001-abf4-7a13df92d388
019c67db-6ef1-7002-a744-5f1591749501
019c67db-6ef1-7003-b986-3d3035f199fa
...
019c67db-f691-7ffe-9335-b46d9c4cb789
019c67db-f691-7fff-af33-7e92e4441864
019c67db-f691-7000-b45c-31a2fce9aa3d
```

## UUID v8

[UUIDv8][v8] provides a format for experimental or vendor-specific use cases

### UUID v8 random

Contains 122 bits of strong random bytes:

```bash
$ ./gen_uuid v8 2          
578b3a94-6484-8f9d-8ae3-5337bd88ebfb
018a4bd7-a5f6-88a1-95c4-1bfdaec4c8a1
```

### UUID v8 tagged

Contains:
* 48 bits of monotonic UNIX timestamp
* 12 bits of tag (3 hexadecimal digits)
* 62 bits of monotonic unique integers

```bash
$ ./gen_uuid v8 "0xD0C" 65536
019c6845-ba73-8d0c-b800-000000000025
019c6845-ba73-8d0c-b800-000000000045
019c6845-ba73-8d0c-b800-000000000065
019c6845-ba73-8d0c-b800-000000000085     
...     
019c6845-ba80-8d0c-b800-000000001fa5
019c6845-ba80-8d0c-b800-000000001fc5
019c6845-ba80-8d0c-b800-000000001fe5
019c6845-ba80-8d0c-b800-000000002005
...
019c6849-dd85-8d0c-b800-000000200401
019c6849-dd85-8d0c-b800-000000200421
019c6849-dd85-8d0c-b800-000000200441
019c6849-dd85-8d0c-b800-000000200461
```

### UUID v8 node tagged

Contains:
* 48 bits of monotonic UNIX timestamp
* 12 bits of tag (3 hexadecimal digits)
* 32 bits of node identifier (hash of BEAM node name)
* 30 bits of monotonic unique integers

```bash
$ ./gen_uuid v8node "0xD8D" 65536 | tail
019c7c93-117d-8d8d-817c-a96500000466
019c7c93-117d-8d8d-817c-a96500000486
019c7c93-117d-8d8d-817c-a965000004a6
019c7c93-117d-8d8d-817c-a965000004c6
...
019c7c93-21ec-8d8d-817c-a965001e65a2
019c7c93-21ec-8d8d-817c-a965001e65c2
019c7c93-21ec-8d8d-817c-a965001e65e2
019c7c93-21ec-8d8d-817c-a965001e6602
```

[v1]: https://www.rfc-editor.org/rfc/rfc9562.html#name-uuid-version-1
[v4]: https://www.rfc-editor.org/rfc/rfc9562.html#name-uuid-version-4
[v6]: https://www.rfc-editor.org/rfc/rfc9562.html#name-uuid-version-6
[v7]: https://www.rfc-editor.org/rfc/rfc9562.html#name-uuid-version-7
[v8]: https://www.rfc-editor.org/rfc/rfc9562.html#name-uuid-version-8