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
pub struct MeshoptData {
  data : Bytes
  length : Int
} derive(Debug, Eq)

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
