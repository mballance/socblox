/*
 * svf_bridge_test_connect.cpp
 *
 *  Created on: Jun 19, 2014
 *      Author: ballance
 */

#include "svf_bridge_test_connect.h"

svf_bridge_test_connect::svf_bridge_test_connect(const char *name) : svf_bridge_test_base(name) {
	// TODO Auto-generated constructor stub

}

svf_bridge_test_connect::~svf_bridge_test_connect() {
	// TODO Auto-generated destructor stub
}

void svf_bridge_test_connect::build() {
	svf_bridge_test_base::build();
}

void svf_bridge_test_connect::connect() {
	svf_bridge_test_base::connect();
}

void svf_bridge_test_connect::start() {
	svf_bridge_test_base::start();

	m_bridge0_thread.init(this, &svf_bridge_test_connect::bridge0_thread);
	m_bridge1_thread.init(this, &svf_bridge_test_connect::bridge1_thread);
	m_bridge0_thread.start();
	m_bridge1_thread.start();
}

void svf_bridge_test_connect::bridge0_thread() {
	raise_objection();

	svf_bridge_socket *s = new svf_bridge_socket("foo", "bar");

	m_env->m_bridge0->register_socket(s);
	fprintf(stdout, "--> wait_connected 0\n");
	s->wait_connected();
	fprintf(stdout, "<-- wait_connected 0\n");

	for (uint32_t i=0; i<16; i++) {
		svf_bridge_msg *msg = s->alloc_msg();
		msg->write_str("Hello World from 0");
		msg->write32(i);
		s->send_msg(msg);

		msg = s->recv_msg();
//		svf_string str;
//		msg->read_str(str);
		uint32_t rsp = msg->read32();

		if (rsp == i+1) {
			fprintf(stdout, "SUCCESS: %d\n", rsp);
		} else {
			fprintf(stdout, "ERROR: %d\n", rsp);
		}
	}

	drop_objection();
}

void svf_bridge_test_connect::bridge1_thread() {
//	raise_objection();

	svf_bridge_socket *s = new svf_bridge_socket("foo", "bar");

	m_env->m_bridge1->register_socket(s);
	fprintf(stdout, "--> wait_connected 1\n");
	s->wait_connected();
	fprintf(stdout, "<-- wait_connected 1\n");

	while (1) {
	svf_bridge_msg *msg = s->recv_msg();
	svf_string str;

	msg->read_str(str);
	uint32_t r = msg->read32();

	fprintf(stdout, "Message: %s\n", str.c_str());

	s->free_msg(msg);
	msg = s->alloc_msg();
	msg->write32(r+1);

	s->send_msg(msg);
	}

//	drop_objection();
}

svf_test_ctor_def(svf_bridge_test_connect)

