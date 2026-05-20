///|
pub struct VertexCacheStatistics {
  vertices_transformed : UInt
  warps_executed : UInt
  acmr : Float
  atvr : Float
} derive(Debug, Eq)

///|
pub struct VertexFetchStatistics {
  bytes_fetched : UInt
  overfetch : Float
} derive(Debug, Eq)

///|
pub struct OverdrawStatistics {
  pixels_covered : UInt
  pixels_shaded : UInt
  overdraw : Float
} derive(Debug, Eq)

///|
pub struct CoverageStatistics {
  coverage_x : Float
  coverage_y : Float
  coverage_z : Float
  extent : Float
} derive(Debug, Eq)

///|
pub struct MeshoptData {
  data : Bytes
  length : Int
} derive(Debug, Eq)

///|
pub struct VertexFetchOptimization {
  vertices : Bytes
  indices : FixedArray[UInt]
  unique_vertex_count : Int
} derive(Debug, Eq)

///|
pub struct ProvokingIndexBuffer {
  indices : FixedArray[UInt]
  reorder : FixedArray[UInt]
  reorder_count : Int
} derive(Debug, Eq)

///|
pub struct SimplifyResult {
  indices : FixedArray[UInt]
  index_count : Int
  error : Float
} derive(Debug, Eq)

///|
pub struct MeshletBuild {
  meshlets : FixedArray[UInt]
  vertices : FixedArray[UInt]
  triangles : Bytes
  meshlet_count : Int
} derive(Debug, Eq)

///|
pub struct MeshletDecodeRaw {
  vertices : FixedArray[UInt]
  triangles : FixedArray[UInt]
} derive(Debug, Eq)

///|
pub struct MeshletDecode {
  vertices : Bytes
  triangles : Bytes
} derive(Debug, Eq)

///|
pub struct OpacityMapMeasure {
  levels : Bytes
  sources : FixedArray[UInt]
  omm_indices : FixedArray[Int]
  count : Int
} derive(Debug, Eq)

///|
pub struct Bounds {
  center_x : Float
  center_y : Float
  center_z : Float
  radius : Float
  cone_apex_x : Float
  cone_apex_y : Float
  cone_apex_z : Float
  cone_axis_x : Float
  cone_axis_y : Float
  cone_axis_z : Float
  cone_cutoff : Float
  cone_axis_s8_x : Int
  cone_axis_s8_y : Int
  cone_axis_s8_z : Int
  cone_cutoff_s8 : Int
} derive(Debug, Eq)

///|
pub enum EncodeExpMode {
  Separate
  SharedVector
  SharedComponent
  Clamped
} derive(Debug, Eq)

///|
fn init {
  ignore(EncodeExpMode::Separate)
  ignore(EncodeExpMode::SharedVector)
  ignore(EncodeExpMode::SharedComponent)
  ignore(EncodeExpMode::Clamped)
}

///|
fn EncodeExpMode::to_int(self : EncodeExpMode) -> Int {
  match self {
    Separate => 0
    SharedVector => 1
    SharedComponent => 2
    Clamped => 3
  }
}

///|
pub struct SimplifyOptions(UInt) derive(Debug, Eq)

///|
pub fn SimplifyOptions::new(
  lock_border? : Bool = false,
  sparse? : Bool = false,
  error_absolute? : Bool = false,
  prune? : Bool = false,
  regularize? : Bool = false,
  permissive? : Bool = false,
  regularize_light? : Bool = false,
) -> SimplifyOptions {
  let mut flags = 0U
  if lock_border {
    flags = flags | 1U
  }
  if sparse {
    flags = flags | 2U
  }
  if error_absolute {
    flags = flags | 4U
  }
  if prune {
    flags = flags | 8U
  }
  if regularize {
    flags = flags | 16U
  }
  if permissive {
    flags = flags | 32U
  }
  if regularize_light {
    flags = flags | 64U
  }
  SimplifyOptions(flags)
}

///|
pub fn SimplifyOptions::bits(self : SimplifyOptions) -> UInt {
  self.0
}

///|
pub struct VertexLockFlags(Byte) derive(Debug, Eq)

///|
pub fn VertexLockFlags::new(
  lock? : Bool = false,
  protect? : Bool = false,
  priority? : Bool = false,
) -> VertexLockFlags {
  let mut flags = 0
  if lock {
    flags = flags | 1
  }
  if protect {
    flags = flags | 2
  }
  if priority {
    flags = flags | 4
  }
  VertexLockFlags(flags.to_byte())
}

///|
pub fn VertexLockFlags::byte(self : VertexLockFlags) -> Byte {
  self.0
}

///|
pub struct TangentOptions(UInt) derive(Debug, Eq)

///|
pub fn TangentOptions::new(
  compatible? : Bool = false,
  zero_fallback? : Bool = false,
) -> TangentOptions {
  let mut flags = 0U
  if compatible {
    flags = flags | 1U
  }
  if zero_fallback {
    flags = flags | 2U
  }
  TangentOptions(flags)
}

///|
pub fn TangentOptions::bits(self : TangentOptions) -> UInt {
  self.0
}

///|
pub struct PackedStreams {
  source : Bytes
  offsets : FixedArray[Int]
  sizes : FixedArray[Int]
  strides : FixedArray[Int]
  stream_count : Int
} derive(Debug, Eq)

///|
pub fn PackedStreams::new(
  source : Bytes,
  offsets : FixedArray[Int],
  sizes : FixedArray[Int],
  strides : FixedArray[Int],
  stream_count : Int,
) -> PackedStreams {
  { source, offsets, sizes, strides, stream_count }
}
