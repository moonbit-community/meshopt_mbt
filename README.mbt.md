# moonbit-community/meshopt_mbt

MoonBit native bindings for [meshoptimizer](https://github.com/zeux/meshoptimizer).

This package vendors meshoptimizer's core library sources and exposes safe
MoonBit wrappers over the native C ABI. The first implementation slice covers
the binding architecture and these API groups:

- quantization helpers
- vertex remap and remap application
- vertex cache optimization
- vertex fetch remap generation
- index buffer encode/decode
- vertex buffer encode/decode
- vertex cache/fetch analysis

The package targets MoonBit's native backend.

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

## Vendored Source

The vendored meshoptimizer source is from upstream commit
`75b96fed4e8b914fbfb5ce83f0a31266d1dd836c` dated 2026-05-13.

Only the core `src` library and upstream license are vendored. gltfpack,
demos, JavaScript bindings, and sample assets are intentionally excluded.

The native build uses `MESHOPTIMIZER_ALLOC_EXPORT` with a C allocator shim in
the vendored allocator source. This keeps the package buildable through
MoonBit native stubs without requiring downstream users to add C++ runtime
linker flags.

## Development

Run:

```bash
moon test --target native
moon info
moon fmt
```

Further binding work should follow the same pattern: keep raw FFI declarations
private, mediate ABI details in the native wrapper when needed, and expose
validated MoonBit APIs that test external behavior rather than implementation
details.
