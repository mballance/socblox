/*
 * uth_coop_scheduler_test_base.h
 *
 *  Created on: Jan 11, 2014
 *      Author: ballance
 */

#ifndef uth_coop_scheduler_TEST_BASE_H_
#define uth_coop_scheduler_TEST_BASE_H_
#include "svf.h"
#include "uth_coop_scheduler_env.h"

class uth_coop_scheduler_test_base : public svf_test {
	svf_test_ctor_decl(uth_coop_scheduler_test_base)

	public:
		uth_coop_scheduler_test_base(const char *name);

		virtual ~uth_coop_scheduler_test_base();

		virtual void build();

		virtual void connect();

		virtual void start();

		virtual void run();

		virtual void shutdown();

	protected:

		uth_coop_scheduler_env				*m_env;
		svf_thread						m_runthread;
};

#endif /* uth_coop_scheduler_TEST_BASE_H_ */
