/*
 * svf_bridge_test_msg_connector.cpp
 *
 *  Created on: Jun 19, 2014
 *      Author: ballance
 */

#include "svf_bridge_test_msg_connector.h"

svf_bridge_test_msg_connector::svf_bridge_test_msg_connector(const char *name) : svf_bridge_test_base(name) {
	// TODO Auto-generated constructor stub

}

svf_bridge_test_msg_connector::~svf_bridge_test_msg_connector() {
	// TODO Auto-generated destructor stub
}

void svf_bridge_test_msg_connector::build() {
	svf_bridge_test_base::build();
}

void svf_bridge_test_msg_connector::connect() {
	svf_bridge_test_base::connect();

}

void svf_bridge_test_msg_connector::start() {
	svf_bridge_test_base::start();

	m_dest_svr = new svf_log_server();
	svf_stdio_msg_renderer *r = new svf_stdio_msg_renderer();
	r->init(stdout, m_dest_svr);
	m_dest_svr->set_msg_renderer(r);
	svf_bridge_log_connector *c = new svf_bridge_log_connector(m_dest_svr);
	m_env->m_bridge1->register_socket(c);

	m_thread0.init(this, &svf_bridge_test_msg_connector::thread0);
	m_thread0.start();
	m_thread1.init(this, &svf_bridge_test_msg_connector::thread1);
	m_thread1.start();
}

svf_msg_def<uint32_t, const char *> my_msg("Hello World: %d %s");

void svf_bridge_test_msg_connector::thread0() {
	raise_objection();

	svf_log_server *svr = new svf_log_server();
	svf_bridge_log_renderer *r = new svf_bridge_log_renderer();
	svr->set_msg_renderer(r);
	svf_log_handle *dflt = svr->get_log_handle(0);

	m_env->m_bridge0->register_socket(r);

	for (uint32_t i=0; i<16; i++) {
		my_msg.msg(dflt, i, "My String");
	}

	drop_objection();
}

void svf_bridge_test_msg_connector::thread1() {
}

svf_test_ctor_def(svf_bridge_test_msg_connector)

