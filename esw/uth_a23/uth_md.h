/*
 * uth_md.h
 *
 *  Created on: Jun 1, 2014
 *      Author: ballance
 */

#ifndef UTH_MD_H_
#define UTH_MD_H_

typedef struct uth_thread_ctxt_md_s {
	uint32_t				regs[16];
} uth_thread_ctxt_md_t;

typedef struct uth_mutex_md_s {
	uint32_t				m;
} uth_mutex_md_t;

#endif /* UTH_MD_H_ */
