defmodule UUIDV8ShimTest do
  use ExUnit.Case
  import Base, only: [encode16: 1]
  doctest UUIDV8Shim

  @var 0b10

  test "max UUID" do
    assert UUIDV8Shim.max() == <<0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF::128>>
  end

  test "nil UUID" do
    assert UUIDV8Shim.nill() == <<0::128>>
  end

  test "random_v4" do
    assert <<_::48, 4::4, _::12, @var::2, _::62>> = UUIDV8Shim.random_v4()
  end

  test "random_v4 encoded as Hexadecimal digits" do
    uuid = UUIDV8Shim.random_v4()
    assert String.match?(encode16(uuid), ~r/^[[:xdigit:]]{32}$/)
  end

  test "random_v7" do
    assert <<_::48, 7::4, _::12, @var::2, _::62>> = UUIDV8Shim.random_v7()
  end

  test "random_v8" do
    assert <<_::48, 8::4, _::12, @var::2, _::62>> = UUIDV8Shim.random_v8()
  end

  test "uuid_v6" do
    assert <<_::48, 6::4, _::12, @var::2, _::62>> = UUIDV8Shim.uuid_v6()
  end

end
