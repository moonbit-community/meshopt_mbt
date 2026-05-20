#include "moonbit.h"
#include "../vendor/meshoptimizer/meshoptimizer.h"

#include <stdint.h>

static size_t to_size(int32_t value)
{
	return value < 0 ? 0 : (size_t)value;
}

static const unsigned char* optional_bytes(const unsigned char* data, int32_t length)
{
	return length > 0 ? data : 0;
}

static const float* optional_float_array(const float* data, int32_t count)
{
	return count > 0 ? data : 0;
}

static void write_bounds(float* float_values, int32_t* int_values, const meshopt_Bounds& bounds)
{
	float_values[0] = bounds.center[0];
	float_values[1] = bounds.center[1];
	float_values[2] = bounds.center[2];
	float_values[3] = bounds.radius;
	float_values[4] = bounds.cone_apex[0];
	float_values[5] = bounds.cone_apex[1];
	float_values[6] = bounds.cone_apex[2];
	float_values[7] = bounds.cone_axis[0];
	float_values[8] = bounds.cone_axis[1];
	float_values[9] = bounds.cone_axis[2];
	float_values[10] = bounds.cone_cutoff;
	int_values[0] = bounds.cone_axis_s8[0];
	int_values[1] = bounds.cone_axis_s8[1];
	int_values[2] = bounds.cone_axis_s8[2];
	int_values[3] = bounds.cone_cutoff_s8;
}

