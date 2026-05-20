#include "moonbit.h"
#include "../vendor/meshoptimizer/meshoptimizer.h"

#include <stdint.h>

static size_t to_size(int32_t value)
{
	return value < 0 ? 0 : (size_t)value;
}

extern "C" MOONBIT_FFI_EXPORT void moonbit_meshopt_shrink_bytes(moonbit_bytes_t bytes, int32_t length)
{
	uint32_t packed = (uint32_t)length & (((uint32_t)1 << 28) - 1);
	Moonbit_object_header(bytes)->meta &= ~(((uint32_t)1 << 28) - 1);
	Moonbit_object_header(bytes)->meta |= packed;
}

extern "C" MOONBIT_FFI_EXPORT uint32_t moonbit_meshopt_quantize_half(float value)
{
	return meshopt_quantizeHalf(value);
}

extern "C" MOONBIT_FFI_EXPORT float moonbit_meshopt_dequantize_half(uint32_t value)
{
	return meshopt_dequantizeHalf((unsigned short)value);
}

extern "C" MOONBIT_FFI_EXPORT int32_t moonbit_meshopt_quantize_unorm(float value, int32_t bits)
{
	return meshopt_quantizeUnorm(value, bits);
}

extern "C" MOONBIT_FFI_EXPORT int32_t moonbit_meshopt_quantize_snorm(float value, int32_t bits)
{
	return meshopt_quantizeSnorm(value, bits);
}

extern "C" MOONBIT_FFI_EXPORT float moonbit_meshopt_quantize_float(float value, int32_t bits)
{
	return meshopt_quantizeFloat(value, bits);
}

extern "C" MOONBIT_FFI_EXPORT int32_t moonbit_meshopt_generate_vertex_remap_unindexed(
	unsigned int* destination,
	const unsigned char* vertices,
	int32_t vertex_count,
	int32_t vertex_size)
{
	return (int32_t)meshopt_generateVertexRemap(destination, 0, to_size(vertex_count), vertices, to_size(vertex_count), to_size(vertex_size));
}

extern "C" MOONBIT_FFI_EXPORT int32_t moonbit_meshopt_generate_vertex_remap_indexed(
	unsigned int* destination,
	const unsigned int* indices,
	int32_t index_count,
	const unsigned char* vertices,
	int32_t vertex_count,
	int32_t vertex_size)
{
	return (int32_t)meshopt_generateVertexRemap(destination, indices, to_size(index_count), vertices, to_size(vertex_count), to_size(vertex_size));
}

extern "C" MOONBIT_FFI_EXPORT void moonbit_meshopt_remap_vertex_buffer(
	unsigned char* destination,
	const unsigned char* vertices,
	int32_t vertex_count,
	int32_t vertex_size,
	const unsigned int* remap)
{
	meshopt_remapVertexBuffer(destination, vertices, to_size(vertex_count), to_size(vertex_size), remap);
}

extern "C" MOONBIT_FFI_EXPORT void moonbit_meshopt_remap_index_buffer_unindexed(
	unsigned int* destination,
	int32_t index_count,
	const unsigned int* remap)
{
	meshopt_remapIndexBuffer(destination, 0, to_size(index_count), remap);
}

extern "C" MOONBIT_FFI_EXPORT void moonbit_meshopt_remap_index_buffer_indexed(
	unsigned int* destination,
	const unsigned int* indices,
	int32_t index_count,
	const unsigned int* remap)
{
	meshopt_remapIndexBuffer(destination, indices, to_size(index_count), remap);
}

extern "C" MOONBIT_FFI_EXPORT void moonbit_meshopt_optimize_vertex_cache(
	unsigned int* destination,
	const unsigned int* indices,
	int32_t index_count,
	int32_t vertex_count)
{
	meshopt_optimizeVertexCache(destination, indices, to_size(index_count), to_size(vertex_count));
}

extern "C" MOONBIT_FFI_EXPORT void moonbit_meshopt_optimize_vertex_cache_strip(
	unsigned int* destination,
	const unsigned int* indices,
	int32_t index_count,
	int32_t vertex_count)
{
	meshopt_optimizeVertexCacheStrip(destination, indices, to_size(index_count), to_size(vertex_count));
}

