import gleam/bit_array.{base16_encode}
import gleam/int
import gleam/regexp
import gleeunit
import uuidv8_shim.{node_tagged_v8, uuid_v8_random}

pub fn main() -> Nil {
  gleeunit.main()
}

pub fn node_tagged_v8_hex_test() -> Nil {
  let tag = int.random(0xFFF)
  let uuid = base16_encode(node_tagged_v8(tag))
  assert_hex_digits(uuid)
}

pub fn random_v8_hex_test() -> Nil {
  let uuid = base16_encode(uuid_v8_random())
  assert_hex_digits(uuid)
}

fn assert_hex_digits(s) {
  let assert Ok(re) = regexp.from_string("^[[:xdigit:]]{32}$")
  assert regexp.check(re, s)
}
