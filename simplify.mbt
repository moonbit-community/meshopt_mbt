///|
fn lock_length(vertex_lock : Bytes) -> Int {
  vertex_lock.length()
}

///|
pub fn simplify(
  indices : FixedArray[UInt],
  positions : FixedArray[Float],
  vertex_count : Int,
  positions_stride : Int,
  target_index_count : Int,
  target_error : Float,
  options? : SimplifyOptions = SimplifyOptions::new(),
) -> SimplifyResult raise MeshoptError {
  require_triangle_indices(indices.length())
  require_float_stream(
    positions, vertex_count, positions_stride, 12, "positions",
  )
  require(target_index_count >= 0, "target index count must be non-negative")
  let destination = FixedArray::make(indices.length(), 0U)
  let result_error = FixedArray::make(1, 0.0F)
  let index_count = simplify_ffi(
    destination,
    result_error,
    indices,
    indices.length(),
    positions,
    vertex_count,
    positions_stride,
    target_index_count,
    target_error,
    options.bits(),
  )
  { indices: destination, index_count, error: result_error[0] }
}

///|
pub fn simplify_with_attributes(
  indices : FixedArray[UInt],
  positions : FixedArray[Float],
  vertex_count : Int,
  positions_stride : Int,
  attributes : FixedArray[Float],
  attributes_stride : Int,
  weights : FixedArray[Float],
  attribute_count : Int,
  vertex_lock? : Bytes = Bytes::new(0),
  target_index_count : Int,
  target_error : Float,
  options? : SimplifyOptions = SimplifyOptions::new(),
) -> SimplifyResult raise MeshoptError {
  require_triangle_indices(indices.length())
  require_float_stream(
    positions, vertex_count, positions_stride, 12, "positions",
  )
  require(attribute_count >= 0, "attribute count must be non-negative")
  require(
    attributes_stride >= attribute_count * 4,
    "attribute stride must contain all attributes",
  )
  require(attributes_stride % 4 == 0, "attribute stride must be divisible by 4")
  require_fixedarray_length(
    attributes,
    vertex_count * (attributes_stride / 4),
    "attributes",
  )
  require_fixedarray_length(weights, attribute_count, "attribute weights")
  if vertex_lock.length() > 0 {
    require_bytes_length(vertex_lock, vertex_count, "vertex lock")
  }
  let destination = FixedArray::make(indices.length(), 0U)
  let result_error = FixedArray::make(1, 0.0F)
  let index_count = simplify_with_attributes_ffi(
    destination,
    result_error,
    indices,
    indices.length(),
    positions,
    vertex_count,
    positions_stride,
    attributes,
    attributes_stride,
    weights,
    attribute_count,
    vertex_lock,
    lock_length(vertex_lock),
    target_index_count,
    target_error,
    options.bits(),
  )
  { indices: destination, index_count, error: result_error[0] }
}

///|
pub fn simplify_with_update(
  indices : FixedArray[UInt],
  positions : FixedArray[Float],
  vertex_count : Int,
  positions_stride : Int,
  attributes? : FixedArray[Float] = [],
  attributes_stride? : Int = 0,
  weights? : FixedArray[Float] = [],
  attribute_count? : Int = 0,
  vertex_lock? : Bytes = Bytes::new(0),
  target_index_count : Int,
  target_error : Float,
  options? : SimplifyOptions = SimplifyOptions::new(),
) -> (Int, Float) raise MeshoptError {
  require_triangle_indices(indices.length())
  require_float_stream(
    positions, vertex_count, positions_stride, 12, "positions",
  )
  require(target_index_count >= 0, "target index count must be non-negative")
  require(attribute_count >= 0, "attribute count must be non-negative")
  if attribute_count > 0 {
    require(
      attributes_stride >= attribute_count * 4,
      "attribute stride must contain all attributes",
    )
    require(
      attributes_stride % 4 == 0,
      "attribute stride must be divisible by 4",
    )
    require_fixedarray_length(
      attributes,
      vertex_count * (attributes_stride / 4),
      "attributes",
    )
    require_fixedarray_length(weights, attribute_count, "attribute weights")
  } else {
    require(
      attributes.length() == 0,
      "attributes must be empty when attribute count is zero",
    )
    require(
      weights.length() == 0,
      "attribute weights must be empty when attribute count is zero",
    )
  }
  if vertex_lock.length() > 0 {
    require_bytes_length(vertex_lock, vertex_count, "vertex lock")
  }
  let result_error = FixedArray::make(1, 0.0F)
  let int_params : FixedArray[Int] = [
    indices.length(),
    vertex_count,
    positions_stride,
    attributes_stride,
    attribute_count,
    target_index_count,
  ]
  let index_count = simplify_with_update_ffi(
    indices,
    result_error,
    positions,
    attributes,
    weights,
    vertex_lock,
    lock_length(vertex_lock),
    int_params,
    target_error,
    options.bits(),
  )
  (index_count, result_error[0])
}

