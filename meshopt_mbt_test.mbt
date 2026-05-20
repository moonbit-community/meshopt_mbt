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
  assert_eq(
    (try! @meshopt_mbt.decode_index_buffer_bytes(
      encoded.data,
      indices.length(),
      4,
    )).length(),
    indices.length() * 4,
  )
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

///|
fn sample_indices() -> FixedArray[UInt] {
  [0U, 1U, 2U, 2U, 1U, 3U]
}

///|
fn sample_positions() -> FixedArray[Float] {
  [0.0F, 0.0F, 0.0F, 1.0F, 0.0F, 0.0F, 0.0F, 1.0F, 0.0F, 1.0F, 1.0F, 0.0F]
}

///|
test "index generators and spatial helpers handle a simple quad" {
  let indices = sample_indices()
  let positions = sample_positions()
  assert_eq(
    (try! @meshopt_mbt.generate_position_remap(positions, 4, 12)).length(),
    4,
  )
  assert_eq(
    (try! @meshopt_mbt.generate_adjacency_index_buffer(
      indices, positions, 4, 12,
    )).length(),
    indices.length() * 2,
  )
  assert_eq(
    (try! @meshopt_mbt.generate_tessellation_index_buffer(
      indices, positions, 4, 12,
    )).length(),
    indices.length() * 4,
  )
  let provoking = try! @meshopt_mbt.generate_provoking_index_buffer(indices, 4)
  assert_eq(provoking.indices.length(), indices.length())
  assert_true(provoking.reorder_count > 0)
  assert_eq(
    (try! @meshopt_mbt.spatial_sort_remap(positions, 4, 12)).length(),
    4,
  )
  assert_eq(
    (try! @meshopt_mbt.spatial_sort_triangles(indices, positions, 4, 12)).length(),
    indices.length(),
  )
  assert_eq(
    (try! @meshopt_mbt.spatial_cluster_points(positions, 4, 12, 2)).length(),
    4,
  )
}

///|
test "additional codecs and stripification round trip" {
  let indices = sample_indices()
  let encoded_sequence = try! @meshopt_mbt.encode_index_sequence(indices, 4)
  let decoded_sequence = try! @meshopt_mbt.decode_index_sequence(
    encoded_sequence.data,
    indices.length(),
  )
  assert_true(decoded_sequence == indices)
  assert_eq(
    (try! @meshopt_mbt.decode_index_sequence_bytes(
      encoded_sequence.data,
      indices.length(),
      2,
    )).length(),
    indices.length() * 2,
  )

  let vertices = Bytes::makei(16, i => (i * 5 + 1).to_byte())
  let encoded_vertices = try! @meshopt_mbt.encode_vertex_buffer_level(
    vertices, 4, 4, 2, 1,
  )
  assert_eq(
    try! @meshopt_mbt.decode_vertex_buffer(encoded_vertices.data, 4, 4),
    vertices,
  )

  let (strip, strip_len) = try! @meshopt_mbt.stripify_indices(indices, 4)
  assert_true(strip_len > 0)
  let (unstrip, unstrip_len) = try! @meshopt_mbt.unstripify_indices(
    strip,
    restart_index=0xffffffffU,
  )
  assert_true(unstrip_len >= indices.length())
  assert_true(unstrip.length() >= unstrip_len)
}

