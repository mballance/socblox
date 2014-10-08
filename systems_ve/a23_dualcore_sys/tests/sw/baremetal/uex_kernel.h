
#ifndef INCLUDED_UES_KERNEL_H
#define INCLUDED_UES_KERNEL_H
#include "uth.h"

/**
 * Data structure to represent a core
 */
typedef struct uex_ccb_s {
	void					*start_addr;
	void					*msg;

} uex_ccb_t;

#endif /* INCLUDED_UES_KERNEL_H */
