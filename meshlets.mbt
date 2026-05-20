///|
fn bounds_from_arrays(
  values : FixedArray[Float],
  ints : FixedArray[Int],
) -> Bounds {
  {
    center_x: values[0],
    center_y: values[1],
    center_z: values[2],
    radius: values[3],
    cone_apex_x: values[4],
    cone_apex_y: values[5],
    cone_apex_z: values[6],
    cone_axis_x: values[7],
    cone_axis_y: values[8],
    cone_axis_z: values[9],
    cone_cutoff: values[10],
    cone_axis_s8_x: ints[0],
    cone_axis_s8_y: ints[1],
    cone_axis_s8_z: ints[2],
    cone_cutoff_s8: ints[3],
  }
}

///|
pub fn build_meshlets_bound(
  index_count : Int,
  max_vertices : Int,
  max_triangles : Int,
) -> Int raise MeshoptError {
  require_triangle_indices(index_count)
  require(
    max_vertices > 0 && max_vertices <= 256,
    "max vertices must be in 1..=256",
  )
  require(
    max_triangles > 0 && max_triangles <= 512,
    "max triangles must be in 1..=512",
  )
  build_meshlets_bound_ffi(index_count, max_vertices, max_triangles)
}

///|
pub fn build_meshlets(
  indices : FixedArray[UInt],
  positions : FixedArray[Float],
  vertex_count : Int,
  positions_stride : Int,
  max_vertices : Int,
  max_triangles : Int,
  cone_weight? : Float = 0.0F,
) -> MeshletBuild raise MeshoptError {
  require_triangle_indices(indices.length())
  require_float_stream(
    positions, vertex_count, positions_stride, 12, "positions",
  )
  let bound = build_meshlets_bound(
    indices.length(),
    max_vertices,
    max_triangles,
  )
  let meshlets = FixedArray::make(bound * 4, 0U)
  let vertices = FixedArray::make(indices.length(), 0U)
  let triangles = Bytes::make(indices.length(), 0)
  let int_params : FixedArray[Int] = [
    indices.length(),
    vertex_count,
    positions_stride,
    max_vertices,
    max_triangles,
  ]
  let float_params : FixedArray[Float] = [cone_weight]
  let meshlet_count = build_meshlets_ffi(
    meshlets, vertices, triangles, indices, positions, int_params, float_params,
  )
  { meshlets, vertices, triangles, meshlet_count }
}

///|
pub fn build_meshlets_scan(
  indices : FixedArray[UInt],
  vertex_count : Int,
  max_vertices : Int,
  max_triangles : Int,
) -> MeshletBuild raise MeshoptError {
  require_triangle_indices(indices.length())
  require(vertex_count >= 0, "vertex count must be non-negative")
  let bound = build_meshlets_bound(
    indices.length(),
    max_vertices,
    max_triangles,
  )
  let meshlets = FixedArray::make(bound * 4, 0U)
  let vertices = FixedArray::make(indices.length(), 0U)
  let triangles = Bytes::make(indices.length(), 0)
  let meshlet_count = build_meshlets_scan_ffi(
    meshlets,
    vertices,
    triangles,
    indices,
    indices.length(),
    vertex_count,
    max_vertices,
    max_triangles,
  )
  { meshlets, vertices, triangles, meshlet_count }
}

///|
pub fn build_meshlets_flex(
  indices : FixedArray[UInt],
  positions : FixedArray[Float],
  vertex_count : Int,
  positions_stride : Int,
  max_vertices : Int,
  min_triangles : Int,
  max_triangles : Int,
  cone_weight? : Float = 0.0F,
  split_factor? : Float = 1.0F,
) -> MeshletBuild raise MeshoptError {
  require_triangle_indices(indices.length())
  require_float_stream(
    positions, vertex_count, positions_stride, 12, "positions",
  )
  require(min_triangles > 0, "minimum triangles must be positive")
  let bound = build_meshlets_bound(
    indices.length(),
    max_vertices,
    max_triangles,
  )
  let meshlets = FixedArray::make(bound * 4, 0U)
  let vertices = FixedArray::make(indices.length(), 0U)
  let triangles = Bytes::make(indices.length(), 0)
  let int_params : FixedArray[Int] = [
    indices.length(),
    vertex_count,
    positions_stride,
    max_vertices,
    min_triangles,
    max_triangles,
  ]
  let float_params : FixedArray[Float] = [cone_weight, split_factor]
  let meshlet_count = build_meshlets_flex_ffi(
    meshlets, vertices, triangles, indices, positions, int_params, float_params,
  )
  { meshlets, vertices, triangles, meshlet_count }
}

