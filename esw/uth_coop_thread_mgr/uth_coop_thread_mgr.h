/*
 * uth_coop_thread_mgr.h
 *
 *  Created on: Jun 1, 2014
 *      Author: ballance
 */

#ifndef UTH_COOP_THREAD_MGR_H_
#define UTH_COOP_THREAD_MGR_H_

#include "uth_thread_mgr.h"

class uth_coop_thread_mgr: public virtual uth_thread_mgr {

	public:

		uth_coop_thread_mgr();

		virtual ~uth_coop_thread_mgr();

		// Start the manager
		virtual void init();

		virtual uth_thread_t *current_thread();

		virtual void thread_create(uth_thread_t *thread);

		virtual void thread_end(uth_thread_t *thread);

		virtual void block_thread(uth_thread_t *thread);

		virtual void unblock_thread(uth_thread_t *thread);

		virtual void yield();

	private:
		static void scheduler_main(void *ud);

		void scheduler_main();

		void unlink_thread(uth_thread_t **list, uth_thread_t *thread);

		void append_thread(uth_thread_t **list, uth_thread_t *thread);

	private:
		uth_thread_t					m_main_thread;
		uth_thread_t					m_scheduler_thread;
		uth_mutex_t						m_mutex;

		uth_thread_t					*m_curr_thread;

		uth_thread_t					*m_active_thread_list;
		uth_thread_t					*m_blocked_thread_list;

};

#endif /* UTH_COOP_THREAD_MGR_H_ */
