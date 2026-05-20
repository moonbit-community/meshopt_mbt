///|
pub fn spatial_sort_remap(
  positions : FixedArray[Float],
  vertex_count : Int,
  positions_stride : Int,
) -> FixedArray[UInt] raise MeshoptError {
  require_float_stream(
    positions, vertex_count, positions_stride, 12, "positions",
  )
  let destination = FixedArray::make(vertex_count, 0U)
  spatial_sort_remap_ffi(destination, positions, vertex_count, positions_stride)
  destination
}

///|
pub fn spatial_sort_triangles(
  indices : FixedArray[UInt],
  positions : FixedArray[Float],
  vertex_count : Int,
  positions_stride : Int,
) -> FixedArray[UInt] raise MeshoptError {
  require_triangle_indices(indices.length())
  require_float_stream(
    positions, vertex_count, positions_stride, 12, "positions",
  )
  let destination = FixedArray::make(indices.length(), 0U)
  spatial_sort_triangles_ffi(
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
pub fn spatial_cluster_points(
  positions : FixedArray[Float],
  vertex_count : Int,
  positions_stride : Int,
  cluster_size : Int,
) -> FixedArray[UInt] raise MeshoptError {
  require_float_stream(
    positions, vertex_count, positions_stride, 12, "positions",
  )
  require(cluster_size > 0, "cluster size must be positive")
  let destination = FixedArray::make(vertex_count, 0U)
  spatial_cluster_points_ffi(
    destination, positions, vertex_count, positions_stride, cluster_size,
  )
  destination
}

///|
pub fn generate_tangents(
  indices : FixedArray[UInt],
  positions : FixedArray[Float],
  vertex_count : Int,
  positions_stride : Int,
  normals : FixedArray[Float],
  normals_stride : Int,
  uvs : FixedArray[Float],
  uvs_stride : Int,
  options? : TangentOptions = TangentOptions::new(),
) -> FixedArray[Float] raise MeshoptError {
  require_triangle_indices(indices.length())
  require_float_stream(
    positions, vertex_count, positions_stride, 12, "positions",
  )
  require_float_stream(normals, vertex_count, normals_stride, 12, "normals")
  require_float_stream(uvs, vertex_count, uvs_stride, 8, "uvs")
  let result = FixedArray::make(indices.length() * 4, 0.0F)
  generate_tangents_ffi(
    result,
    indices,
    indices.length(),
    positions,
    vertex_count,
    positions_stride,
    normals,
    normals_stride,
    uvs,
    uvs_stride,
    options.bits(),
  )
  result
}

///|
pub fn compute_position_exponent(
  minv : FixedArray[Float],
  maxv : FixedArray[Float],
  min_exp : Int,
  max_bits : Int,
) -> Int raise MeshoptError {
  require_fixedarray_length(minv, 3, "minimum bounds")
  require_fixedarray_length(maxv, 3, "maximum bounds")
  require(max_bits > 0, "max bits must be positive")
  compute_position_exponent_ffi(minv, maxv, min_exp, max_bits)
}

///|
pub fn partition_clusters(
  cluster_indices : FixedArray[UInt],
  cluster_index_counts : FixedArray[UInt],
  positions : FixedArray[Float],
  vertex_count : Int,
  positions_stride : Int,
  target_partition_size : Int,
) -> (FixedArray[UInt], Int) raise MeshoptError {
  require(
    cluster_indices.length() >= 0,
    "cluster index count must be non-negative",
  )
  require_float_stream(
    positions, vertex_count, positions_stride, 12, "positions",
  )
  require(target_partition_size > 0, "target partition size must be positive")
  let destination = FixedArray::make(cluster_index_counts.length(), 0U)
  let count = partition_clusters_ffi(
    destination,
    cluster_indices,
    cluster_indices.length(),
    cluster_index_counts,
    cluster_index_counts.length(),
    positions,
    vertex_count,
    positions_stride,
    target_partition_size,
  )
  (destination, count)
}
