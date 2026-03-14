//// Shim to Erlang

@external(erlang, "uuidv8", "node_tagged_v8")
pub fn node_tagged_v8(node_id: Int) -> BitArray

@external(erlang, "uuidv8", "uuid_v8_random")
pub fn uuid_v8_random() -> BitArray
