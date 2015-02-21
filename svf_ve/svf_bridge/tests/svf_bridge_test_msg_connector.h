/*
 * svf_bridge_test_msg_connector.h
 *
 *  Created on: Jun 19, 2014
 *      Author: ballance
 */

#ifndef INCLUDED_svf_bridge_test_msg_connector_H
#define INCLUDED_svf_bridge_test_msg_connector_H
#include "svf.h"
#include "svf_bridge_test_base.h"

class svf_bridge_test_msg_connector : public svf_bridge_test_base {
	svf_test_ctor_decl(svf_bridge_test_msg_connector)

	public:

		svf_bridge_test_msg_connector(const char *name);

		virtual ~svf_bridge_test_msg_connector();

		virtual void build();

		virtual void connect();

		virtual void start();

	private:

		void thread0();

		void thread1();

	private:

		svf_thread					m_thread0;
		svf_thread					m_thread1;

		svf_log_server				*m_dest_svr;

};

#endif /* SVF_TEST_H_ */
