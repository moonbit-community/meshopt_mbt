///|
#borrow(bytes)
extern "c" fn shrink_bytes(bytes : Bytes, length : Int) = "moonbit_meshopt_shrink_bytes"

///|
extern "c" fn quantize_half_ffi(value : Float) -> UInt = "moonbit_meshopt_quantize_half"

///|
extern "c" fn dequantize_half_ffi(value : UInt) -> Float = "moonbit_meshopt_dequantize_half"

///|
extern "c" fn quantize_unorm_ffi(value : Float, bits : Int) -> Int = "moonbit_meshopt_quantize_unorm"

///|
extern "c" fn quantize_snorm_ffi(value : Float, bits : Int) -> Int = "moonbit_meshopt_quantize_snorm"

///|
extern "c" fn quantize_float_ffi(value : Float, bits : Int) -> Float = "moonbit_meshopt_quantize_float"

///|
#borrow(destination, vertices)
extern "c" fn generate_vertex_remap_unindexed_ffi(
  destination : FixedArray[UInt],
  vertices : Bytes,
  vertex_count : Int,
  vertex_size : Int,
) -> Int = "moonbit_meshopt_generate_vertex_remap_unindexed"

///|
#borrow(destination, indices, vertices)
extern "c" fn generate_vertex_remap_indexed_ffi(
  destination : FixedArray[UInt],
  indices : FixedArray[UInt],
  index_count : Int,
  vertices : Bytes,
  vertex_count : Int,
  vertex_size : Int,
) -> Int = "moonbit_meshopt_generate_vertex_remap_indexed"

///|
#borrow(destination, vertices, remap)
extern "c" fn remap_vertex_buffer_ffi(
  destination : Bytes,
  vertices : Bytes,
  vertex_count : Int,
  vertex_size : Int,
  remap : FixedArray[UInt],
) = "moonbit_meshopt_remap_vertex_buffer"

///|
#borrow(destination, remap)
extern "c" fn remap_index_buffer_unindexed_ffi(
  destination : FixedArray[UInt],
  index_count : Int,
  remap : FixedArray[UInt],
) = "moonbit_meshopt_remap_index_buffer_unindexed"

///|
#borrow(destination, indices, remap)
extern "c" fn remap_index_buffer_indexed_ffi(
  destination : FixedArray[UInt],
  indices : FixedArray[UInt],
  index_count : Int,
  remap : FixedArray[UInt],
) = "moonbit_meshopt_remap_index_buffer_indexed"

///|
#borrow(destination, indices)
extern "c" fn optimize_vertex_cache_ffi(
  destination : FixedArray[UInt],
  indices : FixedArray[UInt],
  index_count : Int,
  vertex_count : Int,
) = "moonbit_meshopt_optimize_vertex_cache"

///|
#borrow(destination, indices)
extern "c" fn optimize_vertex_cache_strip_ffi(
  destination : FixedArray[UInt],
  indices : FixedArray[UInt],
  index_count : Int,
  vertex_count : Int,
) = "moonbit_meshopt_optimize_vertex_cache_strip"

///|
#borrow(destination, indices)
extern "c" fn optimize_vertex_cache_fifo_ffi(
  destination : FixedArray[UInt],
  indices : FixedArray[UInt],
  index_count : Int,
  vertex_count : Int,
  cache_size : UInt,
) = "moonbit_meshopt_optimize_vertex_cache_fifo"

///|
#borrow(destination, indices)
extern "c" fn optimize_vertex_fetch_remap_ffi(
  destination : FixedArray[UInt],
  indices : FixedArray[UInt],
  index_count : Int,
  vertex_count : Int,
) -> Int = "moonbit_meshopt_optimize_vertex_fetch_remap"

///|
extern "c" fn encode_index_buffer_bound_ffi(
  index_count : Int,
  vertex_count : Int,
) -> Int = "moonbit_meshopt_encode_index_buffer_bound"

///|
#borrow(buffer, indices)
extern "c" fn encode_index_buffer_ffi(
  buffer : Bytes,
  buffer_size : Int,
  indices : FixedArray[UInt],
  index_count : Int,
) -> Int = "moonbit_meshopt_encode_index_buffer"

