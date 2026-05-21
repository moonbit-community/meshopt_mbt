///|
fn cube_indices() -> FixedArray[UInt] {
  [
    0U, 1U, 2U, 2U, 1U, 3U, 4U, 6U, 5U, 5U, 6U, 7U, 0U, 2U, 4U, 4U, 2U, 6U, 1U, 5U,
    3U, 3U, 5U, 7U, 2U, 3U, 6U, 6U, 3U, 7U, 0U, 4U, 1U, 1U, 4U, 5U,
  ]
}

///|
fn cube_positions() -> FixedArray[Float] {
  [
    -1.0F,
    -1.0F,
    -1.0F,
    1.0F,
    -1.0F,
    -1.0F,
    -1.0F,
    1.0F,
    -1.0F,
    1.0F,
    1.0F,
    -1.0F,
    -1.0F,
    -1.0F,
    1.0F,
    1.0F,
    -1.0F,
    1.0F,
    -1.0F,
    1.0F,
    1.0F,
    1.0F,
    1.0F,
    1.0F,
  ]
}

///|
fn cube_vertex_bytes() -> Bytes {
  Bytes::makei(8 * 12, i => (i * 17 + 11).to_byte())
}

///|
// Extracted from Khronos glTF-Sample-Assets BoxTextured/glTF.
fn khronos_box_textured_indices() -> FixedArray[UInt] {
  [
    0U, 1U, 2U, 3U, 2U, 1U, 4U, 5U, 6U, 7U, 6U, 5U, 8U, 9U, 10U, 11U, 10U, 9U, 12U,
    13U, 14U, 15U, 14U, 13U, 16U, 17U, 18U, 19U, 18U, 17U, 20U, 21U, 22U, 23U, 22U,
    21U,
  ]
}

///|
fn khronos_box_textured_positions() -> FixedArray[Float] {
  [
    -0.5F,
    -0.5F,
    0.5F,
    0.5F,
    -0.5F,
    0.5F,
    -0.5F,
    0.5F,
    0.5F,
    0.5F,
    0.5F,
    0.5F,
    0.5F,
    0.5F,
    0.5F,
    0.5F,
    -0.5F,
    0.5F,
    0.5F,
    0.5F,
    -0.5F,
    0.5F,
    -0.5F,
    -0.5F,
    -0.5F,
    0.5F,
    0.5F,
    0.5F,
    0.5F,
    0.5F,
    -0.5F,
    0.5F,
    -0.5F,
    0.5F,
    0.5F,
    -0.5F,
    -0.5F,
    -0.5F,
    0.5F,
    -0.5F,
    0.5F,
    0.5F,
    -0.5F,
    -0.5F,
    -0.5F,
    -0.5F,
    0.5F,
    -0.5F,
    0.5F,
    -0.5F,
    0.5F,
    -0.5F,
    -0.5F,
    0.5F,
    0.5F,
    -0.5F,
    -0.5F,
    -0.5F,
    -0.5F,
    -0.5F,
    -0.5F,
    -0.5F,
    -0.5F,
    -0.5F,
    0.5F,
    -0.5F,
    0.5F,
    -0.5F,
    -0.5F,
    0.5F,
    0.5F,
    -0.5F,
  ]
}

///|
fn khronos_box_textured_uvs() -> FixedArray[Float] {
  [
    6.0F, 0.0F, 5.0F, 0.0F, 6.0F, 1.0F, 5.0F, 1.0F, 4.0F, 0.0F, 5.0F, 0.0F, 4.0F,
    1.0F, 5.0F, 1.0F, 2.0F, 0.0F, 1.0F, 0.0F, 2.0F, 1.0F, 1.0F, 1.0F, 3.0F, 0.0F,
    4.0F, 0.0F, 3.0F, 1.0F, 4.0F, 1.0F, 3.0F, 0.0F, 2.0F, 0.0F, 3.0F, 1.0F, 2.0F,
    1.0F, 0.0F, 0.0F, 0.0F, 1.0F, 1.0F, 0.0F, 1.0F, 1.0F,
  ]
}

///|
fn box_face_normals() -> FixedArray[Float] {
  [
    0.0F,
    0.0F,
    1.0F,
    0.0F,
    0.0F,
    1.0F,
    0.0F,
    0.0F,
    1.0F,
    0.0F,
    0.0F,
    1.0F,
    1.0F,
    0.0F,
    0.0F,
    1.0F,
    0.0F,
    0.0F,
    1.0F,
    0.0F,
    0.0F,
    1.0F,
    0.0F,
    0.0F,
    0.0F,
    1.0F,
    0.0F,
    0.0F,
    1.0F,
    0.0F,
    0.0F,
    1.0F,
    0.0F,
    0.0F,
    1.0F,
    0.0F,
    -1.0F,
    0.0F,
    0.0F,
    -1.0F,
    0.0F,
    0.0F,
    -1.0F,
    0.0F,
    0.0F,
    -1.0F,
    0.0F,
    0.0F,
    0.0F,
    -1.0F,
    0.0F,
    0.0F,
    -1.0F,
    0.0F,
    0.0F,
    -1.0F,
    0.0F,
    0.0F,
    -1.0F,
    0.0F,
    0.0F,
    0.0F,
    -1.0F,
    0.0F,
    0.0F,
    -1.0F,
    0.0F,
    0.0F,
    -1.0F,
    0.0F,
    0.0F,
    -1.0F,
  ]
}

