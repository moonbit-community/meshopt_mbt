///|
pub fn quantize_half(value : Float) -> UInt {
  quantize_half_ffi(value)
}

///|
pub fn dequantize_half(value : UInt) -> Float {
  dequantize_half_ffi(value)
}

///|
pub fn quantize_unorm(value : Float, bits : Int) -> Int raise MeshoptError {
  require(bits >= 1 && bits <= 30, "UNORM bit count must be in 1..=30")
  quantize_unorm_ffi(value, bits)
}

///|
pub fn quantize_snorm(value : Float, bits : Int) -> Int raise MeshoptError {
  require(bits >= 1 && bits <= 30, "SNORM bit count must be in 1..=30")
  quantize_snorm_ffi(value, bits)
}

///|
pub fn quantize_float(value : Float, bits : Int) -> Float raise MeshoptError {
  require(bits >= 1 && bits <= 23, "float mantissa bit count must be in 1..=23")
  quantize_float_ffi(value, bits)
}
