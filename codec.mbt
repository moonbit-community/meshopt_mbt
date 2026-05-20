///|
pub fn encode_index_buffer_bound(
  index_count : Int,
  vertex_count : Int,
) -> Int raise MeshoptError {
  require_triangle_indices(index_count)
  require(vertex_count >= 0, "vertex count must be non-negative")
  encode_index_buffer_bound_ffi(index_count, vertex_count)
}

///|
pub fn encode_index_buffer(
  indices : FixedArray[UInt],
  vertex_count : Int,
) -> MeshoptData raise MeshoptError {
  let bound = encode_index_buffer_bound(indices.length(), vertex_count)
  let buffer = Bytes::make(bound, 0)
  let length = encode_index_buffer_ffi(buffer, bound, indices, indices.length())
  if length == 0 {
    raise MeshoptError("index buffer encoding failed")
  }
  shrink_bytes(buffer, length)
  { data: buffer, length }
}

///|
pub fn decode_index_buffer(
  encoded : Bytes,
  index_count : Int,
) -> FixedArray[UInt] raise MeshoptError {
  require_triangle_indices(index_count)
  let destination = FixedArray::make(index_count, 0U)
  let status = decode_index_buffer_ffi(
    destination,
    index_count,
    encoded,
    encoded.length(),
  )
  if status != 0 {
    raise MeshoptError("index buffer decoding failed")
  }
  destination
}

///|
pub fn encode_vertex_buffer_bound(
  vertex_count : Int,
  vertex_size : Int,
) -> Int raise MeshoptError {
  require(vertex_count >= 0, "vertex count must be non-negative")
  require(vertex_size > 0, "vertex size must be positive")
  encode_vertex_buffer_bound_ffi(vertex_count, vertex_size)
}

///|
pub fn encode_vertex_buffer(
  vertices : Bytes,
  vertex_count : Int,
  vertex_size : Int,
) -> MeshoptData raise MeshoptError {
  require_bytes_length(vertices, vertex_count * vertex_size, "vertices")
  let bound = encode_vertex_buffer_bound(vertex_count, vertex_size)
  let buffer = Bytes::make(bound, 0)
  let length = encode_vertex_buffer_ffi(
    buffer, bound, vertices, vertex_count, vertex_size,
  )
  if length == 0 {
    raise MeshoptError("vertex buffer encoding failed")
  }
  shrink_bytes(buffer, length)
  { data: buffer, length }
}

///|
pub fn decode_vertex_buffer(
  encoded : Bytes,
  vertex_count : Int,
  vertex_size : Int,
) -> Bytes raise MeshoptError {
  require(vertex_count >= 0, "vertex count must be non-negative")
  require(vertex_size > 0, "vertex size must be positive")
  let destination = Bytes::make(vertex_count * vertex_size, 0)
  let status = decode_vertex_buffer_ffi(
    destination,
    vertex_count,
    vertex_size,
    encoded,
    encoded.length(),
  )
  if status != 0 {
    raise MeshoptError("vertex buffer decoding failed")
  }
  destination
}