///|
fn same_triangles_with_rotation(
  lhs : FixedArray[UInt],
  rhs : FixedArray[UInt],
) -> Bool {
  if lhs.length() != rhs.length() || lhs.length() % 3 != 0 {
    false
  } else {
    let mut same = true
    for i in 0..<(lhs.length() / 3) {
      let offset = i * 3
      let a0 = lhs[offset]
      let a1 = lhs[offset + 1]
      let a2 = lhs[offset + 2]
      let b0 = rhs[offset]
      let b1 = rhs[offset + 1]
      let b2 = rhs[offset + 2]
      same = same &&
        (
          (a0 == b0 && a1 == b1 && a2 == b2) ||
          (a0 == b1 && a1 == b2 && a2 == b0) ||
          (a0 == b2 && a1 == b0 && a2 == b1)
        )
    }
    same
  }
}

///|
test "cube fixture runs codec optimization simplification and meshlet pipeline" {
  let indices = cube_indices()
  let positions = cube_positions()
  let vertices = cube_vertex_bytes()

  let encoded_indices = try! @meshopt_mbt.encode_index_buffer(indices, 8)
  let decoded_indices = try! @meshopt_mbt.decode_index_buffer(
    encoded_indices.data,
    indices.length(),
  )
  assert_true(same_triangles_with_rotation(decoded_indices, indices))

  let encoded_vertices = try! @meshopt_mbt.encode_vertex_buffer(vertices, 8, 12)
  let decoded_vertices = try! @meshopt_mbt.decode_vertex_buffer(
    encoded_vertices.data,
    8,
    12,
  )
  assert_eq(decoded_vertices, vertices)

  let cached = try! @meshopt_mbt.optimize_vertex_cache(indices, 8)
  assert_eq(cached.length(), indices.length())
  let cache_stats = try! @meshopt_mbt.analyze_vertex_cache(cached, 8)
  assert_true(cache_stats.vertices_transformed >= 8U)
  assert_true(cache_stats.acmr > 0.0F)

  let overdraw = try! @meshopt_mbt.optimize_overdraw(cached, positions, 8, 12)
  assert_eq(overdraw.length(), indices.length())
  let overdraw_stats = try! @meshopt_mbt.analyze_overdraw(
    overdraw, positions, 8, 12,
  )
  assert_true(overdraw_stats.pixels_covered > 0U)

  let fetch = try! @meshopt_mbt.optimize_vertex_fetch(overdraw, vertices, 8, 12)
  assert_eq(fetch.indices.length(), indices.length())
  assert_true(fetch.unique_vertex_count <= 8)
  let fetch_stats = try! @meshopt_mbt.analyze_vertex_fetch(fetch.indices, 8, 12)
  assert_true(
    fetch_stats.bytes_fetched >=
    (fetch.unique_vertex_count * 12).reinterpret_as_uint(),
  )

  let simplified = try! @meshopt_mbt.simplify(
    overdraw, positions, 8, 12, 18, 0.5F,
  )
  assert_true(simplified.index_count <= indices.length())
  assert_true(simplified.error >= 0.0F)

  let meshlets = try! @meshopt_mbt.build_meshlets(
    overdraw, positions, 8, 12, 64, 64,
  )
  assert_true(meshlets.meshlet_count > 0)
  let first_vertex_count = meshlets.meshlets[2].reinterpret_as_int()
  let first_triangle_count = meshlets.meshlets[3].reinterpret_as_int()
  assert_true(first_vertex_count > 0)
  assert_true(first_triangle_count > 0)

  let cluster_bounds = try! @meshopt_mbt.compute_cluster_bounds(
    overdraw, positions, 8, 12,
  )
  assert_true(cluster_bounds.radius > 0.0F)
  let meshlet_bounds = try! @meshopt_mbt.compute_meshlet_bounds(
    meshlets.vertices,
    meshlets.triangles,
    first_triangle_count,
    positions,
    8,
    12,
  )
  assert_true(meshlet_bounds.radius > 0.0F)

  let (strip, strip_len) = try! @meshopt_mbt.stripify_indices(overdraw, 8)
  assert_true(strip_len > 0)
  let (_, unstrip_len) = try! @meshopt_mbt.unstripify_indices(strip)
  assert_true(unstrip_len >= indices.length())
}

///|
test "khronos box textured fixture exercises asset style attributes" {
  let indices = khronos_box_textured_indices()
  let positions = khronos_box_textured_positions()
  let uvs = khronos_box_textured_uvs()
  let normals = box_face_normals()

  let encoded = try! @meshopt_mbt.encode_index_buffer(indices, 24)
  let decoded = try! @meshopt_mbt.decode_index_buffer(
    encoded.data,
    indices.length(),
  )
  assert_true(same_triangles_with_rotation(decoded, indices))

  let simplified = try! @meshopt_mbt.simplify_with_attributes(
    indices,
    positions,
    24,
    12,
    uvs,
    8,
    [1.0F, 1.0F],
    2,
    30,
    0.2F,
  )
  assert_true(simplified.index_count <= indices.length())
  assert_true(simplified.error >= 0.0F)

  let tangents = try! @meshopt_mbt.generate_tangents(
    indices, positions, 24, 12, normals, 12, uvs, 8,
  )
  assert_eq(tangents.length(), indices.length() * 4)

  let sorted = try! @meshopt_mbt.spatial_sort_triangles(
    indices, positions, 24, 12,
  )
  assert_eq(sorted.length(), indices.length())

  let meshlets = try! @meshopt_mbt.build_meshlets(
    indices, positions, 24, 12, 64, 64,
  )
  assert_true(meshlets.meshlet_count > 0)

  let opacity = try! @meshopt_mbt.opacity_map_measure(
    indices, uvs, 24, 8, 64, 64, 4, 2.0F,
  )
  assert_true(opacity.count > 0)
}
