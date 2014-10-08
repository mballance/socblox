
#include "uth.h"

static uth_mutex_t				prv_malloc_mutex = UTH_MUTEX_STATIC_INIT;

extern "C" void __malloc_lock(struct _reent *reent)
{
	uth_mutex_lock(&prv_malloc_mutex);
}

extern "C" void __malloc_unlock(struct _reent *reent)
{
	uth_mutex_unlock(&prv_malloc_mutex);
}
