///|
fn require_filter_bits(bits : Int) -> Unit raise MeshoptError {
  require(bits == 8 || bits == 16, "filter bit count must be 8 or 16")
}

///|
fn require_filter_output(count : Int, stride : Int) -> Unit raise MeshoptError {
  require(count >= 0, "filter count must be non-negative")
  require(stride == 4 || stride == 8, "filter stride must be 4 or 8 bytes")
}

///|
pub fn encode_filter_oct(
  data : FixedArray[Float],
  count : Int,
  stride : Int,
  bits : Int,
) -> Bytes raise MeshoptError {
  require_filter_output(count, stride)
  require_filter_bits(bits)
  require_fixedarray_length(data, count * 4, "oct filter input")
  let destination = Bytes::make(count * stride, 0)
  encode_filter_oct_ffi(destination, count, stride, bits, data)
  destination
}

///|
pub fn encode_filter_quat(
  data : FixedArray[Float],
  count : Int,
  stride : Int,
  bits : Int,
) -> Bytes raise MeshoptError {
  require_filter_output(count, stride)
  require_filter_bits(bits)
  require_fixedarray_length(data, count * 4, "quat filter input")
  let destination = Bytes::make(count * stride, 0)
  encode_filter_quat_ffi(destination, count, stride, bits, data)
  destination
}

///|
pub fn encode_filter_exp(
  data : FixedArray[Float],
  count : Int,
  stride : Int,
  bits : Int,
  mode? : EncodeExpMode = Separate,
) -> Bytes raise MeshoptError {
  require_filter_output(count, stride)
  require_filter_bits(bits)
  require_fixedarray_length(data, count * (stride / 4), "exp filter input")
  let destination = Bytes::make(count * stride, 0)
  encode_filter_exp_ffi(destination, count, stride, bits, data, mode.to_int())
  destination
}

///|
pub fn encode_filter_color(
  data : FixedArray[Float],
  count : Int,
  stride : Int,
  bits : Int,
) -> Bytes raise MeshoptError {
  require_filter_output(count, stride)
  require_filter_bits(bits)
  require_fixedarray_length(data, count * 4, "color filter input")
  let destination = Bytes::make(count * stride, 0)
  encode_filter_color_ffi(destination, count, stride, bits, data)
  destination
}

///|
pub fn decode_filter_oct(
  buffer : Bytes,
  count : Int,
  stride : Int,
) -> Bytes raise MeshoptError {
  require_filter_output(count, stride)
  require_bytes_length(buffer, count * stride, "oct filter buffer")
  let destination = Bytes::makei(buffer.length(), i => buffer[i])
  decode_filter_oct_ffi(destination, count, stride)
  destination
}

///|
pub fn decode_filter_quat(
  buffer : Bytes,
  count : Int,
  stride : Int,
) -> Bytes raise MeshoptError {
  require_filter_output(count, stride)
  require_bytes_length(buffer, count * stride, "quat filter buffer")
  let destination = Bytes::makei(buffer.length(), i => buffer[i])
  decode_filter_quat_ffi(destination, count, stride)
  destination
}

///|
pub fn decode_filter_exp(
  buffer : Bytes,
  count : Int,
  stride : Int,
) -> Bytes raise MeshoptError {
  require_filter_output(count, stride)
  require_bytes_length(buffer, count * stride, "exp filter buffer")
  let destination = Bytes::makei(buffer.length(), i => buffer[i])
  decode_filter_exp_ffi(destination, count, stride)
  destination
}

///|
pub fn decode_filter_color(
  buffer : Bytes,
  count : Int,
  stride : Int,
) -> Bytes raise MeshoptError {
  require_filter_output(count, stride)
  require_bytes_length(buffer, count * stride, "color filter buffer")
  let destination = Bytes::makei(buffer.length(), i => buffer[i])
  decode_filter_color_ffi(destination, count, stride)
  destination
}
