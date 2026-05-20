///|
pub fn optimize_vertex_cache(
  indices : FixedArray[UInt],
  vertex_count : Int,
) -> FixedArray[UInt] raise MeshoptError {
  require_triangle_indices(indices.length())
  require(vertex_count >= 0, "vertex count must be non-negative")
  let destination = FixedArray::make(indices.length(), 0U)
  optimize_vertex_cache_ffi(
    destination,
    indices,
    indices.length(),
    vertex_count,
  )
  destination
}

///|
pub fn optimize_vertex_cache_strip(
  indices : FixedArray[UInt],
  vertex_count : Int,
) -> FixedArray[UInt] raise MeshoptError {
  require_triangle_indices(indices.length())
  require(vertex_count >= 0, "vertex count must be non-negative")
  let destination = FixedArray::make(indices.length(), 0U)
  optimize_vertex_cache_strip_ffi(
    destination,
    indices,
    indices.length(),
    vertex_count,
  )
  destination
}

///|
pub fn optimize_vertex_cache_fifo(
  indices : FixedArray[UInt],
  vertex_count : Int,
  cache_size? : UInt = 16U,
) -> FixedArray[UInt] raise MeshoptError {
  require_triangle_indices(indices.length())
  require(vertex_count >= 0, "vertex count must be non-negative")
  let destination = FixedArray::make(indices.length(), 0U)
  optimize_vertex_cache_fifo_ffi(
    destination,
    indices,
    indices.length(),
    vertex_count,
    cache_size,
  )
  destination
}

///|
pub fn optimize_vertex_fetch_remap(
  indices : FixedArray[UInt],
  vertex_count : Int,
) -> (FixedArray[UInt], Int) raise MeshoptError {
  require(vertex_count >= 0, "vertex count must be non-negative")
  let remap = FixedArray::make(vertex_count, 0U)
  let unique_vertex_count = optimize_vertex_fetch_remap_ffi(
    remap,
    indices,
    indices.length(),
    vertex_count,
  )
  (remap, unique_vertex_count)
}

///|
pub fn optimize_overdraw(
  indices : FixedArray[UInt],
  positions : FixedArray[Float],
  vertex_count : Int,
  positions_stride : Int,
  threshold? : Float = 1.05F,
) -> FixedArray[UInt] raise MeshoptError {
  require_triangle_indices(indices.length())
  require_float_stream(
    positions, vertex_count, positions_stride, 12, "positions",
  )
  let destination = FixedArray::make(indices.length(), 0U)
  optimize_overdraw_ffi(
    destination,
    indices,
    indices.length(),
    positions,
    vertex_count,
    positions_stride,
    threshold,
  )
  destination
}

///|
pub fn optimize_vertex_fetch(
  indices : FixedArray[UInt],
  vertices : Bytes,
  vertex_count : Int,
  vertex_size : Int,
) -> VertexFetchOptimization raise MeshoptError {
  require(vertex_count >= 0, "vertex count must be non-negative")
  require(vertex_size > 0, "vertex size must be positive")
  require_bytes_length(vertices, vertex_count * vertex_size, "vertices")
  let destination_vertices = Bytes::make(vertex_count * vertex_size, 0)
  let destination_indices = FixedArray::make(indices.length(), 0U)
  for i in 0..<indices.length() {
    destination_indices[i] = indices[i]
  }
  let unique_vertex_count = optimize_vertex_fetch_ffi(
    destination_vertices,
    destination_indices,
    indices.length(),
    vertices,
    vertex_count,
    vertex_size,
  )
  {
    vertices: destination_vertices,
    indices: destination_indices,
    unique_vertex_count,
  }
}