///|
#borrow(destination, buffer)
extern "c" fn decode_index_buffer_ffi(
  destination : FixedArray[UInt],
  index_count : Int,
  buffer : Bytes,
  buffer_size : Int,
) -> Int = "moonbit_meshopt_decode_index_buffer_u32"

///|
#borrow(destination, buffer)
extern "c" fn decode_index_buffer_bytes_ffi(
  destination : Bytes,
  index_count : Int,
  index_size : Int,
  buffer : Bytes,
  buffer_size : Int,
) -> Int = "moonbit_meshopt_decode_index_buffer_bytes"

///|
extern "c" fn encode_vertex_buffer_bound_ffi(
  vertex_count : Int,
  vertex_size : Int,
) -> Int = "moonbit_meshopt_encode_vertex_buffer_bound"

///|
#borrow(buffer, vertices)
extern "c" fn encode_vertex_buffer_ffi(
  buffer : Bytes,
  buffer_size : Int,
  vertices : Bytes,
  vertex_count : Int,
  vertex_size : Int,
) -> Int = "moonbit_meshopt_encode_vertex_buffer"

///|
#borrow(destination, buffer)
extern "c" fn decode_vertex_buffer_ffi(
  destination : Bytes,
  vertex_count : Int,
  vertex_size : Int,
  buffer : Bytes,
  buffer_size : Int,
) -> Int = "moonbit_meshopt_decode_vertex_buffer"

///|
#borrow(uint_stats, float_stats, indices)
extern "c" fn analyze_vertex_cache_ffi(
  uint_stats : FixedArray[UInt],
  float_stats : FixedArray[Float],
  indices : FixedArray[UInt],
  index_count : Int,
  vertex_count : Int,
  cache_size : UInt,
  warp_size : UInt,
  primgroup_size : UInt,
) = "moonbit_meshopt_analyze_vertex_cache"

///|
#borrow(uint_stats, float_stats, indices)
extern "c" fn analyze_vertex_fetch_ffi(
  uint_stats : FixedArray[UInt],
  float_stats : FixedArray[Float],
  indices : FixedArray[UInt],
  index_count : Int,
  vertex_count : Int,
  vertex_size : Int,
) = "moonbit_meshopt_analyze_vertex_fetch"

///|
#borrow(destination, indices, vertices)
extern "c" fn generate_shadow_index_buffer_ffi(
  destination : FixedArray[UInt],
  indices : FixedArray[UInt],
  index_count : Int,
  vertices : Bytes,
  vertex_count : Int,
  vertex_size : Int,
  vertex_stride : Int,
) = "moonbit_meshopt_generate_shadow_index_buffer"

///|
#borrow(destination, positions)
extern "c" fn generate_position_remap_ffi(
  destination : FixedArray[UInt],
  positions : FixedArray[Float],
  vertex_count : Int,
  positions_stride : Int,
) = "moonbit_meshopt_generate_position_remap"

///|
#borrow(destination, indices, positions)
extern "c" fn generate_adjacency_index_buffer_ffi(
  destination : FixedArray[UInt],
  indices : FixedArray[UInt],
  index_count : Int,
  positions : FixedArray[Float],
  vertex_count : Int,
  positions_stride : Int,
) = "moonbit_meshopt_generate_adjacency_index_buffer"

///|
#borrow(destination, indices, positions)
extern "c" fn generate_tessellation_index_buffer_ffi(
  destination : FixedArray[UInt],
  indices : FixedArray[UInt],
  index_count : Int,
  positions : FixedArray[Float],
  vertex_count : Int,
  positions_stride : Int,
) = "moonbit_meshopt_generate_tessellation_index_buffer"

///|
#borrow(destination, reorder, indices)
extern "c" fn generate_provoking_index_buffer_ffi(
  destination : FixedArray[UInt],
  reorder : FixedArray[UInt],
  indices : FixedArray[UInt],
  index_count : Int,
  vertex_count : Int,
) -> Int = "moonbit_meshopt_generate_provoking_index_buffer"

