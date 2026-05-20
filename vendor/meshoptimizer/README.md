# meshoptimizer vendor notes

This directory contains the core `src` files from `zeux/meshoptimizer`.

- Upstream commit: `75b96fed4e8b914fbfb5ce83f0a31266d1dd836c`
- Upstream date: 2026-05-13
- Upstream license: MIT, copied as `LICENSE.md`

Local modification:

- `allocator.cpp` uses `malloc` and `free` under `MESHOPTIMIZER_ALLOC_EXPORT`
  so MoonBit native-stub builds do not need to link the C++ runtime just for
  meshoptimizer's default `operator new` and `operator delete` references.
