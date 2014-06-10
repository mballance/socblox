#ifndef INCLUDED_UEX_TARGET_TYPES_H
#define INCLUDED_UEX_TARGET_TYPES_H
#include <stdint.h>

typedef struct uex_thread_context_s {
	uint32_t			regs[16];
} uex_thread_context_t;

typedef volatile uint32_t uex_thread_mutex_impl_t;

#endif /* INCLUDED_UEX_TARGET_TYPES_H */