///|
#borrow(destination, indices, positions)
extern "c" fn optimize_overdraw_ffi(
  destination : FixedArray[UInt],
  indices : FixedArray[UInt],
  index_count : Int,
  positions : FixedArray[Float],
  vertex_count : Int,
  positions_stride : Int,
  threshold : Float,
) = "moonbit_meshopt_optimize_overdraw"

///|
#borrow(destination, indices, vertices)
extern "c" fn optimize_vertex_fetch_ffi(
  destination : Bytes,
  indices : FixedArray[UInt],
  index_count : Int,
  vertices : Bytes,
  vertex_count : Int,
  vertex_size : Int,
) -> Int = "moonbit_meshopt_optimize_vertex_fetch"

///|
extern "c" fn encode_index_version_ffi(version : Int) = "meshopt_encodeIndexVersion"

///|
#borrow(buffer)
extern "c" fn decode_index_version_ffi(
  buffer : Bytes,
  buffer_size : Int,
) -> Int = "moonbit_meshopt_decode_index_version"

///|
extern "c" fn encode_index_sequence_bound_ffi(
  index_count : Int,
  vertex_count : Int,
) -> Int = "moonbit_meshopt_encode_index_sequence_bound"

///|
#borrow(buffer, indices)
extern "c" fn encode_index_sequence_ffi(
  buffer : Bytes,
  buffer_size : Int,
  indices : FixedArray[UInt],
  index_count : Int,
) -> Int = "moonbit_meshopt_encode_index_sequence"

///|
#borrow(destination, buffer)
extern "c" fn decode_index_sequence_ffi(
  destination : FixedArray[UInt],
  index_count : Int,
  buffer : Bytes,
  buffer_size : Int,
) -> Int = "moonbit_meshopt_decode_index_sequence_u32"

///|
#borrow(destination, buffer)
extern "c" fn decode_index_sequence_bytes_ffi(
  destination : Bytes,
  index_count : Int,
  index_size : Int,
  buffer : Bytes,
  buffer_size : Int,
) -> Int = "moonbit_meshopt_decode_index_sequence_bytes"

///|
extern "c" fn encode_vertex_version_ffi(version : Int) = "meshopt_encodeVertexVersion"

///|
#borrow(buffer)
extern "c" fn decode_vertex_version_ffi(
  buffer : Bytes,
  buffer_size : Int,
) -> Int = "moonbit_meshopt_decode_vertex_version"

///|
#borrow(buffer, vertices)
extern "c" fn encode_vertex_buffer_level_ffi(
  buffer : Bytes,
  buffer_size : Int,
  vertices : Bytes,
  vertex_count : Int,
  vertex_size : Int,
  level : Int,
  version : Int,
) -> Int = "moonbit_meshopt_encode_vertex_buffer_level"

///|
#borrow(buffer)
extern "c" fn decode_filter_oct_ffi(buffer : Bytes, count : Int, stride : Int) = "moonbit_meshopt_decode_filter_oct"

///|
#borrow(buffer)
extern "c" fn decode_filter_quat_ffi(buffer : Bytes, count : Int, stride : Int) = "moonbit_meshopt_decode_filter_quat"

///|
#borrow(buffer)
extern "c" fn decode_filter_exp_ffi(buffer : Bytes, count : Int, stride : Int) = "moonbit_meshopt_decode_filter_exp"

///|
#borrow(buffer)
extern "c" fn decode_filter_color_ffi(
  buffer : Bytes,
  count : Int,
  stride : Int,
) = "moonbit_meshopt_decode_filter_color"

///|
#borrow(destination, data)
extern "c" fn encode_filter_oct_ffi(
  destination : Bytes,
  count : Int,
  stride : Int,
  bits : Int,
  data : FixedArray[Float],
) = "moonbit_meshopt_encode_filter_oct"

///|
#borrow(destination, data)
extern "c" fn encode_filter_quat_ffi(
  destination : Bytes,
  count : Int,
  stride : Int,
  bits : Int,
  data : FixedArray[Float],
) = "moonbit_meshopt_encode_filter_quat"

///|
#borrow(destination, data)
extern "c" fn encode_filter_exp_ffi(
  destination : Bytes,
  count : Int,
  stride : Int,
  bits : Int,
  data : FixedArray[Float],
  mode : Int,
) = "moonbit_meshopt_encode_filter_exp"

