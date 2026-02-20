# uuidv8_test

[![Package Version](https://img.shields.io/hexpm/v/uuidv8_test)](https://hex.pm/packages/uuidv8_test)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/uuidv8_test/)

```sh
gleam add uuidv8@1
```

Create your module that generates the identifiers that you need:

```gleam
import gleam/bit_array.{base16_encode}
import uuidv8.{random_v8}

pub fn random_uuid_v8_hex() -> String {
  base16_encode(random_v8())
}
```

Further UUID versions can be found at <https://hexdocs.pm/uuidv8>.

## Development & Test

```sh
gleam test
```
