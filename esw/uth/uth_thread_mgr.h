/*
 * uth_thread_mgr.h
 *
 *  Created on: Jun 1, 2014
 *      Author: ballance
 */

#ifndef UTH_THREAD_MGR_H_
#define UTH_THREAD_MGR_H_
#include "uth.h"

class uth_thread_mgr {

	public:
		uth_thread_mgr();

		virtual ~uth_thread_mgr();

		// Start the manager
		virtual void init() = 0;

		virtual uth_thread_t *current_thread() = 0;

		virtual void thread_create(uth_thread_t *thread) = 0;

		virtual void thread_end(uth_thread_t *thread) = 0;

		virtual void block_thread(uth_thread_t *thread) = 0;

		virtual void unblock_thread(uth_thread_t *thread) = 0;

		virtual void yield() = 0;

};

#endif /* UTH_THREAD_MGR_H_ */