///|
#borrow(destination, data)
extern "c" fn encode_filter_color_ffi(
  destination : Bytes,
  count : Int,
  stride : Int,
  bits : Int,
  data : FixedArray[Float],
) = "moonbit_meshopt_encode_filter_color"

///|
#borrow(destination, indices)
extern "c" fn stripify_ffi(
  destination : FixedArray[UInt],
  indices : FixedArray[UInt],
  index_count : Int,
  vertex_count : Int,
  restart_index : UInt,
) -> Int = "moonbit_meshopt_stripify"

///|
extern "c" fn stripify_bound_ffi(index_count : Int) -> Int = "moonbit_meshopt_stripify_bound"

///|
#borrow(destination, indices)
extern "c" fn unstripify_ffi(
  destination : FixedArray[UInt],
  indices : FixedArray[UInt],
  index_count : Int,
  restart_index : UInt,
) -> Int = "moonbit_meshopt_unstripify"

///|
extern "c" fn unstripify_bound_ffi(index_count : Int) -> Int = "moonbit_meshopt_unstripify_bound"

///|
#borrow(uint_stats, float_stats, indices, positions)
extern "c" fn analyze_overdraw_ffi(
  uint_stats : FixedArray[UInt],
  float_stats : FixedArray[Float],
  indices : FixedArray[UInt],
  index_count : Int,
  positions : FixedArray[Float],
  vertex_count : Int,
  positions_stride : Int,
) = "moonbit_meshopt_analyze_overdraw"

///|
#borrow(float_stats, indices, positions)
extern "c" fn analyze_coverage_ffi(
  float_stats : FixedArray[Float],
  indices : FixedArray[UInt],
  index_count : Int,
  positions : FixedArray[Float],
  vertex_count : Int,
  positions_stride : Int,
) = "moonbit_meshopt_analyze_coverage"

///|
#borrow(destination, result_error, indices, positions)
extern "c" fn simplify_ffi(
  destination : FixedArray[UInt],
  result_error : FixedArray[Float],
  indices : FixedArray[UInt],
  index_count : Int,
  positions : FixedArray[Float],
  vertex_count : Int,
  positions_stride : Int,
  target_index_count : Int,
  target_error : Float,
  options : UInt,
) -> Int = "moonbit_meshopt_simplify"

///|
#borrow(destination, result_error, indices, positions, attributes, weights, vertex_lock)
extern "c" fn simplify_with_attributes_ffi(
  destination : FixedArray[UInt],
  result_error : FixedArray[Float],
  indices : FixedArray[UInt],
  index_count : Int,
  positions : FixedArray[Float],
  vertex_count : Int,
  positions_stride : Int,
  attributes : FixedArray[Float],
  attributes_stride : Int,
  weights : FixedArray[Float],
  attribute_count : Int,
  vertex_lock : Bytes,
  vertex_lock_length : Int,
  target_index_count : Int,
  target_error : Float,
  options : UInt,
) -> Int = "moonbit_meshopt_simplify_with_attributes"

///|
#borrow(indices, result_error, positions, attributes, weights, vertex_lock, int_params)
extern "c" fn simplify_with_update_ffi(
  indices : FixedArray[UInt],
  result_error : FixedArray[Float],
  positions : FixedArray[Float],
  attributes : FixedArray[Float],
  weights : FixedArray[Float],
  vertex_lock : Bytes,
  vertex_lock_length : Int,
  int_params : FixedArray[Int],
  target_error : Float,
  options : UInt,
) -> Int = "moonbit_meshopt_simplify_with_update"

///|
#borrow(destination, result_error, indices, positions, vertex_lock)
extern "c" fn simplify_sloppy_ffi(
  destination : FixedArray[UInt],
  result_error : FixedArray[Float],
  indices : FixedArray[UInt],
  index_count : Int,
  positions : FixedArray[Float],
  vertex_count : Int,
  positions_stride : Int,
  vertex_lock : Bytes,
  vertex_lock_length : Int,
  target_index_count : Int,
  target_error : Float,
) -> Int = "moonbit_meshopt_simplify_sloppy"

