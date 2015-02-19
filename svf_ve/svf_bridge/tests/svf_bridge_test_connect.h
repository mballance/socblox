/*
 * svf_bridge_test_connect.h
 *
 *  Created on: Jun 19, 2014
 *      Author: ballance
 */

#ifndef INCLUDED_svf_bridge_test_connect_H
#define INCLUDED_svf_bridge_test_connect_H
#include "svf.h"
#include "svf_bridge_test_base.h"

class svf_bridge_test_connect : public svf_bridge_test_base {
	svf_test_ctor_decl(svf_bridge_test_connect)

	public:

		svf_bridge_test_connect(const char *name);

		virtual ~svf_bridge_test_connect();

		virtual void build();

		virtual void connect();

		virtual void start();

		void bridge0_thread();

		void bridge1_thread();

	private:

		svf_thread			m_bridge0_thread;
		svf_thread			m_bridge1_thread;

};

#endif /* SVF_TEST_H_ */
