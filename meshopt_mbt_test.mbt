///|
test "quantization helpers" {
  assert_eq(@meshopt_mbt.version, 1010)
  assert_eq(@meshopt_mbt.quantize_half(1.0F), 15360U)
  assert_eq(@meshopt_mbt.dequantize_half(15360U), 1.0F)
  assert_eq(try! @meshopt_mbt.quantize_unorm(1.0F, 8), 255)
  assert_eq(try! @meshopt_mbt.quantize_snorm(-1.0F, 8), -127)
}

///|
test "unindexed vertex remap compacts duplicate byte vertices" {
  let vertices = Bytes::makei(4, i => {
    match i {
      0 => b'\x01'
      1 => b'\x02'
      2 => b'\x01'
      _ => b'\x03'
    }
  })
  let (remap, unique_count) = try! @meshopt_mbt.generate_vertex_remap_unindexed(
    vertices, 4, 1,
  )
  assert_eq(unique_count, 3)
  assert_true(remap == [0U, 1U, 0U, 2U])
  assert_true(
    try! (@meshopt_mbt.remap_index_buffer_unindexed(4, remap) ==
    [0U, 1U, 0U, 2U]),
  )
  assert_eq(
    try! @meshopt_mbt.remap_vertex_buffer(vertices, 4, 1, unique_count, remap),
    Bytes::makei(3, i => (i + 1).to_byte()),
  )
}

///|
test "index buffer codec round-trips u32 indices" {
  let indices : FixedArray[UInt] = [0U, 1U, 2U, 2U, 1U, 3U]
  let encoded = try! @meshopt_mbt.encode_index_buffer(indices, 4)
  assert_true(encoded.length > 0)
  assert_true(encoded.data.length() == encoded.length)
  let decoded = try! @meshopt_mbt.decode_index_buffer(
    encoded.data,
    indices.length(),
  )
  assert_true(decoded == indices)
}

///|
test "vertex buffer codec round-trips bytes" {
  let vertices = Bytes::makei(16, i => (i * 7 + 3).to_byte())
  let encoded = try! @meshopt_mbt.encode_vertex_buffer(vertices, 4, 4)
  assert_true(encoded.length > 0)
  assert_true(encoded.data.length() == encoded.length)
  let decoded = try! @meshopt_mbt.decode_vertex_buffer(encoded.data, 4, 4)
  assert_eq(decoded, vertices)
}

///|
test "optimization and analysis expose stable validity properties" {
  let indices : FixedArray[UInt] = [0U, 1U, 2U, 2U, 1U, 3U]
  let optimized = try! @meshopt_mbt.optimize_vertex_cache(indices, 4)
  assert_eq(optimized.length(), indices.length())
  let (fetch_remap, unique_vertices) = try! @meshopt_mbt.optimize_vertex_fetch_remap(
    optimized, 4,
  )
  assert_eq(fetch_remap.length(), 4)
  assert_eq(unique_vertices, 4)

  let cache_stats = try! @meshopt_mbt.analyze_vertex_cache(optimized, 4)
  assert_true(cache_stats.vertices_transformed >= 4U)
  assert_true(cache_stats.acmr > 0.0F)

  let fetch_stats = try! @meshopt_mbt.analyze_vertex_fetch(optimized, 4, 4)
  assert_true(fetch_stats.bytes_fetched >= 16U)
  assert_true(fetch_stats.overfetch >= 1.0F)
}