///|
#borrow(destination, indices, positions)
extern "c" fn simplify_prune_ffi(
  destination : FixedArray[UInt],
  indices : FixedArray[UInt],
  index_count : Int,
  positions : FixedArray[Float],
  vertex_count : Int,
  positions_stride : Int,
  target_error : Float,
) -> Int = "moonbit_meshopt_simplify_prune"

///|
#borrow(destination, positions, colors)
extern "c" fn simplify_points_ffi(
  destination : FixedArray[UInt],
  positions : FixedArray[Float],
  vertex_count : Int,
  positions_stride : Int,
  colors : FixedArray[Float],
  colors_stride : Int,
  color_weight : Float,
  target_vertex_count : Int,
) -> Int = "moonbit_meshopt_simplify_points"

///|
#borrow(positions)
extern "c" fn simplify_scale_ffi(
  positions : FixedArray[Float],
  vertex_count : Int,
  positions_stride : Int,
) -> Float = "moonbit_meshopt_simplify_scale"

///|
extern "c" fn build_meshlets_bound_ffi(
  index_count : Int,
  max_vertices : Int,
  max_triangles : Int,
) -> Int = "moonbit_meshopt_build_meshlets_bound"

///|
#borrow(meshlets, meshlet_vertices, meshlet_triangles, indices, positions, int_params, float_params)
extern "c" fn build_meshlets_ffi(
  meshlets : FixedArray[UInt],
  meshlet_vertices : FixedArray[UInt],
  meshlet_triangles : Bytes,
  indices : FixedArray[UInt],
  positions : FixedArray[Float],
  int_params : FixedArray[Int],
  float_params : FixedArray[Float],
) -> Int = "moonbit_meshopt_build_meshlets"

///|
#borrow(meshlets, meshlet_vertices, meshlet_triangles, indices)
extern "c" fn build_meshlets_scan_ffi(
  meshlets : FixedArray[UInt],
  meshlet_vertices : FixedArray[UInt],
  meshlet_triangles : Bytes,
  indices : FixedArray[UInt],
  index_count : Int,
  vertex_count : Int,
  max_vertices : Int,
  max_triangles : Int,
) -> Int = "moonbit_meshopt_build_meshlets_scan"

///|
#borrow(meshlet_vertices, meshlet_triangles)
extern "c" fn optimize_meshlet_ffi(
  meshlet_vertices : FixedArray[UInt],
  meshlet_triangles : Bytes,
  triangle_count : Int,
  vertex_count : Int,
) = "moonbit_meshopt_optimize_meshlet"

///|
#borrow(float_values, int_values, indices, positions)
extern "c" fn compute_cluster_bounds_ffi(
  float_values : FixedArray[Float],
  int_values : FixedArray[Int],
  indices : FixedArray[UInt],
  index_count : Int,
  positions : FixedArray[Float],
  vertex_count : Int,
  positions_stride : Int,
) = "moonbit_meshopt_compute_cluster_bounds"

///|
#borrow(float_values, int_values, meshlet_vertices, meshlet_triangles, positions)
extern "c" fn compute_meshlet_bounds_ffi(
  float_values : FixedArray[Float],
  int_values : FixedArray[Int],
  meshlet_vertices : FixedArray[UInt],
  meshlet_triangles : Bytes,
  triangle_count : Int,
  positions : FixedArray[Float],
  vertex_count : Int,
  positions_stride : Int,
) = "moonbit_meshopt_compute_meshlet_bounds"

///|
#borrow(float_values, int_values, positions, radii)
extern "c" fn compute_sphere_bounds_ffi(
  float_values : FixedArray[Float],
  int_values : FixedArray[Int],
  positions : FixedArray[Float],
  count : Int,
  positions_stride : Int,
  radii : FixedArray[Float],
  radii_stride : Int,
  radii_count : Int,
) = "moonbit_meshopt_compute_sphere_bounds"

///|
#borrow(destination, positions)
extern "c" fn spatial_sort_remap_ffi(
  destination : FixedArray[UInt],
  positions : FixedArray[Float],
  vertex_count : Int,
  positions_stride : Int,
) = "moonbit_meshopt_spatial_sort_remap"

