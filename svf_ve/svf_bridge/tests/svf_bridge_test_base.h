/*
 * svf_bridge_test_base.h
 *
 *  Created on: Jan 11, 2014
 *      Author: ballance
 */

#ifndef svf_bridge_TEST_BASE_H_
#define svf_bridge_TEST_BASE_H_
#include "svf.h"
#include "svf_bridge_env.h"

class svf_bridge_test_base : public svf_test {
	svf_test_ctor_decl(svf_bridge_test_base)

	public:
		svf_bridge_test_base(const char *name);

		virtual ~svf_bridge_test_base();

		virtual void build();

		virtual void connect();

		virtual void start();

		virtual void run();

		virtual void shutdown();

	protected:

		svf_bridge_env				*m_env;
		svf_thread						m_runthread;
};

#endif /* svf_bridge_TEST_BASE_H_ */
