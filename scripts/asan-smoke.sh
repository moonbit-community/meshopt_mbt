#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
build_dir="$root/_build/asan-smoke"
cxx="${CXX:-clang++}"
moon_home="${MOON_HOME:-$HOME/.moon}"

if ! command -v "$cxx" >/dev/null 2>&1; then
  echo "error: $cxx is required for ASAN/UBSAN smoke testing" >&2
  exit 1
fi

if [ ! -f "$moon_home/include/moonbit.h" ]; then
  echo "error: moonbit.h not found under $moon_home/include" >&2
  exit 1
fi

mkdir -p "$build_dir"

cat >"$build_dir/asan_smoke.cpp" <<'CPP'
#include <stdint.h>

#include <cstdlib>
#include <cstring>
#include <iostream>
#include <vector>

extern "C" {
int32_t moonbit_meshopt_encode_index_buffer_bound(int32_t index_count, int32_t vertex_count);
int32_t moonbit_meshopt_encode_index_buffer(unsigned char* buffer, int32_t buffer_size, const unsigned int* indices, int32_t index_count);
int32_t moonbit_meshopt_decode_index_buffer_u32(unsigned int* destination, int32_t index_count, const unsigned char* buffer, int32_t buffer_size);
int32_t moonbit_meshopt_encode_vertex_buffer_bound(int32_t vertex_count, int32_t vertex_size);
int32_t moonbit_meshopt_encode_vertex_buffer(unsigned char* buffer, int32_t buffer_size, const unsigned char* vertices, int32_t vertex_count, int32_t vertex_size);
int32_t moonbit_meshopt_decode_vertex_buffer(unsigned char* destination, int32_t vertex_count, int32_t vertex_size, const unsigned char* buffer, int32_t buffer_size);
void moonbit_meshopt_optimize_vertex_cache(unsigned int* destination, const unsigned int* indices, int32_t index_count, int32_t vertex_count);
void moonbit_meshopt_optimize_overdraw(unsigned int* destination, const unsigned int* indices, int32_t index_count, const float* positions, int32_t vertex_count, int32_t positions_stride, float threshold);
int32_t moonbit_meshopt_optimize_vertex_fetch(unsigned char* destination, unsigned int* indices, int32_t index_count, const unsigned char* vertices, int32_t vertex_count, int32_t vertex_size);
int32_t moonbit_meshopt_simplify(unsigned int* destination, float* result_error, const unsigned int* indices, int32_t index_count, const float* positions, int32_t vertex_count, int32_t positions_stride, int32_t target_index_count, float target_error, uint32_t options);
int32_t moonbit_meshopt_build_meshlets_bound(int32_t index_count, int32_t max_vertices, int32_t max_triangles);
int32_t moonbit_meshopt_build_meshlets(unsigned int* meshlets, unsigned int* meshlet_vertices, unsigned char* meshlet_triangles, const unsigned int* indices, const float* positions, const int32_t* int_params, const float* float_params);
void moonbit_meshopt_compute_cluster_bounds(float* values, int32_t* ints, const unsigned int* indices, int32_t index_count, const float* positions, int32_t vertex_count, int32_t positions_stride);
void moonbit_meshopt_opacity_map_rasterize(unsigned char* result, const float* uv0, const float* uv1, const float* uv2, const unsigned char* texture_data, const int32_t* int_params);
int32_t moonbit_meshopt_generate_vertex_remap_custom(unsigned int* destination, const unsigned int* indices, int32_t index_count, const float* positions, int32_t vertex_count, int32_t positions_stride, int32_t (*callback)(void*, unsigned int, unsigned int), void* context);
}

static const unsigned int k_indices[] = {
    0, 1, 2, 2, 1, 3,
    4, 6, 5, 5, 6, 7,
    0, 2, 4, 4, 2, 6,
    1, 5, 3, 3, 5, 7,
    2, 3, 6, 6, 3, 7,
    0, 4, 1, 1, 4, 5,
};

static const float k_positions[] = {
    -1, -1, -1,
     1, -1, -1,
    -1,  1, -1,
     1,  1, -1,
    -1, -1,  1,
     1, -1,  1,
    -1,  1,  1,
     1,  1,  1,
};

