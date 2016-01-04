/*
 * svf_basics_test.h
 *
 *  Created on: Jun 19, 2014
 *      Author: ballance
 */

#ifndef INCLUDED_svf_basics_test_H
#define INCLUDED_svf_basics_test_H
#include "svf.h"
#include "svf_test.h"
#include "a23_dualcore_sys_env.h"
#include "bidi_message_queue_drv_svf.h"

class svf_basics_test : public svf_test {
	svf_test_ctor_decl(svf_basics_test)

	public:

		svf_basics_test(const char *name);

		virtual ~svf_basics_test();

		virtual void build();

		virtual void connect();

		virtual void start();

	protected:

		void t1_main();
		void t2_main();

	private:


		a23_dualcore_sys_env		*m_env;
		svf_thread					m_t1;
		svf_thread					m_t2;


		bidi_message_queue_drv_svf	*m_message_queue_drv;
		svf_bridge_log_renderer		*m_log_renderer;

};

#endif /* SVF_TEST_H_ */