///|
pub fn build_meshlets_spatial(
  indices : FixedArray[UInt],
  positions : FixedArray[Float],
  vertex_count : Int,
  positions_stride : Int,
  max_vertices : Int,
  min_triangles : Int,
  max_triangles : Int,
  fill_weight? : Float = 0.5F,
) -> MeshletBuild raise MeshoptError {
  require_triangle_indices(indices.length())
  require_float_stream(
    positions, vertex_count, positions_stride, 12, "positions",
  )
  require(min_triangles > 0, "minimum triangles must be positive")
  let bound = build_meshlets_bound(
    indices.length(),
    max_vertices,
    max_triangles,
  )
  let meshlets = FixedArray::make(bound * 4, 0U)
  let vertices = FixedArray::make(indices.length(), 0U)
  let triangles = Bytes::make(indices.length(), 0)
  let int_params : FixedArray[Int] = [
    indices.length(),
    vertex_count,
    positions_stride,
    max_vertices,
    min_triangles,
    max_triangles,
  ]
  let float_params : FixedArray[Float] = [fill_weight]
  let meshlet_count = build_meshlets_spatial_ffi(
    meshlets, vertices, triangles, indices, positions, int_params, float_params,
  )
  { meshlets, vertices, triangles, meshlet_count }
}

///|
pub fn optimize_meshlet(
  meshlet_vertices : FixedArray[UInt],
  meshlet_triangles : Bytes,
  triangle_count : Int,
  vertex_count : Int,
) -> Unit raise MeshoptError {
  require(triangle_count >= 0, "triangle count must be non-negative")
  require(vertex_count >= 0, "vertex count must be non-negative")
  require_fixedarray_length(meshlet_vertices, vertex_count, "meshlet vertices")
  require_bytes_length(
    meshlet_triangles,
    triangle_count * 3,
    "meshlet triangles",
  )
  optimize_meshlet_ffi(
    meshlet_vertices, meshlet_triangles, triangle_count, vertex_count,
  )
}

///|
pub fn optimize_meshlet_level(
  meshlet_vertices : FixedArray[UInt],
  meshlet_triangles : Bytes,
  triangle_count : Int,
  vertex_count : Int,
  level : Int,
) -> Unit raise MeshoptError {
  require(
    level >= 0 && level <= 9,
    "meshlet optimization level must be in 0..=9",
  )
  require(triangle_count >= 0, "triangle count must be non-negative")
  require(vertex_count >= 0, "vertex count must be non-negative")
  require_fixedarray_length(meshlet_vertices, vertex_count, "meshlet vertices")
  require_bytes_length(
    meshlet_triangles,
    triangle_count * 3,
    "meshlet triangles",
  )
  optimize_meshlet_level_ffi(
    meshlet_vertices, vertex_count, meshlet_triangles, triangle_count, level,
  )
}

///|
pub fn extract_meshlet_indices(
  indices : FixedArray[UInt],
) -> (FixedArray[UInt], Bytes, Int) raise MeshoptError {
  require_triangle_indices(indices.length())
  let vertices = FixedArray::make(indices.length(), 0U)
  let triangles = Bytes::make(indices.length(), 0)
  let vertex_count = extract_meshlet_indices_ffi(
    vertices,
    triangles,
    indices,
    indices.length(),
  )
  (vertices, triangles, vertex_count)
}

///|
pub fn encode_meshlet_bound(
  max_vertices : Int,
  max_triangles : Int,
) -> Int raise MeshoptError {
  require(
    max_vertices > 0 && max_vertices <= 256,
    "max vertices must be in 1..=256",
  )
  require(
    max_triangles > 0 && max_triangles <= 512,
    "max triangles must be in 1..=512",
  )
  encode_meshlet_bound_ffi(max_vertices, max_triangles)
}

///|
pub fn encode_meshlet(
  vertices : FixedArray[UInt],
  vertex_count : Int,
  triangles : Bytes,
  triangle_count : Int,
) -> MeshoptData raise MeshoptError {
  require(vertex_count >= 0, "vertex count must be non-negative")
  require(triangle_count >= 0, "triangle count must be non-negative")
  require_fixedarray_length(vertices, vertex_count, "meshlet vertices")
  require_bytes_length(triangles, triangle_count * 3, "meshlet triangles")
  let buffer = Bytes::make(
    encode_meshlet_bound(vertex_count, triangle_count),
    0,
  )
  let length = encode_meshlet_ffi(
    buffer,
    buffer.length(),
    vertices,
    vertex_count,
    triangles,
    triangle_count,
  )
  if length == 0 {
    raise MeshoptError("meshlet encoding failed")
  }
  shrink_bytes(buffer, length)
  { data: buffer, length }
}