///|
#borrow(destination, indices, positions)
extern "c" fn spatial_sort_triangles_ffi(
  destination : FixedArray[UInt],
  indices : FixedArray[UInt],
  index_count : Int,
  positions : FixedArray[Float],
  vertex_count : Int,
  positions_stride : Int,
) = "moonbit_meshopt_spatial_sort_triangles"

///|
#borrow(destination, positions)
extern "c" fn spatial_cluster_points_ffi(
  destination : FixedArray[UInt],
  positions : FixedArray[Float],
  vertex_count : Int,
  positions_stride : Int,
  cluster_size : Int,
) = "moonbit_meshopt_spatial_cluster_points"

///|
#borrow(result, indices, positions, normals, uvs)
extern "c" fn generate_tangents_ffi(
  result : FixedArray[Float],
  indices : FixedArray[UInt],
  index_count : Int,
  positions : FixedArray[Float],
  vertex_count : Int,
  positions_stride : Int,
  normals : FixedArray[Float],
  normals_stride : Int,
  uvs : FixedArray[Float],
  uvs_stride : Int,
  options : UInt,
) = "moonbit_meshopt_generate_tangents"

///|
#borrow(minv, maxv)
extern "c" fn compute_position_exponent_ffi(
  minv : FixedArray[Float],
  maxv : FixedArray[Float],
  min_exp : Int,
  max_bits : Int,
) -> Int = "moonbit_meshopt_compute_position_exponent"

///|
#borrow(destination, source, offsets, sizes, strides)
extern "c" fn generate_vertex_remap_multi_unindexed_ffi(
  destination : FixedArray[UInt],
  source : Bytes,
  vertex_count : Int,
  offsets : FixedArray[Int],
  sizes : FixedArray[Int],
  strides : FixedArray[Int],
  stream_count : Int,
) -> Int = "moonbit_meshopt_generate_vertex_remap_multi_unindexed"

///|
#borrow(destination, indices, source, offsets, sizes, strides)
extern "c" fn generate_vertex_remap_multi_indexed_ffi(
  destination : FixedArray[UInt],
  indices : FixedArray[UInt],
  index_count : Int,
  source : Bytes,
  vertex_count : Int,
  offsets : FixedArray[Int],
  sizes : FixedArray[Int],
  strides : FixedArray[Int],
  stream_count : Int,
) -> Int = "moonbit_meshopt_generate_vertex_remap_multi_indexed"

///|
#borrow(destination, indices, source, offsets, sizes, strides)
extern "c" fn generate_shadow_index_buffer_multi_ffi(
  destination : FixedArray[UInt],
  indices : FixedArray[UInt],
  index_count : Int,
  source : Bytes,
  vertex_count : Int,
  offsets : FixedArray[Int],
  sizes : FixedArray[Int],
  strides : FixedArray[Int],
  stream_count : Int,
) = "moonbit_meshopt_generate_shadow_index_buffer_multi"

///|
#borrow(destination, positions)
extern "c" fn generate_vertex_remap_custom_no_callback_ffi(
  destination : FixedArray[UInt],
  positions : FixedArray[Float],
  vertex_count : Int,
  positions_stride : Int,
) -> Int = "moonbit_meshopt_generate_vertex_remap_custom_no_callback"

///|
extern "c" fn encode_meshlet_bound_ffi(
  max_vertices : Int,
  max_triangles : Int,
) -> Int = "moonbit_meshopt_encode_meshlet_bound"

///|
#borrow(buffer, vertices, triangles)
extern "c" fn encode_meshlet_ffi(
  buffer : Bytes,
  buffer_size : Int,
  vertices : FixedArray[UInt],
  vertex_count : Int,
  triangles : Bytes,
  triangle_count : Int,
) -> Int = "moonbit_meshopt_encode_meshlet"

///|
#borrow(vertices, triangles, buffer)
extern "c" fn decode_meshlet_raw_ffi(
  vertices : FixedArray[UInt],
  vertex_count : Int,
  triangles : FixedArray[UInt],
  triangle_count : Int,
  buffer : Bytes,
  buffer_size : Int,
) -> Int = "moonbit_meshopt_decode_meshlet_raw"

