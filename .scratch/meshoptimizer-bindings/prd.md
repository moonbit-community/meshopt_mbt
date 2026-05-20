---
title: "Complete MoonBit Bindings for meshoptimizer"
labels:
  - ready-for-agent
status: draft
created: 2026-05-20
---

## Problem Statement

MoonBit users need a complete, reliable binding to the meshoptimizer library so they can optimize, simplify, encode, decode, analyze, and cluster mesh data from MoonBit without writing C or C++ glue themselves.

The current repository is still a starter MoonBit library. It does not yet vendor meshoptimizer, expose native FFI declarations, provide safe MoonBit wrappers, document the binding surface, or test behavior against known meshoptimizer results. Without this binding, MoonBit projects that process 3D geometry must either reimplement mature mesh optimization algorithms or leave the MoonBit ecosystem for mesh preprocessing.

The binding must cover the full meshoptimizer C API, not only a narrow happy path. It must also handle the fact that meshoptimizer exposes a C ABI but is implemented in C++, while MoonBit native stubs need predictable, zero-configuration native builds.

## Solution

Build a complete native MoonBit binding for meshoptimizer.

From the user's perspective, the library should behave like a normal MoonBit package: add the dependency, import the package, pass MoonBit buffers and numeric options, and receive optimized buffers, statistics, decoded data, meshlets, bounds, or errors through clear MoonBit APIs.

The implementation will vendor the meshoptimizer source, compile it as native stubs, and expose a safe MoonBit API over a private FFI layer. The public API will allocate output buffers where appropriate, validate sizes and strides before crossing the FFI boundary, convert meshoptimizer status codes into MoonBit errors, and preserve access to performance-oriented in-place operations where meshoptimizer expects them.

The build should avoid requiring downstream users to manually link a C++ runtime. A native smoke test already showed that meshoptimizer can be compiled through MoonBit native stubs with a C-compatible allocator configuration and no extra C++ runtime link flags.

## User Stories

