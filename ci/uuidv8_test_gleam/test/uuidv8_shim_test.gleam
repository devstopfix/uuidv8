import gleam/bit_array.{base16_encode}
import gleam/int
import gleam/regexp
import gleam/string
import gleeunit
import uuidv8_shim.{uuid_common_format, uuid_v8_random, uuid_v8_tag}

pub fn main() -> Nil {
  gleeunit.main()
}

pub fn uuid_common_format_test() -> Nil {
  let tag = tag()
  let uuid: String = tag |> uuid_v8_tag() |> uuid_common_format()
  assert_uuid(uuid)
}

pub fn uuid_common_format_contains_tag_test() -> Nil {
  let tag = 0x1ea
  let expected = "-8" <> string.lowercase(int.to_base16(tag)) <> "-"
  let uuid: String = tag |> uuid_v8_tag() |> uuid_common_format()
  assert string.contains(uuid, expected)
}

pub fn uuid_v8_tag_hex_test() -> Nil {
  let tag = tag()
  let uuid = base16_encode(uuid_v8_tag(tag))
  assert_hex_digits(uuid)
}

pub fn uuid_v8_tag_contains_test() -> Nil {
  let tag = tag()
  let uuid = base16_encode(uuid_v8_tag(tag))
  assert string.contains(uuid, int.to_base16(tag))
}

pub fn random_v8_hex_test() -> Nil {
  let uuid = base16_encode(uuid_v8_random())
  assert_hex_digits(uuid)
}

fn assert_hex_digits(s) {
  let assert Ok(re) = regexp.from_string("^[[:xdigit:]]{32}$")
  assert regexp.check(re, s)
}

fn assert_uuid(s) {
  let assert Ok(re) =
    regexp.from_string(
      "^[[:xdigit:]]{8}-[[:xdigit:]]{4}-[[:xdigit:]]{4}-[[:xdigit:]]{4}-[[:xdigit:]]{12}$",
    )
  assert regexp.check(re, s)
}

fn tag() {
  int.random(0xFFF)
}