static bool same_triangle_rotation(const unsigned int* lhs, const unsigned int* rhs, size_t count)
{
    for (size_t i = 0; i < count; i += 3)
    {
        unsigned int a0 = lhs[i + 0], a1 = lhs[i + 1], a2 = lhs[i + 2];
        unsigned int b0 = rhs[i + 0], b1 = rhs[i + 1], b2 = rhs[i + 2];
        bool same = (a0 == b0 && a1 == b1 && a2 == b2) ||
                    (a0 == b1 && a1 == b2 && a2 == b0) ||
                    (a0 == b2 && a1 == b0 && a2 == b1);
        if (!same)
            return false;
    }

    return true;
}

static int32_t compare_same_x(void* context, unsigned int a, unsigned int b)
{
    const float* positions = static_cast<const float*>(context);
    return positions[a * 3] == positions[b * 3] ? 1 : 0;
}

static void require(bool condition, const char* message)
{
    if (!condition)
    {
        std::cerr << "asan smoke failed: " << message << "\n";
        std::abort();
    }
}

int main()
{
    const int index_count = int(sizeof(k_indices) / sizeof(k_indices[0]));
    const int vertex_count = 8;
    const int vertex_size = 12;

    int index_bound = moonbit_meshopt_encode_index_buffer_bound(index_count, vertex_count);
    std::vector<unsigned char> encoded_indices((size_t(index_bound)));
    int encoded_index_size = moonbit_meshopt_encode_index_buffer(encoded_indices.data(), index_bound, k_indices, index_count);
    require(encoded_index_size > 0, "index encoding");

    std::vector<unsigned int> decoded_indices((size_t(index_count)));
    require(moonbit_meshopt_decode_index_buffer_u32(decoded_indices.data(), index_count, encoded_indices.data(), encoded_index_size) == 0, "index decoding");
    require(same_triangle_rotation(decoded_indices.data(), k_indices, size_t(index_count)), "decoded index topology");

    std::vector<unsigned char> vertices((size_t(vertex_count * vertex_size)));
    for (size_t i = 0; i < vertices.size(); ++i)
        vertices[i] = static_cast<unsigned char>((i * 17 + 11) & 0xff);

    int vertex_bound = moonbit_meshopt_encode_vertex_buffer_bound(vertex_count, vertex_size);
    std::vector<unsigned char> encoded_vertices((size_t(vertex_bound)));
    int encoded_vertex_size = moonbit_meshopt_encode_vertex_buffer(encoded_vertices.data(), vertex_bound, vertices.data(), vertex_count, vertex_size);
    require(encoded_vertex_size > 0, "vertex encoding");

    std::vector<unsigned char> decoded_vertices(vertices.size());
    require(moonbit_meshopt_decode_vertex_buffer(decoded_vertices.data(), vertex_count, vertex_size, encoded_vertices.data(), encoded_vertex_size) == 0, "vertex decoding");
    require(decoded_vertices == vertices, "decoded vertex bytes");

    std::vector<unsigned int> cached((size_t(index_count)));
    moonbit_meshopt_optimize_vertex_cache(cached.data(), k_indices, index_count, vertex_count);

    std::vector<unsigned int> overdraw((size_t(index_count)));
    moonbit_meshopt_optimize_overdraw(overdraw.data(), cached.data(), index_count, k_positions, vertex_count, 12, 1.05f);

    std::vector<unsigned char> fetch_vertices(vertices.size());
    std::vector<unsigned int> fetch_indices = overdraw;
    int unique_vertices = moonbit_meshopt_optimize_vertex_fetch(fetch_vertices.data(), fetch_indices.data(), index_count, vertices.data(), vertex_count, vertex_size);
    require(unique_vertices > 0 && unique_vertices <= vertex_count, "vertex fetch optimization");

    std::vector<unsigned int> simplified((size_t(index_count)));
    float simplify_error = 0;
    int simplified_count = moonbit_meshopt_simplify(simplified.data(), &simplify_error, overdraw.data(), index_count, k_positions, vertex_count, 12, 18, 0.5f, 0);
    require(simplified_count > 0 && simplified_count <= index_count, "simplification");

    int meshlet_bound = moonbit_meshopt_build_meshlets_bound(index_count, 64, 64);
    std::vector<unsigned int> meshlets((size_t(meshlet_bound * 4)));
    std::vector<unsigned int> meshlet_vertices((size_t(index_count)));
    std::vector<unsigned char> meshlet_triangles((size_t(index_count)));
    int32_t meshlet_params[] = {index_count, vertex_count, 12, 64, 64};
    float meshlet_weights[] = {0.0f};
    int meshlet_count = moonbit_meshopt_build_meshlets(meshlets.data(), meshlet_vertices.data(), meshlet_triangles.data(), overdraw.data(), k_positions, meshlet_params, meshlet_weights);
    require(meshlet_count > 0, "meshlet building");

    float bounds_values[11] = {};
    int32_t bounds_ints[4] = {};
    moonbit_meshopt_compute_cluster_bounds(bounds_values, bounds_ints, overdraw.data(), index_count, k_positions, vertex_count, 12);
    require(bounds_values[3] > 0.0f, "cluster bounds");

    unsigned char opacity_result[1] = {};
    unsigned char texture_data[1] = {255};
    float uv0[] = {0, 0};
    float uv1[] = {1, 0};
    float uv2[] = {0, 1};
    int32_t opacity_params[] = {1, 2, 1, 1, 1, 1};
    moonbit_meshopt_opacity_map_rasterize(opacity_result, uv0, uv1, uv2, texture_data, opacity_params);

    unsigned int custom_remap[4] = {};
    float custom_positions[] = {
        0, 0, 0,
        1, 0, 0,
        0, 0, 0,
        2, 0, 0,
    };
    unsigned int custom_indices[] = {0, 1, 2, 3};
    int custom_unique = moonbit_meshopt_generate_vertex_remap_custom(custom_remap, custom_indices, 4, custom_positions, 4, 12, compare_same_x, custom_positions);
    require(custom_unique == 3 && custom_remap[0] == 0 && custom_remap[2] == 0, "custom remap callback");

    std::cout << "ASAN/UBSAN smoke passed\n";
    return 0;
}
CPP