static size_t make_streams(
	meshopt_Stream* streams,
	const unsigned char* source,
	const int32_t* offsets,
	const int32_t* sizes,
	const int32_t* strides,
	int32_t stream_count)
{
	size_t count = to_size(stream_count);
	if (count > 16)
		count = 16;

	for (size_t i = 0; i < count; ++i)
	{
		streams[i].data = source + to_size(offsets[i]);
		streams[i].size = to_size(sizes[i]);
		streams[i].stride = to_size(strides[i]);
	}

	return count;
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

extern "C" MOONBIT_FFI_EXPORT int32_t moonbit_meshopt_decode_index_buffer_bytes(
	unsigned char* destination,
	int32_t index_count,
	int32_t index_size,
	const unsigned char* buffer,
	int32_t buffer_size)
{
	return meshopt_decodeIndexBuffer(destination, to_size(index_count), to_size(index_size), buffer, to_size(buffer_size));
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

extern "C" MOONBIT_FFI_EXPORT void moonbit_meshopt_generate_shadow_index_buffer(
	unsigned int* destination,
	const unsigned int* indices,
	int32_t index_count,
	const unsigned char* vertices,
	int32_t vertex_count,
	int32_t vertex_size,
	int32_t vertex_stride)
{
	meshopt_generateShadowIndexBuffer(destination, indices, to_size(index_count), vertices, to_size(vertex_count), to_size(vertex_size), to_size(vertex_stride));
}

extern "C" MOONBIT_FFI_EXPORT void moonbit_meshopt_generate_position_remap(
	unsigned int* destination,
	const float* positions,
	int32_t vertex_count,
	int32_t positions_stride)
{
	meshopt_generatePositionRemap(destination, positions, to_size(vertex_count), to_size(positions_stride));
}

extern "C" MOONBIT_FFI_EXPORT void moonbit_meshopt_generate_adjacency_index_buffer(
	unsigned int* destination,
	const unsigned int* indices,
	int32_t index_count,
	const float* positions,
	int32_t vertex_count,
	int32_t positions_stride)
{
	meshopt_generateAdjacencyIndexBuffer(destination, indices, to_size(index_count), positions, to_size(vertex_count), to_size(positions_stride));
}

extern "C" MOONBIT_FFI_EXPORT void moonbit_meshopt_generate_tessellation_index_buffer(
	unsigned int* destination,
	const unsigned int* indices,
	int32_t index_count,
	const float* positions,
	int32_t vertex_count,
	int32_t positions_stride)
{
	meshopt_generateTessellationIndexBuffer(destination, indices, to_size(index_count), positions, to_size(vertex_count), to_size(positions_stride));
}

extern "C" MOONBIT_FFI_EXPORT int32_t moonbit_meshopt_generate_provoking_index_buffer(
	unsigned int* destination,
	unsigned int* reorder,
	const unsigned int* indices,
	int32_t index_count,
	int32_t vertex_count)
{
	return (int32_t)meshopt_generateProvokingIndexBuffer(destination, reorder, indices, to_size(index_count), to_size(vertex_count));
}

extern "C" MOONBIT_FFI_EXPORT void moonbit_meshopt_optimize_overdraw(
	unsigned int* destination,
	const unsigned int* indices,
	int32_t index_count,
	const float* positions,
	int32_t vertex_count,
	int32_t positions_stride,
	float threshold)
{
	meshopt_optimizeOverdraw(destination, indices, to_size(index_count), positions, to_size(vertex_count), to_size(positions_stride), threshold);
}

extern "C" MOONBIT_FFI_EXPORT int32_t moonbit_meshopt_optimize_vertex_fetch(
	unsigned char* destination,
	unsigned int* indices,
	int32_t index_count,
	const unsigned char* vertices,
	int32_t vertex_count,
	int32_t vertex_size)
{
	return (int32_t)meshopt_optimizeVertexFetch(destination, indices, to_size(index_count), vertices, to_size(vertex_count), to_size(vertex_size));
}

extern "C" MOONBIT_FFI_EXPORT int32_t moonbit_meshopt_decode_index_version(const unsigned char* buffer, int32_t buffer_size)
{
	return meshopt_decodeIndexVersion(buffer, to_size(buffer_size));
}

extern "C" MOONBIT_FFI_EXPORT int32_t moonbit_meshopt_encode_index_sequence_bound(int32_t index_count, int32_t vertex_count)
{
	return (int32_t)meshopt_encodeIndexSequenceBound(to_size(index_count), to_size(vertex_count));
}

extern "C" MOONBIT_FFI_EXPORT int32_t moonbit_meshopt_encode_index_sequence(
	unsigned char* buffer,
	int32_t buffer_size,
	const unsigned int* indices,
	int32_t index_count)
{
	return (int32_t)meshopt_encodeIndexSequence(buffer, to_size(buffer_size), indices, to_size(index_count));
}

extern "C" MOONBIT_FFI_EXPORT int32_t moonbit_meshopt_decode_index_sequence_u32(
	unsigned int* destination,
	int32_t index_count,
	const unsigned char* buffer,
	int32_t buffer_size)
{
	return meshopt_decodeIndexSequence(destination, to_size(index_count), sizeof(unsigned int), buffer, to_size(buffer_size));
}

extern "C" MOONBIT_FFI_EXPORT int32_t moonbit_meshopt_decode_index_sequence_bytes(
	unsigned char* destination,
	int32_t index_count,
	int32_t index_size,
	const unsigned char* buffer,
	int32_t buffer_size)
{
	return meshopt_decodeIndexSequence(destination, to_size(index_count), to_size(index_size), buffer, to_size(buffer_size));
}

extern "C" MOONBIT_FFI_EXPORT int32_t moonbit_meshopt_decode_vertex_version(const unsigned char* buffer, int32_t buffer_size)
{
	return meshopt_decodeVertexVersion(buffer, to_size(buffer_size));
}

extern "C" MOONBIT_FFI_EXPORT int32_t moonbit_meshopt_encode_vertex_buffer_level(
	unsigned char* buffer,
	int32_t buffer_size,
	const unsigned char* vertices,
	int32_t vertex_count,
	int32_t vertex_size,
	int32_t level,
	int32_t version)
{
	return (int32_t)meshopt_encodeVertexBufferLevel(buffer, to_size(buffer_size), vertices, to_size(vertex_count), to_size(vertex_size), level, version);
}

extern "C" MOONBIT_FFI_EXPORT void moonbit_meshopt_decode_filter_oct(unsigned char* buffer, int32_t count, int32_t stride)
{
	meshopt_decodeFilterOct(buffer, to_size(count), to_size(stride));
}

extern "C" MOONBIT_FFI_EXPORT void moonbit_meshopt_decode_filter_quat(unsigned char* buffer, int32_t count, int32_t stride)
{
	meshopt_decodeFilterQuat(buffer, to_size(count), to_size(stride));
}

extern "C" MOONBIT_FFI_EXPORT void moonbit_meshopt_decode_filter_exp(unsigned char* buffer, int32_t count, int32_t stride)
{
	meshopt_decodeFilterExp(buffer, to_size(count), to_size(stride));
}

extern "C" MOONBIT_FFI_EXPORT void moonbit_meshopt_decode_filter_color(unsigned char* buffer, int32_t count, int32_t stride)
{
	meshopt_decodeFilterColor(buffer, to_size(count), to_size(stride));
}

extern "C" MOONBIT_FFI_EXPORT void moonbit_meshopt_encode_filter_oct(
	unsigned char* destination,
	int32_t count,
	int32_t stride,
	int32_t bits,
	const float* data)
{
	meshopt_encodeFilterOct(destination, to_size(count), to_size(stride), bits, data);
}

extern "C" MOONBIT_FFI_EXPORT void moonbit_meshopt_encode_filter_quat(
	unsigned char* destination,
	int32_t count,
	int32_t stride,
	int32_t bits,
	const float* data)
{
	meshopt_encodeFilterQuat(destination, to_size(count), to_size(stride), bits, data);
}

extern "C" MOONBIT_FFI_EXPORT void moonbit_meshopt_encode_filter_exp(
	unsigned char* destination,
	int32_t count,
	int32_t stride,
	int32_t bits,
	const float* data,
	int32_t mode)
{
	meshopt_encodeFilterExp(destination, to_size(count), to_size(stride), bits, data, (meshopt_EncodeExpMode)mode);
}

extern "C" MOONBIT_FFI_EXPORT void moonbit_meshopt_encode_filter_color(
	unsigned char* destination,
	int32_t count,
	int32_t stride,
	int32_t bits,
	const float* data)
{
	meshopt_encodeFilterColor(destination, to_size(count), to_size(stride), bits, data);
}

extern "C" MOONBIT_FFI_EXPORT int32_t moonbit_meshopt_stripify(
	unsigned int* destination,
	const unsigned int* indices,
	int32_t index_count,
	int32_t vertex_count,
	uint32_t restart_index)
{
	return (int32_t)meshopt_stripify(destination, indices, to_size(index_count), to_size(vertex_count), restart_index);
}

extern "C" MOONBIT_FFI_EXPORT int32_t moonbit_meshopt_stripify_bound(int32_t index_count)
{
	return (int32_t)meshopt_stripifyBound(to_size(index_count));
}

extern "C" MOONBIT_FFI_EXPORT int32_t moonbit_meshopt_unstripify(
	unsigned int* destination,
	const unsigned int* indices,
	int32_t index_count,
	uint32_t restart_index)
{
	return (int32_t)meshopt_unstripify(destination, indices, to_size(index_count), restart_index);
}

extern "C" MOONBIT_FFI_EXPORT int32_t moonbit_meshopt_unstripify_bound(int32_t index_count)
{
	return (int32_t)meshopt_unstripifyBound(to_size(index_count));
}

extern "C" MOONBIT_FFI_EXPORT void moonbit_meshopt_analyze_overdraw(
	unsigned int* uint_stats,
	float* float_stats,
	const unsigned int* indices,
	int32_t index_count,
	const float* positions,
	int32_t vertex_count,
	int32_t positions_stride)
{
	meshopt_OverdrawStatistics stats = meshopt_analyzeOverdraw(indices, to_size(index_count), positions, to_size(vertex_count), to_size(positions_stride));
	uint_stats[0] = stats.pixels_covered;
	uint_stats[1] = stats.pixels_shaded;
	float_stats[0] = stats.overdraw;
}

extern "C" MOONBIT_FFI_EXPORT void moonbit_meshopt_analyze_coverage(
	float* float_stats,
	const unsigned int* indices,
	int32_t index_count,
	const float* positions,
	int32_t vertex_count,
	int32_t positions_stride)
{
	meshopt_CoverageStatistics stats = meshopt_analyzeCoverage(indices, to_size(index_count), positions, to_size(vertex_count), to_size(positions_stride));
	float_stats[0] = stats.coverage[0];
	float_stats[1] = stats.coverage[1];
	float_stats[2] = stats.coverage[2];
	float_stats[3] = stats.extent;
}

extern "C" MOONBIT_FFI_EXPORT int32_t moonbit_meshopt_simplify(
	unsigned int* destination,
	float* result_error,
	const unsigned int* indices,
	int32_t index_count,
	const float* positions,
	int32_t vertex_count,
	int32_t positions_stride,
	int32_t target_index_count,
	float target_error,
	uint32_t options)
{
	return (int32_t)meshopt_simplify(destination, indices, to_size(index_count), positions, to_size(vertex_count), to_size(positions_stride), to_size(target_index_count), target_error, options, result_error);
}

extern "C" MOONBIT_FFI_EXPORT int32_t moonbit_meshopt_simplify_with_attributes(
	unsigned int* destination,
	float* result_error,
	const unsigned int* indices,
	int32_t index_count,
	const float* positions,
	int32_t vertex_count,
	int32_t positions_stride,
	const float* attributes,
	int32_t attributes_stride,
	const float* weights,
	int32_t attribute_count,
	const unsigned char* vertex_lock,
	int32_t vertex_lock_length,
	int32_t target_index_count,
	float target_error,
	uint32_t options)
{
	return (int32_t)meshopt_simplifyWithAttributes(
		destination,
		indices,
		to_size(index_count),
		positions,
		to_size(vertex_count),
		to_size(positions_stride),
		attributes,
		to_size(attributes_stride),
		weights,
		to_size(attribute_count),
		optional_bytes(vertex_lock, vertex_lock_length),
		to_size(target_index_count),
		target_error,
			options,
			result_error);
}

extern "C" MOONBIT_FFI_EXPORT int32_t moonbit_meshopt_simplify_with_update(
	unsigned int* indices,
	float* result_error,
	float* positions,
	float* attributes,
	const float* weights,
	const unsigned char* vertex_lock,
	int32_t vertex_lock_length,
	const int32_t* int_params,
	float target_error,
	uint32_t options)
{
	int32_t attribute_count = int_params[4];

	return (int32_t)meshopt_simplifyWithUpdate(
		indices,
		to_size(int_params[0]),
		positions,
		to_size(int_params[1]),
		to_size(int_params[2]),
		attribute_count > 0 ? attributes : 0,
		to_size(int_params[3]),
		optional_float_array(weights, attribute_count),
		to_size(attribute_count),
		optional_bytes(vertex_lock, vertex_lock_length),
		to_size(int_params[5]),
		target_error,
		options,
		result_error);
}

extern "C" MOONBIT_FFI_EXPORT int32_t moonbit_meshopt_simplify_sloppy(
	unsigned int* destination,
	float* result_error,
	const unsigned int* indices,
	int32_t index_count,
	const float* positions,
	int32_t vertex_count,
	int32_t positions_stride,
	const unsigned char* vertex_lock,
	int32_t vertex_lock_length,
	int32_t target_index_count,
	float target_error)
{
	return (int32_t)meshopt_simplifySloppy(destination, indices, to_size(index_count), positions, to_size(vertex_count), to_size(positions_stride), optional_bytes(vertex_lock, vertex_lock_length), to_size(target_index_count), target_error, result_error);
}

extern "C" MOONBIT_FFI_EXPORT int32_t moonbit_meshopt_simplify_prune(
	unsigned int* destination,
	const unsigned int* indices,
	int32_t index_count,
	const float* positions,
	int32_t vertex_count,
	int32_t positions_stride,
	float target_error)
{
	return (int32_t)meshopt_simplifyPrune(destination, indices, to_size(index_count), positions, to_size(vertex_count), to_size(positions_stride), target_error);
}

extern "C" MOONBIT_FFI_EXPORT int32_t moonbit_meshopt_simplify_points(
	unsigned int* destination,
	const float* positions,
	int32_t vertex_count,
	int32_t positions_stride,
	const float* colors,
	int32_t colors_stride,
	float color_weight,
	int32_t target_vertex_count)
{
	return (int32_t)meshopt_simplifyPoints(destination, positions, to_size(vertex_count), to_size(positions_stride), optional_float_array(colors, colors_stride), to_size(colors_stride), color_weight, to_size(target_vertex_count));
}

extern "C" MOONBIT_FFI_EXPORT float moonbit_meshopt_simplify_scale(
	const float* positions,
	int32_t vertex_count,
	int32_t positions_stride)
{
	return meshopt_simplifyScale(positions, to_size(vertex_count), to_size(positions_stride));
}

extern "C" MOONBIT_FFI_EXPORT int32_t moonbit_meshopt_build_meshlets_bound(
	int32_t index_count,
	int32_t max_vertices,
	int32_t max_triangles)
{
	return (int32_t)meshopt_buildMeshletsBound(to_size(index_count), to_size(max_vertices), to_size(max_triangles));
}

extern "C" MOONBIT_FFI_EXPORT int32_t moonbit_meshopt_build_meshlets(
	unsigned int* meshlets,
	unsigned int* meshlet_vertices,
	unsigned char* meshlet_triangles,
	const unsigned int* indices,
	const float* positions,
	const int32_t* int_params,
	const float* float_params)
{
	return (int32_t)meshopt_buildMeshlets(
		(meshopt_Meshlet*)meshlets,
		meshlet_vertices,
		meshlet_triangles,
		indices,
		to_size(int_params[0]),
		positions,
		to_size(int_params[1]),
		to_size(int_params[2]),
		to_size(int_params[3]),
		to_size(int_params[4]),
		float_params[0]);
}

extern "C" MOONBIT_FFI_EXPORT int32_t moonbit_meshopt_build_meshlets_scan(
	unsigned int* meshlets,
	unsigned int* meshlet_vertices,
	unsigned char* meshlet_triangles,
	const unsigned int* indices,
	int32_t index_count,
	int32_t vertex_count,
	int32_t max_vertices,
	int32_t max_triangles)
{
	return (int32_t)meshopt_buildMeshletsScan(
		(meshopt_Meshlet*)meshlets,
		meshlet_vertices,
		meshlet_triangles,
		indices,
		to_size(index_count),
		to_size(vertex_count),
		to_size(max_vertices),
		to_size(max_triangles));
}

extern "C" MOONBIT_FFI_EXPORT void moonbit_meshopt_optimize_meshlet(
	unsigned int* meshlet_vertices,
	unsigned char* meshlet_triangles,
	int32_t triangle_count,
	int32_t vertex_count)
{
	meshopt_optimizeMeshlet(meshlet_vertices, meshlet_triangles, to_size(triangle_count), to_size(vertex_count));
}

extern "C" MOONBIT_FFI_EXPORT void moonbit_meshopt_compute_cluster_bounds(
	float* float_values,
	int32_t* int_values,
	const unsigned int* indices,
	int32_t index_count,
	const float* positions,
	int32_t vertex_count,
	int32_t positions_stride)
{
	write_bounds(float_values, int_values, meshopt_computeClusterBounds(indices, to_size(index_count), positions, to_size(vertex_count), to_size(positions_stride)));
}

extern "C" MOONBIT_FFI_EXPORT void moonbit_meshopt_compute_meshlet_bounds(
	float* float_values,
	int32_t* int_values,
	const unsigned int* meshlet_vertices,
	const unsigned char* meshlet_triangles,
	int32_t triangle_count,
	const float* positions,
	int32_t vertex_count,
	int32_t positions_stride)
{
	write_bounds(float_values, int_values, meshopt_computeMeshletBounds(meshlet_vertices, meshlet_triangles, to_size(triangle_count), positions, to_size(vertex_count), to_size(positions_stride)));
}

extern "C" MOONBIT_FFI_EXPORT void moonbit_meshopt_compute_sphere_bounds(
	float* float_values,
	int32_t* int_values,
	const float* positions,
	int32_t count,
	int32_t positions_stride,
	const float* radii,
	int32_t radii_stride,
	int32_t radii_count)
{
	write_bounds(float_values, int_values, meshopt_computeSphereBounds(positions, to_size(count), to_size(positions_stride), optional_float_array(radii, radii_count), to_size(radii_stride)));
}

extern "C" MOONBIT_FFI_EXPORT void moonbit_meshopt_spatial_sort_remap(
	unsigned int* destination,
	const float* positions,
	int32_t vertex_count,
	int32_t positions_stride)
{
	meshopt_spatialSortRemap(destination, positions, to_size(vertex_count), to_size(positions_stride));
}

extern "C" MOONBIT_FFI_EXPORT void moonbit_meshopt_spatial_sort_triangles(
	unsigned int* destination,
	const unsigned int* indices,
	int32_t index_count,
	const float* positions,
	int32_t vertex_count,
	int32_t positions_stride)
{
	meshopt_spatialSortTriangles(destination, indices, to_size(index_count), positions, to_size(vertex_count), to_size(positions_stride));
}

extern "C" MOONBIT_FFI_EXPORT void moonbit_meshopt_spatial_cluster_points(
	unsigned int* destination,
	const float* positions,
	int32_t vertex_count,
	int32_t positions_stride,
	int32_t cluster_size)
{
	meshopt_spatialClusterPoints(destination, positions, to_size(vertex_count), to_size(positions_stride), to_size(cluster_size));
}

extern "C" MOONBIT_FFI_EXPORT void moonbit_meshopt_generate_tangents(
	float* result,
	const unsigned int* indices,
	int32_t index_count,
	const float* positions,
	int32_t vertex_count,
	int32_t positions_stride,
	const float* normals,
	int32_t normals_stride,
	const float* uvs,
	int32_t uvs_stride,
	uint32_t options)
{
	meshopt_generateTangents(result, indices, to_size(index_count), positions, to_size(vertex_count), to_size(positions_stride), normals, to_size(normals_stride), uvs, to_size(uvs_stride), options);
}

extern "C" MOONBIT_FFI_EXPORT int32_t moonbit_meshopt_compute_position_exponent(
	const float* minv,
	const float* maxv,
	int32_t min_exp,
	int32_t max_bits)
{
	return meshopt_computePositionExponent(minv, maxv, min_exp, max_bits);
}

extern "C" MOONBIT_FFI_EXPORT int32_t moonbit_meshopt_generate_vertex_remap_multi_unindexed(
	unsigned int* destination,
	const unsigned char* source,
	int32_t vertex_count,
	const int32_t* offsets,
	const int32_t* sizes,
	const int32_t* strides,
	int32_t stream_count)
{
	meshopt_Stream streams[16];
	size_t count = make_streams(streams, source, offsets, sizes, strides, stream_count);
	return (int32_t)meshopt_generateVertexRemapMulti(destination, 0, to_size(vertex_count), to_size(vertex_count), streams, count);
}

extern "C" MOONBIT_FFI_EXPORT int32_t moonbit_meshopt_generate_vertex_remap_multi_indexed(
	unsigned int* destination,
	const unsigned int* indices,
	int32_t index_count,
	const unsigned char* source,
	int32_t vertex_count,
	const int32_t* offsets,
	const int32_t* sizes,
	const int32_t* strides,
	int32_t stream_count)
{
	meshopt_Stream streams[16];
	size_t count = make_streams(streams, source, offsets, sizes, strides, stream_count);
	return (int32_t)meshopt_generateVertexRemapMulti(destination, indices, to_size(index_count), to_size(vertex_count), streams, count);
}

extern "C" MOONBIT_FFI_EXPORT void moonbit_meshopt_generate_shadow_index_buffer_multi(
	unsigned int* destination,
	const unsigned int* indices,
	int32_t index_count,
	const unsigned char* source,
	int32_t vertex_count,
	const int32_t* offsets,
	const int32_t* sizes,
	const int32_t* strides,
	int32_t stream_count)
{
	meshopt_Stream streams[16];
	size_t count = make_streams(streams, source, offsets, sizes, strides, stream_count);
	meshopt_generateShadowIndexBufferMulti(destination, indices, to_size(index_count), to_size(vertex_count), streams, count);
}

extern "C" MOONBIT_FFI_EXPORT int32_t moonbit_meshopt_generate_vertex_remap_custom_no_callback(
	unsigned int* destination,
	const float* positions,
	int32_t vertex_count,
	int32_t positions_stride)
{
	return (int32_t)meshopt_generateVertexRemapCustom(destination, 0, to_size(vertex_count), positions, to_size(vertex_count), to_size(positions_stride), 0, 0);
}

extern "C" MOONBIT_FFI_EXPORT int32_t moonbit_meshopt_generate_vertex_remap_custom(
	unsigned int* destination,
	const unsigned int* indices,
	int32_t index_count,
	const float* positions,
	int32_t vertex_count,
	int32_t positions_stride,
	int32_t (*callback)(void*, unsigned int, unsigned int),
	void* context)
{
	return (int32_t)meshopt_generateVertexRemapCustom(destination, indices, to_size(index_count), positions, to_size(vertex_count), to_size(positions_stride), callback, context);
}

extern "C" MOONBIT_FFI_EXPORT int32_t moonbit_meshopt_encode_meshlet_bound(int32_t max_vertices, int32_t max_triangles)
{
	return (int32_t)meshopt_encodeMeshletBound(to_size(max_vertices), to_size(max_triangles));
}

extern "C" MOONBIT_FFI_EXPORT int32_t moonbit_meshopt_encode_meshlet(
	unsigned char* buffer,
	int32_t buffer_size,
	const unsigned int* vertices,
	int32_t vertex_count,
	const unsigned char* triangles,
	int32_t triangle_count)
{
	return (int32_t)meshopt_encodeMeshlet(buffer, to_size(buffer_size), vertices, to_size(vertex_count), triangles, to_size(triangle_count));
}

extern "C" MOONBIT_FFI_EXPORT int32_t moonbit_meshopt_decode_meshlet_raw(
	unsigned int* vertices,
	int32_t vertex_count,
	unsigned int* triangles,
	int32_t triangle_count,
	const unsigned char* buffer,
	int32_t buffer_size)
{
	return meshopt_decodeMeshletRaw(vertices, to_size(vertex_count), triangles, to_size(triangle_count), buffer, to_size(buffer_size));
}

extern "C" MOONBIT_FFI_EXPORT int32_t moonbit_meshopt_decode_meshlet(
	unsigned char* vertices,
	int32_t vertex_count,
	int32_t vertex_size,
	unsigned char* triangles,
	int32_t triangle_count,
	int32_t triangle_size,
	const unsigned char* buffer,
	int32_t buffer_size)
{
	return meshopt_decodeMeshlet(vertices, to_size(vertex_count), to_size(vertex_size), triangles, to_size(triangle_count), to_size(triangle_size), buffer, to_size(buffer_size));
}

extern "C" MOONBIT_FFI_EXPORT int32_t moonbit_meshopt_build_meshlets_flex(
	unsigned int* meshlets,
	unsigned int* meshlet_vertices,
	unsigned char* meshlet_triangles,
	const unsigned int* indices,
	const float* positions,
	const int32_t* int_params,
	const float* float_params)
{
	return (int32_t)meshopt_buildMeshletsFlex(
		(meshopt_Meshlet*)meshlets,
		meshlet_vertices,
		meshlet_triangles,
		indices,
		to_size(int_params[0]),
		positions,
		to_size(int_params[1]),
		to_size(int_params[2]),
		to_size(int_params[3]),
		to_size(int_params[4]),
		to_size(int_params[5]),
		float_params[0],
		float_params[1]);
}

extern "C" MOONBIT_FFI_EXPORT int32_t moonbit_meshopt_build_meshlets_spatial(
	unsigned int* meshlets,
	unsigned int* meshlet_vertices,
	unsigned char* meshlet_triangles,
	const unsigned int* indices,
	const float* positions,
	const int32_t* int_params,
	const float* float_params)
{
	return (int32_t)meshopt_buildMeshletsSpatial(
		(meshopt_Meshlet*)meshlets,
		meshlet_vertices,
		meshlet_triangles,
		indices,
		to_size(int_params[0]),
		positions,
		to_size(int_params[1]),
		to_size(int_params[2]),
		to_size(int_params[3]),
		to_size(int_params[4]),
		to_size(int_params[5]),
		float_params[0]);
}

extern "C" MOONBIT_FFI_EXPORT void moonbit_meshopt_optimize_meshlet_level(
	unsigned int* meshlet_vertices,
	int32_t vertex_count,
	unsigned char* meshlet_triangles,
	int32_t triangle_count,
	int32_t level)
{
	meshopt_optimizeMeshletLevel(meshlet_vertices, to_size(vertex_count), meshlet_triangles, to_size(triangle_count), level);
}

extern "C" MOONBIT_FFI_EXPORT int32_t moonbit_meshopt_extract_meshlet_indices(
	unsigned int* vertices,
	unsigned char* triangles,
	const unsigned int* indices,
	int32_t index_count)
{
	return (int32_t)meshopt_extractMeshletIndices(vertices, triangles, indices, to_size(index_count));
}

extern "C" MOONBIT_FFI_EXPORT int32_t moonbit_meshopt_partition_clusters(
	unsigned int* destination,
	const unsigned int* cluster_indices,
	int32_t total_index_count,
	const unsigned int* cluster_index_counts,
	int32_t cluster_count,
	const float* positions,
	int32_t vertex_count,
	int32_t positions_stride,
	int32_t target_partition_size)
{
	return (int32_t)meshopt_partitionClusters(destination, cluster_indices, to_size(total_index_count), cluster_index_counts, to_size(cluster_count), positions, to_size(vertex_count), to_size(positions_stride), to_size(target_partition_size));
}

extern "C" MOONBIT_FFI_EXPORT int32_t moonbit_meshopt_opacity_map_measure(
	unsigned char* levels,
	unsigned int* sources,
	int32_t* omm_indices,
	const unsigned int* indices,
	const float* uvs,
	const int32_t* int_params,
	float target_edge)
{
	return (int32_t)meshopt_opacityMapMeasure(levels, sources, omm_indices, indices, to_size(int_params[0]), uvs, to_size(int_params[1]), to_size(int_params[2]), (unsigned int)int_params[3], (unsigned int)int_params[4], int_params[5], target_edge);
}

extern "C" MOONBIT_FFI_EXPORT void moonbit_meshopt_opacity_map_rasterize(
	unsigned char* result,
	const float* uv0,
	const float* uv1,
	const float* uv2,
	const unsigned char* texture_data,
	const int32_t* int_params)
{
	meshopt_opacityMapRasterize(result, int_params[0], int_params[1], uv0, uv1, uv2, texture_data, to_size(int_params[2]), to_size(int_params[3]), (unsigned int)int_params[4], (unsigned int)int_params[5]);
}

extern "C" MOONBIT_FFI_EXPORT int32_t moonbit_meshopt_opacity_map_entry_size(int32_t level, int32_t states)
{
	return (int32_t)meshopt_opacityMapEntrySize(level, states);
}

extern "C" MOONBIT_FFI_EXPORT int32_t moonbit_meshopt_opacity_map_compact(
	unsigned char* data,
	int32_t data_size,
	unsigned char* levels,
	unsigned int* offsets,
	int32_t omm_count,
	int32_t* omm_indices,
	int32_t triangle_count,
	int32_t states)
{
	return (int32_t)meshopt_opacityMapCompact(data, to_size(data_size), levels, offsets, to_size(omm_count), omm_indices, to_size(triangle_count), states);
}
