defmodule UUIDV8Shim do
  @moduledoc """
  Shim Erlang functions into Elixir.
  """

  defdelegate max, to: :uuidv8
  defdelegate nill, to: :uuidv8, as: nil
  defdelegate uuid_v1, to: :uuidv8
  defdelegate uuid_v4, to: :uuidv8
  defdelegate uuid_v6, to: :uuidv8
  defdelegate uuid_v7, to: :uuidv8
  defdelegate uuid_v8_random, to: :uuidv8
end