1. As a MoonBit graphics developer, I want to generate a vertex remap table, so that duplicate vertices can be removed before rendering or serialization.
2. As a MoonBit graphics developer, I want to remap vertex buffers, so that vertex data matches the compact index buffer produced by meshoptimizer.
3. As a MoonBit graphics developer, I want to remap index buffers, so that indexed geometry references the optimized vertex layout.
4. As a MoonBit graphics developer, I want to generate shadow index buffers, so that depth-only rendering can use fewer unique vertices.
5. As a MoonBit graphics developer, I want multi-stream remap support, so that interleaved and split vertex layouts are both usable.
6. As a MoonBit graphics developer, I want to generate position remaps, so that position-only connectivity algorithms can be implemented.
7. As a MoonBit graphics developer, I want to generate adjacency index buffers, so that geometry-shader adjacency workflows are possible.
8. As a MoonBit graphics developer, I want to generate tessellation index buffers, so that PN-AEN tessellation workflows can be supported.
9. As a MoonBit graphics developer, I want to generate provoking index buffers, so that visibility-buffer rendering can use primitive IDs efficiently.
10. As a MoonBit graphics developer, I want to optimize vertex cache order, so that GPU vertex shader invocations are reduced.
11. As a MoonBit graphics developer, I want to optimize vertex cache order for FIFO caches, so that I can tune for fast preprocessing or specific hardware assumptions.
12. As a MoonBit graphics developer, I want to optimize overdraw after cache optimization, so that pixel shading work can be reduced.
13. As a MoonBit graphics developer, I want to optimize vertex fetch, so that GPU memory access is more coherent.
14. As a MoonBit graphics developer, I want to generate vertex fetch remap tables, so that multi-stream vertex data can be optimized consistently.
15. As a MoonBit asset pipeline author, I want to encode index buffers, so that mesh assets can be stored more compactly.
16. As a MoonBit asset pipeline author, I want to decode index buffers, so that compressed mesh assets can be loaded back into usable buffers.
17. As a MoonBit asset pipeline author, I want to encode index sequences, so that non-triangle-list index streams can be compressed.
18. As a MoonBit asset pipeline author, I want to decode index sequences, so that compressed sequence data can be restored.
19. As a MoonBit asset pipeline author, I want to compute encode bounds before allocation, so that output buffers are correctly sized.
20. As a MoonBit asset pipeline author, I want to select supported encoder versions, so that I can control compatibility with older decoders.
21. As a MoonBit asset pipeline author, I want decode operations to return explicit errors, so that invalid or truncated compressed data does not look like valid output.
22. As a MoonBit asset pipeline author, I want to encode vertex buffers, so that vertex data can be stored compactly.
23. As a MoonBit asset pipeline author, I want to decode vertex buffers, so that compressed vertex data can be restored.
24. As a MoonBit asset pipeline author, I want to use vertex filter encode and decode helpers, so that normals, quaternions, colors, and exponent-based data can use meshoptimizer's formats.
25. As a MoonBit asset pipeline author, I want half-float quantization helpers, so that common compact vertex formats can be generated.
26. As a MoonBit asset pipeline author, I want normalized float quantization helpers, so that SNORM and UNORM-style packed data can be generated.
27. As a MoonBit asset pipeline author, I want float quantization helpers, so that vertex data can be made more compressible.
28. As a MoonBit asset pipeline author, I want to simplify meshes to a target index count, so that level-of-detail assets can be produced.
29. As a MoonBit asset pipeline author, I want simplification to return the achieved error, so that asset quality decisions can be automated.
30. As a MoonBit asset pipeline author, I want simplification options represented clearly, so that border locking, sparse mode, absolute error, pruning, and regularization are understandable.
31. As a MoonBit asset pipeline author, I want vertex lock flags represented clearly, so that protected vertices can be preserved during simplification.
32. As a MoonBit asset pipeline author, I want simplification with attributes, so that normals, UVs, colors, and other attributes can affect LOD quality.
33. As a MoonBit asset pipeline author, I want in-place simplification-with-update support, so that workflows matching meshoptimizer's destructive API remain available.
34. As a MoonBit asset pipeline author, I want sloppy simplification support, so that very fast LOD generation is possible when quality constraints are looser.
35. As a MoonBit asset pipeline author, I want point simplification support, so that point clouds can be reduced.
36. As a MoonBit asset pipeline author, I want simplify scale computation, so that relative error values can be interpreted correctly.
37. As a MoonBit asset pipeline author, I want stripify and unstripify support, so that triangle strip workflows can be supported.
38. As a MoonBit performance engineer, I want vertex cache statistics, so that I can measure cache optimization quality.
39. As a MoonBit performance engineer, I want vertex fetch statistics, so that I can measure memory overfetch.
40. As a MoonBit performance engineer, I want overdraw statistics, so that I can compare overdraw optimization results.
41. As a MoonBit performance engineer, I want coverage statistics, so that raster coverage can be inspected.
42. As a MoonBit rendering developer, I want to build meshlets, so that mesh shader and cluster-based rendering pipelines can be implemented.
43. As a MoonBit rendering developer, I want scan-based meshlet building, so that load-time meshlet generation can use already cache-optimized index buffers.
44. As a MoonBit rendering developer, I want flexible and spatial meshlet builders, so that I can choose topology or spatial priorities.
45. As a MoonBit rendering developer, I want meshlet build bounds, so that meshlet output arrays can be allocated safely.
46. As a MoonBit rendering developer, I want to optimize meshlet-local triangles and vertices, so that meshlets are efficient for rendering and compression.
47. As a MoonBit rendering developer, I want cluster bounds, so that frustum, occlusion, and backface culling data can be computed.
48. As a MoonBit rendering developer, I want meshlet bounds, so that each meshlet can be culled efficiently.
49. As a MoonBit rendering developer, I want sphere bounds, so that point sets or sphere sets can be bounded.
50. As a MoonBit rendering developer, I want spatial sorting helpers, so that triangles, points, and remaps can be ordered for locality.
51. As a MoonBit rendering developer, I want cluster partitioning support, so that grouped mesh data can be reorganized for streaming or rendering.
52. As a MoonBit rendering developer, I want tangent generation support, so that assets can generate tangent spaces compatible with meshoptimizer.
53. As a MoonBit rendering developer, I want opacity micromap APIs exposed when supported, so that advanced opacity workflows can be integrated.
54. As a MoonBit library user, I want stable APIs clearly separated from experimental APIs, so that I know which functions may change with upstream meshoptimizer.
55. As a MoonBit library user, I want public wrappers instead of raw pointer-heavy extern calls, so that common use cases are safe and idiomatic.
56. As a MoonBit library user, I want optional lower-level in-place APIs, so that performance-critical code can avoid unnecessary allocations.
57. As a MoonBit library user, I want buffer length and stride validation, so that mistakes fail early with useful errors.
58. As a MoonBit library user, I want C status codes translated into MoonBit errors, so that error handling is consistent.
59. As a MoonBit library user, I want generated interface files to reflect the intended public API, so that review can focus on the binding surface.
60. As a MoonBit package maintainer, I want the vendored meshoptimizer version documented, so that upstream upgrades are controlled and auditable.
61. As a MoonBit package maintainer, I want upstream source preparation to be repeatable, so that future meshoptimizer updates do not depend on manual copy-paste.
62. As a MoonBit package maintainer, I want the native build to be zero-configuration for common users, so that downstream packages do not need custom linker flags.
63. As a MoonBit package maintainer, I want tests to exercise real meshoptimizer calls, so that FFI declarations and wrappers are validated together.
64. As a MoonBit package maintainer, I want AddressSanitizer-capable validation, so that FFI memory mistakes can be caught during development.
65. As a MoonBit documentation reader, I want examples for the standard mesh optimization pipeline, so that indexing, cache optimization, overdraw optimization, fetch optimization, and quantization can be learned in order.
66. As a MoonBit documentation reader, I want examples for encode/decode round trips, so that compressed mesh asset workflows are easy to adopt.
67. As a MoonBit documentation reader, I want examples for meshlet generation, so that cluster-based rendering users can start from a working pattern.
68. As an AFK implementation agent, I want the work split into cohesive modules, so that binding coverage can be implemented and tested incrementally.

