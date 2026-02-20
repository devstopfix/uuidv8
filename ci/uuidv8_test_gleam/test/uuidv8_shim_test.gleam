import gleam/bit_array.{base16_encode}
import gleam/regexp
import gleeunit
import uuidv8_shim.{random_v8}

pub fn main() -> Nil {
  gleeunit.main()
}

pub fn random_v8_hex_test() -> Nil {
  let assert Ok(re) = regexp.from_string("^[[:xdigit:]]{32}$")
  let uuid = base16_encode(random_v8())
  assert regexp.check(re, uuid)
}
