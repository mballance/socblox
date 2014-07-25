/*
 * a23_dualcore_sys_bringup_test.h
 *
 *  Created on: Jun 19, 2014
 *      Author: ballance
 */

#ifndef INCLUDED_a23_dualcore_sys_bringup_test_H
#define INCLUDED_a23_dualcore_sys_bringup_test_H
#include "svf.h"
#include "a23_dualcore_sys_test_base.h"

class a23_dualcore_sys_bringup_test : public a23_dualcore_sys_test_base {
	svf_test_ctor_decl(a23_dualcore_sys_bringup_test)

	public:

		a23_dualcore_sys_bringup_test(const char *name);

		virtual ~a23_dualcore_sys_bringup_test();

		virtual void build();

		virtual void connect();

		virtual void start();

		void core0_msg_thread();

	private:

		svf_thread					m_core0_msg_thread;
		svf_thread					m_core1_msg_thread;

};

#endif /* SVF_TEST_H_ */
