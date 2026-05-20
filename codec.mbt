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
pub fn decode_index_buffer_bytes(
  encoded : Bytes,
  index_count : Int,
  index_size : Int,
) -> Bytes raise MeshoptError {
  require_triangle_indices(index_count)
  require_index_size(index_size)
  let destination = Bytes::make(index_count * index_size, 0)
  let status = decode_index_buffer_bytes_ffi(
    destination,
    index_count,
    index_size,
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

///|
pub fn encode_index_version(version : Int) -> Unit raise MeshoptError {
  require(version == 0 || version == 1, "index encoder version must be 0 or 1")
  encode_index_version_ffi(version)
}

///|
pub fn decode_index_version(encoded : Bytes) -> Int {
  decode_index_version_ffi(encoded, encoded.length())
}

///|
pub fn encode_index_sequence_bound(
  index_count : Int,
  vertex_count : Int,
) -> Int raise MeshoptError {
  require(index_count >= 0, "index count must be non-negative")
  require(vertex_count >= 0, "vertex count must be non-negative")
  encode_index_sequence_bound_ffi(index_count, vertex_count)
}

///|
pub fn encode_index_sequence(
  indices : FixedArray[UInt],
  vertex_count : Int,
) -> MeshoptData raise MeshoptError {
  let bound = encode_index_sequence_bound(indices.length(), vertex_count)
  let buffer = Bytes::make(bound, 0)
  let length = encode_index_sequence_ffi(
    buffer,
    bound,
    indices,
    indices.length(),
  )
  if length == 0 {
    raise MeshoptError("index sequence encoding failed")
  }
  shrink_bytes(buffer, length)
  { data: buffer, length }
}

///|
pub fn decode_index_sequence(
  encoded : Bytes,
  index_count : Int,
) -> FixedArray[UInt] raise MeshoptError {
  require(index_count >= 0, "index count must be non-negative")
  let destination = FixedArray::make(index_count, 0U)
  let status = decode_index_sequence_ffi(
    destination,
    index_count,
    encoded,
    encoded.length(),
  )
  if status != 0 {
    raise MeshoptError("index sequence decoding failed")
  }
  destination
}

///|
pub fn decode_index_sequence_bytes(
  encoded : Bytes,
  index_count : Int,
  index_size : Int,
) -> Bytes raise MeshoptError {
  require(index_count >= 0, "index count must be non-negative")
  require_index_size(index_size)
  let destination = Bytes::make(index_count * index_size, 0)
  let status = decode_index_sequence_bytes_ffi(
    destination,
    index_count,
    index_size,
    encoded,
    encoded.length(),
  )
  if status != 0 {
    raise MeshoptError("index sequence decoding failed")
  }
  destination
}

///|
pub fn encode_vertex_version(version : Int) -> Unit raise MeshoptError {
  require(version == 0 || version == 1, "vertex encoder version must be 0 or 1")
  encode_vertex_version_ffi(version)
}

///|
pub fn decode_vertex_version(encoded : Bytes) -> Int {
  decode_vertex_version_ffi(encoded, encoded.length())
}

///|
pub fn encode_vertex_buffer_level(
  vertices : Bytes,
  vertex_count : Int,
  vertex_size : Int,
  level : Int,
  version : Int,
) -> MeshoptData raise MeshoptError {
  require(level >= 0 && level <= 3, "vertex encoder level must be in 0..=3")
  require(version == 0 || version == 1, "vertex encoder version must be 0 or 1")
  require_bytes_length(vertices, vertex_count * vertex_size, "vertices")
  let bound = encode_vertex_buffer_bound(vertex_count, vertex_size)
  let buffer = Bytes::make(bound, 0)
  let length = encode_vertex_buffer_level_ffi(
    buffer, bound, vertices, vertex_count, vertex_size, level, version,
  )
  if length == 0 {
    raise MeshoptError("vertex buffer encoding failed")
  }
  shrink_bytes(buffer, length)
  { data: buffer, length }
}

///|
fn require_index_size(index_size : Int) -> Unit raise MeshoptError {
  require(index_size == 2 || index_size == 4, "index size must be 2 or 4 bytes")
}
