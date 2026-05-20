///|
pub fn stripify_bound(index_count : Int) -> Int raise MeshoptError {
  require_triangle_indices(index_count)
  stripify_bound_ffi(index_count)
}

///|
pub fn stripify_indices(
  indices : FixedArray[UInt],
  vertex_count : Int,
  restart_index? : UInt = 0xffffffffU,
) -> (FixedArray[UInt], Int) raise MeshoptError {
  require_triangle_indices(indices.length())
  require(vertex_count >= 0, "vertex count must be non-negative")
  let destination = FixedArray::make(stripify_bound(indices.length()), 0U)
  let length = stripify_ffi(
    destination,
    indices,
    indices.length(),
    vertex_count,
    restart_index,
  )
  (destination, length)
}

///|
pub fn unstripify_bound(index_count : Int) -> Int raise MeshoptError {
  require(index_count >= 0, "index count must be non-negative")
  unstripify_bound_ffi(index_count)
}

///|
pub fn unstripify_indices(
  indices : FixedArray[UInt],
  restart_index? : UInt = 0xffffffffU,
) -> (FixedArray[UInt], Int) raise MeshoptError {
  let destination = FixedArray::make(unstripify_bound(indices.length()), 0U)
  let length = unstripify_ffi(
    destination,
    indices,
    indices.length(),
    restart_index,
  )
  (destination, length)
}
