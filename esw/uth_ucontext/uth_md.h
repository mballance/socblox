/****************************************************************************
 * uth_md.h
 ****************************************************************************/
#include <ucontext.h>
#include <stdint.h>

typedef ucontext_t uth_thread_ctxt_md_t;

typedef struct uth_mutex_md_s {
	uint32_t			locked;
} uth_mutex_md_t;
