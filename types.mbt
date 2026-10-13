///|
pub struct VertexCacheStatistics {
  vertices_transformed : UInt32
  warps_executed : UInt32
  acmr : Float
  atvr : Float
} derive(Debug, Eq)

///|
pub struct VertexFetchStatistics {
  bytes_fetched : UInt32
  overfetch : Float
} derive(Debug, Eq)

///|
pub struct OverdrawStatistics {
  pixels_covered : UInt32
  pixels_shaded : UInt32
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
  length : Int32
} derive(Debug, Eq)

///|
pub struct VertexFetchOptimization {
  vertices : Bytes
  indices : FixedArray[UInt32]
  unique_vertex_count : Int32
} derive(Debug, Eq)

///|
pub struct ProvokingIndexBuffer {
  indices : FixedArray[UInt32]
  reorder : FixedArray[UInt32]
  reorder_count : Int32
} derive(Debug, Eq)

///|
pub struct SimplifyResult {
  indices : FixedArray[UInt32]
  index_count : Int32
  error : Float
} derive(Debug, Eq)

///|
pub struct MeshletBuild {
  meshlets : FixedArray[UInt32]
  vertices : FixedArray[UInt32]
  triangles : Bytes
  meshlet_count : Int32
} derive(Debug, Eq)

///|
pub struct MeshletDecodeRaw {
  vertices : FixedArray[UInt32]
  triangles : FixedArray[UInt32]
} derive(Debug, Eq)

///|
pub struct MeshletDecode {
  vertices : Bytes
  triangles : Bytes
} derive(Debug, Eq)

///|
pub struct OpacityMapMeasure {
  levels : Bytes
  sources : FixedArray[UInt32]
  omm_indices : FixedArray[Int32]
  count : Int32
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
  cone_axis_s8_x : Int32
  cone_axis_s8_y : Int32
  cone_axis_s8_z : Int32
  cone_cutoff_s8 : Int32
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
fn EncodeExpMode::to_int(self : EncodeExpMode) -> Int32 {
  match self {
    Separate => 0
    SharedVector => 1
    SharedComponent => 2
    Clamped => 3
  }
}

///|
pub struct SimplifyOptions(UInt32) derive(Debug, Eq)

///|
pub fn SimplifyOptions::new(
  lock_border~ : Bool = false,
  sparse~ : Bool = false,
  error_absolute~ : Bool = false,
  prune~ : Bool = false,
  regularize~ : Bool = false,
  permissive~ : Bool = false,
  regularize_light~ : Bool = false,
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
pub fn SimplifyOptions::bits(self : SimplifyOptions) -> UInt32 {
  self.0
}

///|
pub struct VertexLockFlags(Byte) derive(Debug, Eq)

///|
pub fn VertexLockFlags::new(
  lock~ : Bool = false,
  protect~ : Bool = false,
  priority~ : Bool = false,
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
pub struct TangentOptions(UInt32) derive(Debug, Eq)

///|
pub fn TangentOptions::new(
  compatible~ : Bool = false,
  zero_fallback~ : Bool = false,
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
pub fn TangentOptions::bits(self : TangentOptions) -> UInt32 {
  self.0
}

///|
pub struct PackedStreams {
  source : Bytes
  offsets : FixedArray[Int32]
  sizes : FixedArray[Int32]
  strides : FixedArray[Int32]
  stream_count : Int32
} derive(Debug, Eq)

///|
pub fn PackedStreams::new(
  source : Bytes,
  offsets : FixedArray[Int32],
  sizes : FixedArray[Int32],
  strides : FixedArray[Int32],
  stream_count : Int32,
) -> PackedStreams {
  { source, offsets, sizes, strides, stream_count, }
}

///|
pub extend Bounds with Debug::{to_repr}

///|
pub extend Bounds with Eq::{not_equal, equal}

///|
pub extend CoverageStatistics with Debug::{to_repr}

///|
pub extend CoverageStatistics with Eq::{not_equal, equal}

///|
pub extend EncodeExpMode with Debug::{to_repr}

///|
pub extend EncodeExpMode with Eq::{not_equal, equal}

///|
pub extend MeshletBuild with Debug::{to_repr}

///|
pub extend MeshletBuild with Eq::{not_equal, equal}

///|
pub extend MeshletDecode with Debug::{to_repr}

///|
pub extend MeshletDecode with Eq::{not_equal, equal}

///|
pub extend MeshletDecodeRaw with Debug::{to_repr}

///|
pub extend MeshletDecodeRaw with Eq::{not_equal, equal}

///|
pub extend MeshoptData with Debug::{to_repr}

///|
pub extend MeshoptData with Eq::{not_equal, equal}

///|
pub extend OpacityMapMeasure with Debug::{to_repr}

///|
pub extend OpacityMapMeasure with Eq::{not_equal, equal}

///|
pub extend OverdrawStatistics with Debug::{to_repr}

///|
pub extend OverdrawStatistics with Eq::{not_equal, equal}

///|
pub extend PackedStreams with Debug::{to_repr}

///|
pub extend PackedStreams with Eq::{not_equal, equal}

///|
pub extend ProvokingIndexBuffer with Debug::{to_repr}

///|
pub extend ProvokingIndexBuffer with Eq::{not_equal, equal}

///|
pub extend SimplifyOptions with Debug::{to_repr}

///|
pub extend SimplifyOptions with Eq::{not_equal, equal}

///|
pub extend SimplifyResult with Debug::{to_repr}

///|
pub extend SimplifyResult with Eq::{not_equal, equal}

///|
pub extend TangentOptions with Debug::{to_repr}

///|
pub extend TangentOptions with Eq::{not_equal, equal}

///|
pub extend VertexCacheStatistics with Debug::{to_repr}

///|
pub extend VertexCacheStatistics with Eq::{not_equal, equal}

///|
pub extend VertexFetchOptimization with Debug::{to_repr}

///|
pub extend VertexFetchOptimization with Eq::{not_equal, equal}

///|
pub extend VertexFetchStatistics with Debug::{to_repr}

///|
pub extend VertexFetchStatistics with Eq::{not_equal, equal}

///|
pub extend VertexLockFlags with Debug::{to_repr}

///|
pub extend VertexLockFlags with Eq::{not_equal, equal}
