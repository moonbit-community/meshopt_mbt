# Milky2018/meshopt_mbt

MoonBit native bindings for [meshoptimizer](https://github.com/zeux/meshoptimizer).

This package vendors meshoptimizer's core library sources and exposes safe
MoonBit wrappers over the native C ABI. The bindings cover meshoptimizer's
public C API groups:

- quantization helpers
- vertex remap, multi-stream remap, shadow remap, and remap application
- custom vertex remap callbacks through a MoonBit closure trampoline
- vertex cache, overdraw, and vertex fetch optimization
- index, index sequence, vertex, filter, and meshlet codecs
- stripification and unstripification
- vertex cache, fetch, overdraw, and coverage analysis
- simplification, including attributes, locks, point simplification, and update-in-place simplification
- meshlet building, meshlet bounds, cluster bounds, sphere bounds, extraction, and clustering
- spatial sort, tangent generation, position exponent, and opacity map helpers

The package targets MoonBit's native backend.

## Examples

### Index Codec

```mbt check
///|
test {
  let indices : FixedArray[UInt] = [0U, 1U, 2U, 2U, 1U, 3U]
  let encoded = try! @meshopt_mbt.encode_index_buffer(indices, 4)
  let decoded = try! @meshopt_mbt.decode_index_buffer(
    encoded.data,
    indices.length(),
  )
  assert_true(decoded == indices)
}
```

### Vertex Remap

```mbt check
///|
test {
  let vertices = Bytes::makei(4, i => {
    match i {
      0 => b'\x01'
      1 => b'\x02'
      2 => b'\x01'
      _ => b'\x03'
    }
  })
  let (remap, unique_count) = try! @meshopt_mbt.generate_vertex_remap_unindexed(
    vertices, 4, 1,
  )
  assert_eq(unique_count, 3)
  assert_true(remap == [0U, 1U, 0U, 2U])
  let compacted = try! @meshopt_mbt.remap_vertex_buffer(
    vertices, 4, 1, unique_count, remap,
  )
  assert_eq(compacted.length(), 3)
}
```

### Optimization And Analysis

```mbt check
///|
test {
  let indices : FixedArray[UInt] = [0U, 1U, 2U, 2U, 1U, 3U]
  let optimized = try! @meshopt_mbt.optimize_vertex_cache(indices, 4)
  assert_eq(optimized.length(), indices.length())

  let stats = try! @meshopt_mbt.analyze_vertex_cache(optimized, 4)
  assert_true(stats.vertices_transformed >= 4U)
  assert_true(stats.acmr > 0.0F)
}
```

### Meshlets And Bounds

```mbt check
///|
test {
  let indices : FixedArray[UInt] = [0U, 1U, 2U, 2U, 1U, 3U]
  let positions : FixedArray[Float] = [
    0.0F, 0.0F, 0.0F, 1.0F, 0.0F, 0.0F, 0.0F, 1.0F, 0.0F, 1.0F, 1.0F, 0.0F,
  ]

  let meshlets = try! @meshopt_mbt.build_meshlets(
    indices, positions, 4, 12, 64, 64,
  )
  assert_true(meshlets.meshlet_count > 0)

  let bounds = try! @meshopt_mbt.compute_cluster_bounds(
    indices, positions, 4, 12,
  )
  assert_true(bounds.radius >= 0.0F)
}
```

## Vendored Source

The vendored meshoptimizer source is from upstream commit
`75b96fed4e8b914fbfb5ce83f0a31266d1dd836c` dated 2026-05-13.

Only the core `src` library and upstream license are vendored. gltfpack,
demos, JavaScript bindings, and sample assets are intentionally excluded.

The native build uses `MESHOPTIMIZER_ALLOC_EXPORT` with a C allocator shim in
the vendored allocator source. This keeps the package buildable through
MoonBit native stubs without requiring downstream users to add C++ runtime
linker flags.

One upstream escape hatch is intentionally not exposed as an ordinary safe
MoonBit API:

- `meshopt_setAllocator`: allocation is fixed to the package's native stub
  allocator so consumers do not need to manage a process-wide C++ allocator
  callback.

## Development

Run:

```bash
moon fmt --check
moon check --target native --warn-list +73
moon test --target native
moon info
moon fmt
```

The test suite includes README doctests, API smoke tests, and a cube mesh
fixture that exercises codecs, optimization, simplification, meshlets, bounds,
and stripification on a realistic indexed mesh.

For native memory-safety smoke testing, run:

```bash
scripts/asan-smoke.sh
```

This compiles the native wrapper and vendored meshoptimizer sources with
AddressSanitizer and UndefinedBehaviorSanitizer, then executes representative
wrapper calls. CI runs native MoonBit tests on Linux and macOS, plus the
sanitizer smoke test on Linux.

Further binding work should follow the same pattern: keep raw FFI declarations
private, mediate ABI details in the native wrapper when needed, and expose
validated MoonBit APIs that test external behavior rather than implementation
details.
