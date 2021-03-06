/*
 * a23_dualcore_sys_msg_queue_smoke_test.h
 *
 *  Created on: Jun 19, 2014
 *      Author: ballance
 */

#ifndef INCLUDED_a23_dualcore_sys_msg_queue_smoke_test_H
#define INCLUDED_a23_dualcore_sys_msg_queue_smoke_test_H
#include "svf.h"
#include "a23_dualcore_sys_test_base.h"

class a23_dualcore_sys_msg_queue_smoke_test : public a23_dualcore_sys_test_base {
	svf_test_ctor_decl(a23_dualcore_sys_msg_queue_smoke_test)

	public:

		a23_dualcore_sys_msg_queue_smoke_test(const char *name);

		virtual ~a23_dualcore_sys_msg_queue_smoke_test();

		virtual void build();

		virtual void connect();

		virtual void start();

		void run();

		void outbound_thread();

		void inbound_thread();

	private:

		svf_thread						m_run;
		svf_thread						m_inbound;
		svf_thread						m_outbound;
		uint32_t						m_entry;
		svf_stdio_msg_renderer			*m_log_renderer;
		svf_bridge_log_connector		*m_log_connector;

};

#endif /* SVF_TEST_H_ */
