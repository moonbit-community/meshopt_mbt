// This file is part of meshoptimizer library; see meshoptimizer.h for version/license details
#include "meshoptimizer.h"

#include <assert.h>
#include <stdlib.h>

static void* meshopt_mbt_allocate(size_t size)
{
	return malloc(size);
}

static void meshopt_mbt_deallocate(void* ptr)
{
	free(ptr);
}

#ifdef MESHOPTIMIZER_ALLOC_EXPORT
meshopt_Allocator::Storage& meshopt_Allocator::storage()
{
	static Storage s = {meshopt_mbt_allocate, meshopt_mbt_deallocate};
	return s;
}
#endif

void meshopt_setAllocator(void* (MESHOPTIMIZER_ALLOC_CALLCONV* allocate)(size_t), void (MESHOPTIMIZER_ALLOC_CALLCONV* deallocate)(void*))
{
	assert(allocate && deallocate);

	meshopt_Allocator::Storage& s = meshopt_Allocator::storage();
	s.allocate = allocate;
	s.deallocate = deallocate;
}
