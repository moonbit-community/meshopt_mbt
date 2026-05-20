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
