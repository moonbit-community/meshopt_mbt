///|
pub suberror MeshoptError {
  MeshoptError(String)
} derive(Debug, Eq)

///|
fn require(condition : Bool, message : String) -> Unit raise MeshoptError {
  if !condition {
    raise MeshoptError(message)
  }
}

///|
fn require_triangle_indices(index_count : Int) -> Unit raise MeshoptError {
  require(index_count >= 0, "index count must be non-negative")
  require(index_count % 3 == 0, "index count must be divisible by 3")
}

///|
fn[T] require_fixedarray_length(
  values : FixedArray[T],
  expected : Int,
  label : String,
) -> Unit raise MeshoptError {
  require(
    values.length() >= expected,
    "\{label} must contain at least \{expected} elements",
  )
}

///|
fn require_bytes_length(
  bytes : Bytes,
  expected : Int,
  label : String,
) -> Unit raise MeshoptError {
  require(
    bytes.length() >= expected,
    "\{label} must contain at least \{expected} bytes",
  )
}
