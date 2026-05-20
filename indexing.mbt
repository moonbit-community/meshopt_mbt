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

///|
pub fn generate_shadow_index_buffer(
  indices : FixedArray[UInt],
  vertices : Bytes,
  vertex_count : Int,
  vertex_size : Int,
  vertex_stride : Int,
) -> FixedArray[UInt] raise MeshoptError {
  require(vertex_count >= 0, "vertex count must be non-negative")
  require(vertex_size > 0, "vertex size must be positive")
  require(
    vertex_stride >= vertex_size,
    "vertex stride must be at least vertex size",
  )
  require_bytes_length(vertices, vertex_count * vertex_stride, "vertices")
  let destination = FixedArray::make(indices.length(), 0U)
  generate_shadow_index_buffer_ffi(
    destination,
    indices,
    indices.length(),
    vertices,
    vertex_count,
    vertex_size,
    vertex_stride,
  )
  destination
}

///|
pub fn generate_position_remap(
  positions : FixedArray[Float],
  vertex_count : Int,
  positions_stride : Int,
) -> FixedArray[UInt] raise MeshoptError {
  require_float_stream(
    positions, vertex_count, positions_stride, 12, "positions",
  )
  let destination = FixedArray::make(vertex_count, 0U)
  generate_position_remap_ffi(
    destination, positions, vertex_count, positions_stride,
  )
  destination
}

///|
pub fn generate_adjacency_index_buffer(
  indices : FixedArray[UInt],
  positions : FixedArray[Float],
  vertex_count : Int,
  positions_stride : Int,
) -> FixedArray[UInt] raise MeshoptError {
  require_triangle_indices(indices.length())
  require_float_stream(
    positions, vertex_count, positions_stride, 12, "positions",
  )
  let destination = FixedArray::make(indices.length() * 2, 0U)
  generate_adjacency_index_buffer_ffi(
    destination,
    indices,
    indices.length(),
    positions,
    vertex_count,
    positions_stride,
  )
  destination
}

///|
pub fn generate_tessellation_index_buffer(
  indices : FixedArray[UInt],
  positions : FixedArray[Float],
  vertex_count : Int,
  positions_stride : Int,
) -> FixedArray[UInt] raise MeshoptError {
  require_triangle_indices(indices.length())
  require_float_stream(
    positions, vertex_count, positions_stride, 12, "positions",
  )
  let destination = FixedArray::make(indices.length() * 4, 0U)
  generate_tessellation_index_buffer_ffi(
    destination,
    indices,
    indices.length(),
    positions,
    vertex_count,
    positions_stride,
  )
  destination
}

///|
pub fn generate_provoking_index_buffer(
  indices : FixedArray[UInt],
  vertex_count : Int,
) -> ProvokingIndexBuffer raise MeshoptError {
  require_triangle_indices(indices.length())
  require(vertex_count >= 0, "vertex count must be non-negative")
  let destination = FixedArray::make(indices.length(), 0U)
  let reorder = FixedArray::make(vertex_count + indices.length() / 3, 0U)
  let reorder_count = generate_provoking_index_buffer_ffi(
    destination,
    reorder,
    indices,
    indices.length(),
    vertex_count,
  )
  { indices: destination, reorder, reorder_count }
}

///|
fn require_packed_streams(
  streams : PackedStreams,
  vertex_count : Int,
) -> Unit raise MeshoptError {
  require(vertex_count >= 0, "vertex count must be non-negative")
  require(
    streams.stream_count > 0 && streams.stream_count <= 16,
    "stream count must be in 1..=16",
  )
  require_fixedarray_length(
    streams.offsets,
    streams.stream_count,
    "stream offsets",
  )
  require_fixedarray_length(streams.sizes, streams.stream_count, "stream sizes")
  require_fixedarray_length(
    streams.strides,
    streams.stream_count,
    "stream strides",
  )
  for i in 0..<streams.stream_count {
    require(streams.offsets[i] >= 0, "stream offset must be non-negative")
    require(streams.sizes[i] > 0, "stream size must be positive")
    require(
      streams.strides[i] >= streams.sizes[i],
      "stream stride must be at least stream size",
    )
    require_bytes_length(
      streams.source,
      streams.offsets[i] + vertex_count * streams.strides[i],
      "packed stream source",
    )
  }
}

///|
pub fn generate_vertex_remap_multi_unindexed(
  streams : PackedStreams,
  vertex_count : Int,
) -> (FixedArray[UInt], Int) raise MeshoptError {
  require_packed_streams(streams, vertex_count)
  let remap = FixedArray::make(vertex_count, 0U)
  let unique_vertex_count = generate_vertex_remap_multi_unindexed_ffi(
    remap,
    streams.source,
    vertex_count,
    streams.offsets,
    streams.sizes,
    streams.strides,
    streams.stream_count,
  )
  (remap, unique_vertex_count)
}

///|
pub fn generate_vertex_remap_multi_indexed(
  indices : FixedArray[UInt],
  streams : PackedStreams,
  vertex_count : Int,
) -> (FixedArray[UInt], Int) raise MeshoptError {
  require_packed_streams(streams, vertex_count)
  let remap = FixedArray::make(vertex_count, 0U)
  let unique_vertex_count = generate_vertex_remap_multi_indexed_ffi(
    remap,
    indices,
    indices.length(),
    streams.source,
    vertex_count,
    streams.offsets,
    streams.sizes,
    streams.strides,
    streams.stream_count,
  )
  (remap, unique_vertex_count)
}

///|
pub fn generate_shadow_index_buffer_multi(
  indices : FixedArray[UInt],
  streams : PackedStreams,
  vertex_count : Int,
) -> FixedArray[UInt] raise MeshoptError {
  require_packed_streams(streams, vertex_count)
  let destination = FixedArray::make(indices.length(), 0U)
  generate_shadow_index_buffer_multi_ffi(
    destination,
    indices,
    indices.length(),
    streams.source,
    vertex_count,
    streams.offsets,
    streams.sizes,
    streams.strides,
    streams.stream_count,
  )
  destination
}

///|
pub fn generate_vertex_remap_custom_no_callback(
  positions : FixedArray[Float],
  vertex_count : Int,
  positions_stride : Int,
) -> (FixedArray[UInt], Int) raise MeshoptError {
  require_float_stream(
    positions, vertex_count, positions_stride, 12, "positions",
  )
  let remap = FixedArray::make(vertex_count, 0U)
  let unique_vertex_count = generate_vertex_remap_custom_no_callback_ffi(
    remap, positions, vertex_count, positions_stride,
  )
  (remap, unique_vertex_count)
}

///|
pub fn generate_vertex_remap_custom(
  indices : FixedArray[UInt],
  positions : FixedArray[Float],
  vertex_count : Int,
  positions_stride : Int,
  callback : (UInt, UInt) -> Bool,
) -> (FixedArray[UInt], Int) raise MeshoptError {
  require_float_stream(
    positions, vertex_count, positions_stride, 12, "positions",
  )
  if indices.length() > 0 {
    let vertex_count_u = vertex_count.reinterpret_as_uint()
    for i in 0..<indices.length() {
      require(
        indices[i] < vertex_count_u,
        "indices reference vertices outside the position stream",
      )
    }
  }
  let remap = FixedArray::make(vertex_count, 0U)
  let unique_vertex_count = generate_vertex_remap_custom_ffi(
    remap,
    indices,
    indices.length(),
    positions,
    vertex_count,
    positions_stride,
    fn(compare, a, b) { if compare(a, b) { 1 } else { 0 } },
    callback,
  )
  (remap, unique_vertex_count)
}