///|
pub fn decode_meshlet_raw(
  encoded : Bytes,
  vertex_count : Int,
  triangle_count : Int,
) -> MeshletDecodeRaw raise MeshoptError {
  require(vertex_count >= 0, "vertex count must be non-negative")
  require(triangle_count >= 0, "triangle count must be non-negative")
  let vertices = FixedArray::make(vertex_count, 0U)
  let triangles = FixedArray::make(triangle_count * 3, 0U)
  let status = decode_meshlet_raw_ffi(
    vertices,
    vertex_count,
    triangles,
    triangle_count,
    encoded,
    encoded.length(),
  )
  if status != 0 {
    raise MeshoptError("meshlet decoding failed")
  }
  { vertices, triangles }
}

///|
pub fn decode_meshlet(
  encoded : Bytes,
  vertex_count : Int,
  vertex_size : Int,
  triangle_count : Int,
  triangle_size : Int,
) -> MeshletDecode raise MeshoptError {
  require(vertex_count >= 0, "vertex count must be non-negative")
  require(vertex_size > 0, "vertex size must be positive")
  require(triangle_count >= 0, "triangle count must be non-negative")
  require(
    triangle_size == 3 || triangle_size == 4,
    "triangle size must be 3 or 4 bytes",
  )
  let vertices = Bytes::make(vertex_count * vertex_size, 0)
  let triangles = Bytes::make(triangle_count * triangle_size, 0)
  let status = decode_meshlet_ffi(
    vertices,
    vertex_count,
    vertex_size,
    triangles,
    triangle_count,
    triangle_size,
    encoded,
    encoded.length(),
  )
  if status != 0 {
    raise MeshoptError("meshlet decoding failed")
  }
  { vertices, triangles }
}

///|
pub fn compute_cluster_bounds(
  indices : FixedArray[UInt],
  positions : FixedArray[Float],
  vertex_count : Int,
  positions_stride : Int,
) -> Bounds raise MeshoptError {
  require_triangle_indices(indices.length())
  require_float_stream(
    positions, vertex_count, positions_stride, 12, "positions",
  )
  let values = FixedArray::make(11, 0.0F)
  let ints = FixedArray::make(4, 0)
  compute_cluster_bounds_ffi(
    values,
    ints,
    indices,
    indices.length(),
    positions,
    vertex_count,
    positions_stride,
  )
  bounds_from_arrays(values, ints)
}

///|
pub fn compute_meshlet_bounds(
  meshlet_vertices : FixedArray[UInt],
  meshlet_triangles : Bytes,
  triangle_count : Int,
  positions : FixedArray[Float],
  vertex_count : Int,
  positions_stride : Int,
) -> Bounds raise MeshoptError {
  require(triangle_count >= 0, "triangle count must be non-negative")
  require_float_stream(
    positions, vertex_count, positions_stride, 12, "positions",
  )
  require_bytes_length(
    meshlet_triangles,
    triangle_count * 3,
    "meshlet triangles",
  )
  let values = FixedArray::make(11, 0.0F)
  let ints = FixedArray::make(4, 0)
  compute_meshlet_bounds_ffi(
    values, ints, meshlet_vertices, meshlet_triangles, triangle_count, positions,
    vertex_count, positions_stride,
  )
  bounds_from_arrays(values, ints)
}

///|
pub fn compute_sphere_bounds(
  positions : FixedArray[Float],
  count : Int,
  positions_stride : Int,
  radii? : FixedArray[Float] = [],
  radii_stride? : Int = 0,
) -> Bounds raise MeshoptError {
  require_float_stream(positions, count, positions_stride, 12, "positions")
  if radii_stride > 0 {
    require_float_stream(radii, count, radii_stride, 4, "radii")
  }
  let values = FixedArray::make(11, 0.0F)
  let ints = FixedArray::make(4, 0)
  compute_sphere_bounds_ffi(
    values,
    ints,
    positions,
    count,
    positions_stride,
    radii,
    radii_stride,
    if radii_stride > 0 {
      count
    } else {
      0
    },
  )
  bounds_from_arrays(values, ints)
}