///|
pub fn simplify_sloppy(
  indices : FixedArray[UInt],
  positions : FixedArray[Float],
  vertex_count : Int,
  positions_stride : Int,
  vertex_lock? : Bytes = Bytes::new(0),
  target_index_count : Int,
  target_error : Float,
) -> SimplifyResult raise MeshoptError {
  require_triangle_indices(indices.length())
  require_float_stream(
    positions, vertex_count, positions_stride, 12, "positions",
  )
  if vertex_lock.length() > 0 {
    require_bytes_length(vertex_lock, vertex_count, "vertex lock")
  }
  let destination = FixedArray::make(indices.length(), 0U)
  let result_error = FixedArray::make(1, 0.0F)
  let index_count = simplify_sloppy_ffi(
    destination,
    result_error,
    indices,
    indices.length(),
    positions,
    vertex_count,
    positions_stride,
    vertex_lock,
    lock_length(vertex_lock),
    target_index_count,
    target_error,
  )
  { indices: destination, index_count, error: result_error[0] }
}

///|
pub fn simplify_prune(
  indices : FixedArray[UInt],
  positions : FixedArray[Float],
  vertex_count : Int,
  positions_stride : Int,
  target_error : Float,
) -> (FixedArray[UInt], Int) raise MeshoptError {
  require_triangle_indices(indices.length())
  require_float_stream(
    positions, vertex_count, positions_stride, 12, "positions",
  )
  let destination = FixedArray::make(indices.length(), 0U)
  let index_count = simplify_prune_ffi(
    destination,
    indices,
    indices.length(),
    positions,
    vertex_count,
    positions_stride,
    target_error,
  )
  (destination, index_count)
}

///|
pub fn simplify_points(
  positions : FixedArray[Float],
  vertex_count : Int,
  positions_stride : Int,
  target_vertex_count : Int,
  colors? : FixedArray[Float] = [],
  colors_stride? : Int = 0,
  color_weight? : Float = 1.0F,
) -> (FixedArray[UInt], Int) raise MeshoptError {
  require_float_stream(
    positions, vertex_count, positions_stride, 12, "positions",
  )
  require(target_vertex_count >= 0, "target vertex count must be non-negative")
  if colors_stride > 0 {
    require_float_stream(colors, vertex_count, colors_stride, 3, "colors")
  }
  let destination = FixedArray::make(vertex_count, 0U)
  let count = simplify_points_ffi(
    destination, positions, vertex_count, positions_stride, colors, colors_stride,
    color_weight, target_vertex_count,
  )
  (destination, count)
}

///|
pub fn simplify_scale(
  positions : FixedArray[Float],
  vertex_count : Int,
  positions_stride : Int,
) -> Float raise MeshoptError {
  require_float_stream(
    positions, vertex_count, positions_stride, 12, "positions",
  )
  simplify_scale_ffi(positions, vertex_count, positions_stride)
}
