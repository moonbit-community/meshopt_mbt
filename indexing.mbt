///|
pub fn generate_vertex_remap_unindexed(
  vertices : Bytes,
  vertex_count : Int,
  vertex_size : Int,
) -> (FixedArray[UInt], Int) raise MeshoptError {
  require(vertex_count >= 0, "vertex count must be non-negative")
  require(vertex_size > 0, "vertex size must be positive")
  require_bytes_length(vertices, vertex_count * vertex_size, "vertices")
  let remap = FixedArray::make(vertex_count, 0U)
  let unique_vertex_count = generate_vertex_remap_unindexed_ffi(
    remap, vertices, vertex_count, vertex_size,
  )
  (remap, unique_vertex_count)
}

///|
pub fn generate_vertex_remap_indexed(
  indices : FixedArray[UInt],
  vertices : Bytes,
  vertex_count : Int,
  vertex_size : Int,
) -> (FixedArray[UInt], Int) raise MeshoptError {
  require(vertex_count >= 0, "vertex count must be non-negative")
  require(vertex_size > 0, "vertex size must be positive")
  require_bytes_length(vertices, vertex_count * vertex_size, "vertices")
  let remap = FixedArray::make(vertex_count, 0U)
  let unique_vertex_count = generate_vertex_remap_indexed_ffi(
    remap,
    indices,
    indices.length(),
    vertices,
    vertex_count,
    vertex_size,
  )
  (remap, unique_vertex_count)
}

///|
pub fn remap_vertex_buffer(
  vertices : Bytes,
  vertex_count : Int,
  vertex_size : Int,
  unique_vertex_count : Int,
  remap : FixedArray[UInt],
) -> Bytes raise MeshoptError {
  require(vertex_count >= 0, "vertex count must be non-negative")
  require(unique_vertex_count >= 0, "unique vertex count must be non-negative")
  require(vertex_size > 0, "vertex size must be positive")
  require_fixedarray_length(remap, vertex_count, "remap")
  require_bytes_length(vertices, vertex_count * vertex_size, "vertices")
  let destination = Bytes::make(unique_vertex_count * vertex_size, 0)
  remap_vertex_buffer_ffi(
    destination, vertices, vertex_count, vertex_size, remap,
  )
  destination
}

///|
pub fn remap_index_buffer_unindexed(
  index_count : Int,
  remap : FixedArray[UInt],
) -> FixedArray[UInt] raise MeshoptError {
  require(index_count >= 0, "index count must be non-negative")
  require_fixedarray_length(remap, index_count, "remap")
  let destination = FixedArray::make(index_count, 0U)
  remap_index_buffer_unindexed_ffi(destination, index_count, remap)
  destination
}

///|
pub fn remap_index_buffer_indexed(
  indices : FixedArray[UInt],
  remap : FixedArray[UInt],
) -> FixedArray[UInt] raise MeshoptError {
  let remap_length = remap.length().reinterpret_as_uint()
  for i in 0..<indices.length() {
    require(
      indices[i] < remap_length,
      "index buffer references a vertex outside the remap table",
    )
  }
  let destination = FixedArray::make(indices.length(), 0U)
  remap_index_buffer_indexed_ffi(destination, indices, indices.length(), remap)
  destination
}
