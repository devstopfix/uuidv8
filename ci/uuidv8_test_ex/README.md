# UUIDV8

BEAM library for generating UUID versions 4, 6, 7 and 8. 

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `uuidv8` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:uuidv8, "~> 1.0.0"}
  ]
end
```

## Usage

Create a module in your app that generates the identifiers you need:

```elixir
defmodule YourApp.Identifiers do
    import Base, only: [encode16: 1]
    defdelegate random_v8, to: :uuidv8

    def random_uuidv8_hex, do: encode16(random_v8())
end
```


Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/uuidv8_test_ex>.