sources=(
  "$root/native/meshopt_wrapper.cpp"
  "$root/vendor/meshoptimizer/allocator.cpp"
  "$root/vendor/meshoptimizer/clusterizer.cpp"
  "$root/vendor/meshoptimizer/indexanalyzer.cpp"
  "$root/vendor/meshoptimizer/indexcodec.cpp"
  "$root/vendor/meshoptimizer/indexgenerator.cpp"
  "$root/vendor/meshoptimizer/meshletcodec.cpp"
  "$root/vendor/meshoptimizer/meshletutils.cpp"
  "$root/vendor/meshoptimizer/opacitymap.cpp"
  "$root/vendor/meshoptimizer/overdrawoptimizer.cpp"
  "$root/vendor/meshoptimizer/partition.cpp"
  "$root/vendor/meshoptimizer/quantization.cpp"
  "$root/vendor/meshoptimizer/rasterizer.cpp"
  "$root/vendor/meshoptimizer/simplifier.cpp"
  "$root/vendor/meshoptimizer/spatialorder.cpp"
  "$root/vendor/meshoptimizer/stripifier.cpp"
  "$root/vendor/meshoptimizer/tangentspace.cpp"
  "$root/vendor/meshoptimizer/vcacheoptimizer.cpp"
  "$root/vendor/meshoptimizer/vertexcodec.cpp"
  "$root/vendor/meshoptimizer/vertexfilter.cpp"
  "$root/vendor/meshoptimizer/vfetchoptimizer.cpp"
)

asan_default="halt_on_error=1:detect_leaks=1"
if [ "$(uname -s)" = "Darwin" ]; then
  asan_default="halt_on_error=1:detect_leaks=0"
fi

"$cxx" \
  -std=c++11 \
  -g \
  -O1 \
  -fsanitize=address,undefined \
  -fno-omit-frame-pointer \
  -DMESHOPTIMIZER_ALLOC_EXPORT \
  -fno-exceptions \
  -fno-rtti \
  -I"$moon_home/include" \
  "$build_dir/asan_smoke.cpp" \
  "${sources[@]}" \
  -o "$build_dir/asan_smoke"

ASAN_OPTIONS="${ASAN_OPTIONS:-$asan_default}" \
UBSAN_OPTIONS="${UBSAN_OPTIONS:-halt_on_error=1}" \
"$build_dir/asan_smoke"