extern "C" MOONBIT_FFI_EXPORT void moonbit_meshopt_optimize_vertex_cache_fifo(
	unsigned int* destination,
	const unsigned int* indices,
	int32_t index_count,
	int32_t vertex_count,
	uint32_t cache_size)
{
	meshopt_optimizeVertexCacheFifo(destination, indices, to_size(index_count), to_size(vertex_count), cache_size);
}

extern "C" MOONBIT_FFI_EXPORT int32_t moonbit_meshopt_optimize_vertex_fetch_remap(
	unsigned int* destination,
	const unsigned int* indices,
	int32_t index_count,
	int32_t vertex_count)
{
	return (int32_t)meshopt_optimizeVertexFetchRemap(destination, indices, to_size(index_count), to_size(vertex_count));
}

extern "C" MOONBIT_FFI_EXPORT int32_t moonbit_meshopt_encode_index_buffer_bound(int32_t index_count, int32_t vertex_count)
{
	return (int32_t)meshopt_encodeIndexBufferBound(to_size(index_count), to_size(vertex_count));
}

extern "C" MOONBIT_FFI_EXPORT int32_t moonbit_meshopt_encode_index_buffer(
	unsigned char* buffer,
	int32_t buffer_size,
	const unsigned int* indices,
	int32_t index_count)
{
	return (int32_t)meshopt_encodeIndexBuffer(buffer, to_size(buffer_size), indices, to_size(index_count));
}

extern "C" MOONBIT_FFI_EXPORT int32_t moonbit_meshopt_decode_index_buffer_u32(
	unsigned int* destination,
	int32_t index_count,
	const unsigned char* buffer,
	int32_t buffer_size)
{
	return meshopt_decodeIndexBuffer(destination, to_size(index_count), sizeof(unsigned int), buffer, to_size(buffer_size));
}

extern "C" MOONBIT_FFI_EXPORT int32_t moonbit_meshopt_encode_vertex_buffer_bound(int32_t vertex_count, int32_t vertex_size)
{
	return (int32_t)meshopt_encodeVertexBufferBound(to_size(vertex_count), to_size(vertex_size));
}

extern "C" MOONBIT_FFI_EXPORT int32_t moonbit_meshopt_encode_vertex_buffer(
	unsigned char* buffer,
	int32_t buffer_size,
	const unsigned char* vertices,
	int32_t vertex_count,
	int32_t vertex_size)
{
	return (int32_t)meshopt_encodeVertexBuffer(buffer, to_size(buffer_size), vertices, to_size(vertex_count), to_size(vertex_size));
}

extern "C" MOONBIT_FFI_EXPORT int32_t moonbit_meshopt_decode_vertex_buffer(
	unsigned char* destination,
	int32_t vertex_count,
	int32_t vertex_size,
	const unsigned char* buffer,
	int32_t buffer_size)
{
	return meshopt_decodeVertexBuffer(destination, to_size(vertex_count), to_size(vertex_size), buffer, to_size(buffer_size));
}

extern "C" MOONBIT_FFI_EXPORT void moonbit_meshopt_analyze_vertex_cache(
	unsigned int* uint_stats,
	float* float_stats,
	const unsigned int* indices,
	int32_t index_count,
	int32_t vertex_count,
	uint32_t cache_size,
	uint32_t warp_size,
	uint32_t primgroup_size)
{
	meshopt_VertexCacheStatistics stats = meshopt_analyzeVertexCache(
		indices,
		to_size(index_count),
		to_size(vertex_count),
		cache_size,
		warp_size,
		primgroup_size);
	uint_stats[0] = stats.vertices_transformed;
	uint_stats[1] = stats.warps_executed;
	float_stats[0] = stats.acmr;
	float_stats[1] = stats.atvr;
}

extern "C" MOONBIT_FFI_EXPORT void moonbit_meshopt_analyze_vertex_fetch(
	unsigned int* uint_stats,
	float* float_stats,
	const unsigned int* indices,
	int32_t index_count,
	int32_t vertex_count,
	int32_t vertex_size)
{
	meshopt_VertexFetchStatistics stats = meshopt_analyzeVertexFetch(
		indices,
		to_size(index_count),
		to_size(vertex_count),
		to_size(vertex_size));
	uint_stats[0] = stats.bytes_fetched;
	float_stats[0] = stats.overfetch;
}
