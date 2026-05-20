///|
pub fn opacity_map_entry_size(
  level : Int,
  states : Int,
) -> Int raise MeshoptError {
  require(level >= 0, "opacity map level must be non-negative")
  require(states == 2 || states == 4, "opacity map states must be 2 or 4")
  opacity_map_entry_size_ffi(level, states)
}

///|
pub fn opacity_map_measure(
  indices : FixedArray[UInt],
  uvs : FixedArray[Float],
  vertex_count : Int,
  uvs_stride : Int,
  texture_width : Int,
  texture_height : Int,
  max_level : Int,
  target_edge : Float,
) -> OpacityMapMeasure raise MeshoptError {
  require_triangle_indices(indices.length())
  require_float_stream(uvs, vertex_count, uvs_stride, 8, "uvs")
  require_texture_size(texture_width, texture_height)
  require(
    max_level >= 0 && max_level <= 12,
    "opacity map max level must be between 0 and 12",
  )
  require(target_edge >= 0.0F, "opacity map target edge must be non-negative")
  let triangle_count = indices.length() / 3
  let levels = Bytes::make(triangle_count, 0)
  let sources = FixedArray::make(triangle_count, 0U)
  let omm_indices = FixedArray::make(triangle_count, 0)
  let int_params : FixedArray[Int] = [
    indices.length(),
    vertex_count,
    uvs_stride,
    texture_width,
    texture_height,
    max_level,
  ]
  let count = opacity_map_measure_ffi(
    levels, sources, omm_indices, indices, uvs, int_params, target_edge,
  )
  { levels, sources, omm_indices, count }
}

///|
pub fn opacity_map_rasterize(
  level : Int,
  states : Int,
  uv0 : FixedArray[Float],
  uv1 : FixedArray[Float],
  uv2 : FixedArray[Float],
  texture_data : Bytes,
  texture_stride : Int,
  texture_pitch : Int,
  texture_width : Int,
  texture_height : Int,
) -> Bytes raise MeshoptError {
  require_fixedarray_length(uv0, 2, "uv0")
  require_fixedarray_length(uv1, 2, "uv1")
  require_fixedarray_length(uv2, 2, "uv2")
  require(
    level >= 0 && level <= 12,
    "opacity map level must be between 0 and 12",
  )
  require(states == 2 || states == 4, "opacity map states must be 2 or 4")
  require_texture_size(texture_width, texture_height)
  require(
    texture_stride >= 1 && texture_stride <= 4,
    "texture stride must be between 1 and 4",
  )
  require(
    texture_pitch >= texture_stride * texture_width,
    "texture pitch must cover a full texture row",
  )
  require(
    texture_data.length() >= texture_pitch * texture_height,
    "texture data is too short",
  )
  let result = Bytes::make(opacity_map_entry_size(level, states), 0)
  let int_params : FixedArray[Int] = [
    level, states, texture_stride, texture_pitch, texture_width, texture_height,
  ]
  opacity_map_rasterize_ffi(result, uv0, uv1, uv2, texture_data, int_params)
  result
}

///|
pub fn opacity_map_compact(
  data : Bytes,
  levels : Bytes,
  offsets : FixedArray[UInt],
  omm_count : Int,
  omm_indices : FixedArray[Int],
  triangle_count : Int,
  states : Int,
) -> Int raise MeshoptError {
  require(omm_count >= 0, "opacity map count must be non-negative")
  require(triangle_count >= 0, "triangle count must be non-negative")
  require(states == 2 || states == 4, "opacity map states must be 2 or 4")
  require_bytes_length(levels, omm_count, "opacity map levels")
  require_fixedarray_length(offsets, omm_count, "opacity map offsets")
  require_fixedarray_length(omm_indices, triangle_count, "opacity map indices")
  opacity_map_compact_ffi(
    data,
    data.length(),
    levels,
    offsets,
    omm_count,
    omm_indices,
    triangle_count,
    states,
  )
}

///|
fn require_texture_size(width : Int, height : Int) -> Unit raise MeshoptError {
  require(
    width >= 1 && width <= 16384,
    "texture width must be between 1 and 16384",
  )
  require(
    height >= 1 && height <= 16384,
    "texture height must be between 1 and 16384",
  )
}
