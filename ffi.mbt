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
