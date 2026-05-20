///|
pub fn analyze_vertex_cache(
  indices : FixedArray[UInt],
  vertex_count : Int,
  cache_size? : UInt = 16U,
  warp_size? : UInt = 0U,
  primgroup_size? : UInt = 0U,
) -> VertexCacheStatistics raise MeshoptError {
  require_triangle_indices(indices.length())
  require(vertex_count >= 0, "vertex count must be non-negative")
  let uint_stats = FixedArray::make(2, 0U)
  let float_stats = FixedArray::make(2, 0.0F)
  analyze_vertex_cache_ffi(
    uint_stats,
    float_stats,
    indices,
    indices.length(),
    vertex_count,
    cache_size,
    warp_size,
    primgroup_size,
  )
  {
    vertices_transformed: uint_stats[0],
    warps_executed: uint_stats[1],
    acmr: float_stats[0],
    atvr: float_stats[1],
  }
}

///|
pub fn analyze_vertex_fetch(
  indices : FixedArray[UInt],
  vertex_count : Int,
  vertex_size : Int,
) -> VertexFetchStatistics raise MeshoptError {
  require(vertex_count >= 0, "vertex count must be non-negative")
  require(vertex_size > 0, "vertex size must be positive")
  let uint_stats = FixedArray::make(1, 0U)
  let float_stats = FixedArray::make(1, 0.0F)
  analyze_vertex_fetch_ffi(
    uint_stats,
    float_stats,
    indices,
    indices.length(),
    vertex_count,
    vertex_size,
  )
  { bytes_fetched: uint_stats[0], overfetch: float_stats[0] }
}

///|
pub fn analyze_overdraw(
  indices : FixedArray[UInt],
  positions : FixedArray[Float],
  vertex_count : Int,
  positions_stride : Int,
) -> OverdrawStatistics raise MeshoptError {
  require_triangle_indices(indices.length())
  require_float_stream(
    positions, vertex_count, positions_stride, 12, "positions",
  )
  let uint_stats = FixedArray::make(2, 0U)
  let float_stats = FixedArray::make(1, 0.0F)
  analyze_overdraw_ffi(
    uint_stats,
    float_stats,
    indices,
    indices.length(),
    positions,
    vertex_count,
    positions_stride,
  )
  {
    pixels_covered: uint_stats[0],
    pixels_shaded: uint_stats[1],
    overdraw: float_stats[0],
  }
}

///|
pub fn analyze_coverage(
  indices : FixedArray[UInt],
  positions : FixedArray[Float],
  vertex_count : Int,
  positions_stride : Int,
) -> CoverageStatistics raise MeshoptError {
  require_triangle_indices(indices.length())
  require_float_stream(
    positions, vertex_count, positions_stride, 12, "positions",
  )
  let float_stats = FixedArray::make(4, 0.0F)
  analyze_coverage_ffi(
    float_stats,
    indices,
    indices.length(),
    positions,
    vertex_count,
    positions_stride,
  )
  {
    coverage_x: float_stats[0],
    coverage_y: float_stats[1],
    coverage_z: float_stats[2],
    extent: float_stats[3],
  }
}
