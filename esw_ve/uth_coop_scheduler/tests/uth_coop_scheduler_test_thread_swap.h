/*
 * uth_coop_scheduler_test_thread_swap.h
 *
 *  Created on: Jun 19, 2014
 *      Author: ballance
 */

#ifndef INCLUDED_uth_coop_scheduler_test_thread_swap_H
#define INCLUDED_uth_coop_scheduler_test_thread_swap_H
#include "svf.h"
#include "uth_coop_scheduler_test_base.h"
#include "uth.h"

class uth_coop_scheduler_test_thread_swap : public uth_coop_scheduler_test_base {
	svf_test_ctor_decl(uth_coop_scheduler_test_thread_swap)

	public:

		uth_coop_scheduler_test_thread_swap(const char *name);

		virtual ~uth_coop_scheduler_test_thread_swap();

		virtual void build();

		virtual void connect();

		virtual void start();

		static void thread(void *ud);

	private:
		uth_thread_t			*threads;
		uint32_t				*thread_activated;

};

#endif /* SVF_TEST_H_ */
