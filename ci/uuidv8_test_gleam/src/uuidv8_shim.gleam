//// Shim to Erlang

@external(erlang, "uuidv8", "uuid_v8_tag")
pub fn uuid_v8_tag(node_id: Int) -> BitArray

@external(erlang, "uuidv8", "uuid_v8_random")
pub fn uuid_v8_random() -> BitArray
