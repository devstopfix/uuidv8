defmodule UUIDV8Shim do
  @moduledoc """
  Shim Erlang functions into Elixir.
  """

  defdelegate max, to: :uuidv8
  defdelegate nill, to: :uuidv8, as: nil
  defdelegate random_v4, to: :uuidv8
  defdelegate random_v7, to: :uuidv8
  defdelegate random_v8, to: :uuidv8
  defdelegate uuid_v6, to: :uuidv8
end