## Implementation Decisions

- The binding will target the native backend. Non-native backends are not part of this PRD because meshoptimizer is native C++ code.
- The package will vendor meshoptimizer's core library sources and header, not gltfpack, demos, JavaScript bindings, or external sample assets.
- The public MoonBit API will be organized by meshoptimizer domain area: remap/indexing, vertex optimization, codecs, filters, simplification, stripification, analysis, meshlets and bounds, spatial sorting and partitioning, tangent generation, opacity micromaps, and quantization.
- The raw FFI layer will remain private unless there is a strong reason to expose a deliberately low-level escape hatch.
- Public APIs will prefer safe wrappers that allocate correctly sized outputs or require explicitly sized mutable outputs only where in-place operation is part of meshoptimizer's contract.
- Buffer-oriented inputs will use MoonBit-owned buffers and arrays, with wrapper validation for length, stride, count, and element-size assumptions before calling native code.
- Index buffers and remap tables will use 32-bit unsigned indices, matching meshoptimizer's C ABI.
- Vertex and encoded data APIs will support byte buffers for arbitrary vertex layouts because meshoptimizer treats vertex data as raw bytes.
- Position, normal, tangent, UV, color, and attribute APIs will provide typed float-oriented helpers where meshoptimizer requires float streams.
- C structs returned by meshoptimizer will be converted through native wrapper helpers into MoonBit value types, avoiding reliance on unverified ABI layout assumptions in MoonBit.
- Native wrappers will mediate `size_t`, struct-return, callback, optional-null, and status-code cases that are awkward or unsafe as direct extern declarations.
- The binding will represent meshoptimizer option bitmasks with MoonBit wrapper types and constructors instead of expecting users to remember raw integer constants.
- Experimental meshoptimizer APIs will be exposed in a clearly marked area so users can opt into them knowingly.
- The native build will compile meshoptimizer through MoonBit native stubs.
- The native build will avoid a downstream C++ runtime link requirement by using meshoptimizer's allocator export hook with a C-compatible allocator and by compiling without exceptions and RTTI.
- Upstream source preparation should be scriptable and repeatable, following the spirit of the uv.mbt preparation flow while accounting for meshoptimizer's simpler source tree and C++ implementation.
- The vendored upstream version should be recorded in documentation and reviewed whenever the source is refreshed.
- The standard documentation path will describe meshoptimizer's recommended pipeline: indexing, vertex cache optimization, optional overdraw optimization, vertex fetch optimization, quantization, and optional shadow indexing.
- The package should include generated MoonBit interface files after implementation so the public API surface can be reviewed.
- Deprecated compatibility aliases should only be added after a public API exists and later changes need migration support.