///|
test "simplification, meshlets, bounds, and tangents work on a small mesh" {
  let indices = sample_indices()
  let positions = sample_positions()
  let simplified = try! @meshopt_mbt.simplify(
    indices, positions, 4, 12, 3, 1.0F,
  )
  assert_true(simplified.index_count <= indices.length())
  assert_true(simplified.error >= 0.0F)
  let update_indices = sample_indices()
  let update_positions = sample_positions()
  let (update_count, update_error) = try! @meshopt_mbt.simplify_with_update(
    update_indices, update_positions, 4, 12, 3, 1.0F,
  )
  assert_true(update_count <= indices.length())
  assert_true(update_error >= 0.0F)
  assert_true((try! @meshopt_mbt.simplify_scale(positions, 4, 12)) > 0.0F)

  let meshlets = try! @meshopt_mbt.build_meshlets(
    indices, positions, 4, 12, 64, 64,
  )
  assert_true(meshlets.meshlet_count > 0)
  let first_vertex_count = meshlets.meshlets[2].reinterpret_as_int()
  let first_triangle_count = meshlets.meshlets[3].reinterpret_as_int()
  assert_true(first_vertex_count > 0)
  assert_true(first_triangle_count > 0)
  let bounds = try! @meshopt_mbt.compute_cluster_bounds(
    indices, positions, 4, 12,
  )
  assert_true(bounds.radius >= 0.0F)
  let meshlet_bounds = try! @meshopt_mbt.compute_meshlet_bounds(
    meshlets.vertices,
    meshlets.triangles,
    first_triangle_count,
    positions,
    4,
    12,
  )
  assert_true(meshlet_bounds.radius >= 0.0F)
  let sphere = try! @meshopt_mbt.compute_sphere_bounds(positions, 4, 12)
  assert_true(sphere.radius >= 0.0F)
  let meshlet_vertices : FixedArray[UInt] = [0U, 1U, 2U, 3U]
  let meshlet_triangles = Bytes::makei(6, i => {
    match i {
      0 => b'\x00'
      1 => b'\x01'
      2 => b'\x02'
      3 => b'\x02'
      4 => b'\x01'
      _ => b'\x03'
    }
  })
  let encoded_meshlet = try! @meshopt_mbt.encode_meshlet(
    meshlet_vertices, 4, meshlet_triangles, 2,
  )
  assert_true(encoded_meshlet.length > 0)
  assert_eq(
    (try! @meshopt_mbt.decode_meshlet_raw(encoded_meshlet.data, 4, 2)).triangles.length(),
    6,
  )
  assert_eq(
    (try! @meshopt_mbt.decode_meshlet(encoded_meshlet.data, 4, 4, 2, 3)).triangles.length(),
    6,
  )

  let normals : FixedArray[Float] = [
    0.0F, 0.0F, 1.0F, 0.0F, 0.0F, 1.0F, 0.0F, 0.0F, 1.0F, 0.0F, 0.0F, 1.0F,
  ]
  let uvs : FixedArray[Float] = [0.0F, 0.0F, 1.0F, 0.0F, 0.0F, 1.0F, 1.0F, 1.0F]
  assert_eq(
    (try! @meshopt_mbt.generate_tangents(
      indices, positions, 4, 12, normals, 12, uvs, 8,
    )).length(),
    indices.length() * 4,
  )
}

///|
test "filters opacity and packed stream helpers expose native functions" {
  let color = try! @meshopt_mbt.encode_filter_color(
    [1.0F, 0.5F, 0.0F, 1.0F],
    1,
    4,
    8,
  )
  assert_eq(color.length(), 4)
  assert_eq((try! @meshopt_mbt.decode_filter_color(color, 1, 4)).length(), 4)

  let source = Bytes::makei(4, i => {
    match i {
      0 => b'\x01'
      1 => b'\x02'
      2 => b'\x01'
      _ => b'\x03'
    }
  })
  let streams = @meshopt_mbt.PackedStreams::new(source, [0], [1], [1], 1)
  let (remap, unique_count) = try! @meshopt_mbt.generate_vertex_remap_multi_unindexed(
    streams, 4,
  )
  assert_eq(unique_count, 3)
  assert_true(remap == [0U, 1U, 0U, 2U])

  assert_true((try! @meshopt_mbt.opacity_map_entry_size(1, 2)) > 0)
  let raster = try! @meshopt_mbt.opacity_map_rasterize(
    1,
    2,
    [0.0F, 0.0F],
    [1.0F, 0.0F],
    [0.0F, 1.0F],
    Bytes::make(1, b'\xff'),
    1,
    1,
    1,
    1,
  )
  assert_true(raster.length() > 0)
  let exponent = try! @meshopt_mbt.compute_position_exponent(
    [0.0F, 0.0F, 0.0F],
    [1.0F, 1.0F, 1.0F],
    -10,
    16,
  )
  assert_true(exponent <= 0)
}