///|
#borrow(vertices, triangles, buffer)
extern "c" fn decode_meshlet_ffi(
  vertices : Bytes,
  vertex_count : Int,
  vertex_size : Int,
  triangles : Bytes,
  triangle_count : Int,
  triangle_size : Int,
  buffer : Bytes,
  buffer_size : Int,
) -> Int = "moonbit_meshopt_decode_meshlet"

///|
#borrow(meshlets, meshlet_vertices, meshlet_triangles, indices, positions, int_params, float_params)
extern "c" fn build_meshlets_flex_ffi(
  meshlets : FixedArray[UInt],
  meshlet_vertices : FixedArray[UInt],
  meshlet_triangles : Bytes,
  indices : FixedArray[UInt],
  positions : FixedArray[Float],
  int_params : FixedArray[Int],
  float_params : FixedArray[Float],
) -> Int = "moonbit_meshopt_build_meshlets_flex"

///|
#borrow(meshlets, meshlet_vertices, meshlet_triangles, indices, positions, int_params, float_params)
extern "c" fn build_meshlets_spatial_ffi(
  meshlets : FixedArray[UInt],
  meshlet_vertices : FixedArray[UInt],
  meshlet_triangles : Bytes,
  indices : FixedArray[UInt],
  positions : FixedArray[Float],
  int_params : FixedArray[Int],
  float_params : FixedArray[Float],
) -> Int = "moonbit_meshopt_build_meshlets_spatial"

///|
#borrow(meshlet_vertices, meshlet_triangles)
extern "c" fn optimize_meshlet_level_ffi(
  meshlet_vertices : FixedArray[UInt],
  vertex_count : Int,
  meshlet_triangles : Bytes,
  triangle_count : Int,
  level : Int,
) = "moonbit_meshopt_optimize_meshlet_level"

///|
#borrow(vertices, triangles, indices)
extern "c" fn extract_meshlet_indices_ffi(
  vertices : FixedArray[UInt],
  triangles : Bytes,
  indices : FixedArray[UInt],
  index_count : Int,
) -> Int = "moonbit_meshopt_extract_meshlet_indices"

///|
#borrow(destination, cluster_indices, cluster_index_counts, positions)
extern "c" fn partition_clusters_ffi(
  destination : FixedArray[UInt],
  cluster_indices : FixedArray[UInt],
  total_index_count : Int,
  cluster_index_counts : FixedArray[UInt],
  cluster_count : Int,
  positions : FixedArray[Float],
  vertex_count : Int,
  positions_stride : Int,
  target_partition_size : Int,
) -> Int = "moonbit_meshopt_partition_clusters"

///|
#borrow(levels, sources, omm_indices, indices, uvs, int_params)
extern "c" fn opacity_map_measure_ffi(
  levels : Bytes,
  sources : FixedArray[UInt],
  omm_indices : FixedArray[Int],
  indices : FixedArray[UInt],
  uvs : FixedArray[Float],
  int_params : FixedArray[Int],
  target_edge : Float,
) -> Int = "moonbit_meshopt_opacity_map_measure"

///|
#borrow(result, uv0, uv1, uv2, texture_data, int_params)
extern "c" fn opacity_map_rasterize_ffi(
  result : Bytes,
  uv0 : FixedArray[Float],
  uv1 : FixedArray[Float],
  uv2 : FixedArray[Float],
  texture_data : Bytes,
  int_params : FixedArray[Int],
) = "moonbit_meshopt_opacity_map_rasterize"

///|
extern "c" fn opacity_map_entry_size_ffi(level : Int, states : Int) -> Int = "moonbit_meshopt_opacity_map_entry_size"

///|
#borrow(data, levels, offsets, omm_indices)
extern "c" fn opacity_map_compact_ffi(
  data : Bytes,
  data_size : Int,
  levels : Bytes,
  offsets : FixedArray[UInt],
  omm_count : Int,
  omm_indices : FixedArray[Int],
  triangle_count : Int,
  states : Int,
) -> Int = "moonbit_meshopt_opacity_map_compact"