## Testing Decisions

- Tests should validate external behavior through the public MoonBit API, not private FFI names or internal wrapper implementation details.
- The first tests should be small, deterministic smoke tests that call real meshoptimizer native functions and verify known stable results.
- Quantization tests should assert exact results for fixed values where meshoptimizer behavior is stable.
- Encode/decode tests should use round trips: encode valid input, decode it, and assert that the decoded data matches the original.
- Bound-size helper tests should assert that allocated buffers are large enough for successful encode operations.
- Optimization tests should assert validity properties such as output length, index range preservation, triangle-list shape, and compatible vertex counts, rather than overfitting to every exact reordered index unless upstream guarantees that result.
- Remap tests should use small meshes with intentional duplicate vertices and assert the resulting compact vertex count and remapped indices.
- Simplification tests should use simple stable meshes and assert target constraints, result length, valid index ranges, and returned error behavior.
- Analysis tests should assert stable statistics for small fixed meshes where the result is deterministic.
- Meshlet tests should assert meshlet count bounds, per-meshlet vertex and triangle limits, and valid references into generated vertex and triangle arrays.
- Bounds tests should verify center/radius/cone values for very small deterministic inputs where floating point tolerance is acceptable.
- Error-path tests should cover invalid strides, invalid counts, too-small buffers, invalid encoded data, and unsupported option combinations.
- Tests should include both allocation-returning wrappers and in-place wrappers where both public forms exist.
- Native memory validation should be supported through a development test script that can run the suite with AddressSanitizer-capable compiler settings.
- The final implementation should run `moon test`, `moon info`, and `moon fmt`; when native-only files are involved, validation should explicitly use the native target.
- Existing starter black-box and white-box test files provide the local test convention, but they should be replaced or expanded with real behavior tests for this binding.

## Out of Scope

- Reimplementing meshoptimizer algorithms in MoonBit.
- Binding gltfpack or providing a full glTF asset pipeline.
- Binding meshoptimizer's JavaScript or WASM packaging.
- Providing GPU rendering, mesh shader runtime integration, or graphics API bindings.
- Supporting non-native MoonBit backends in this PRD.
- Designing a high-level scene or asset format abstraction.
- Guaranteeing bit-for-bit stable triangle order for optimization APIs beyond what upstream meshoptimizer guarantees.
- Adding project-wide issue tracker configuration beyond this local PRD draft.

## Further Notes

- The upstream study used meshoptimizer cloned to a temporary directory and confirmed that the public API is concentrated in the core header.
- The reference binding study used uv.mbt and found a useful pattern: vendor upstream sources, list native stubs, keep raw externs thin, expose MoonBit wrappers, and test behavior through the public API.
- A local smoke prototype confirmed that MoonBit native stubs can compile C++ files and call meshoptimizer from MoonBit.
- A second local smoke prototype confirmed that using meshoptimizer's allocator export hook with a C-compatible allocator avoids requiring an explicit C++ runtime link flag on macOS for the tested API calls.
- The repository currently has no configured remote issue tracker or agent issue-tracker documentation, so this PRD is published as local Markdown with a `ready-for-agent` label in frontmatter.
