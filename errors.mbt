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

///|
fn require_float_stream(
  values : FixedArray[Float],
  count : Int,
  stride : Int,
  minimum_stride : Int,
  label : String,
) -> Unit raise MeshoptError {
  require(count >= 0, "\{label} count must be non-negative")
  require(
    stride >= minimum_stride,
    "\{label} stride must be at least \{minimum_stride} bytes",
  )
  require(stride % 4 == 0, "\{label} stride must be divisible by 4")
  require_fixedarray_length(values, count * (stride / 4), label)
}
