/*
 * a23_mini_sys_test_base.h
 *
 *  Created on: Jan 11, 2014
 *      Author: ballance
 */

#ifndef a23_mini_sys_TEST_BASE_H_
#define a23_mini_sys_TEST_BASE_H_
#include "svf.h"
#include "a23_mini_sys_env.h"

class a23_mini_sys_test_base : public svf_test {
	svf_test_ctor_decl(a23_mini_sys_test_base)

	public:
		a23_mini_sys_test_base(const char *name);

		virtual ~a23_mini_sys_test_base();

		virtual void build();

		virtual void connect();

		virtual void start();

		virtual void run();

		virtual void shutdown();

	protected:

		a23_mini_sys_env				*m_env;
		svf_thread						m_runthread;
};

#endif /* a23_mini_sys_TEST_BASE_H_ */
