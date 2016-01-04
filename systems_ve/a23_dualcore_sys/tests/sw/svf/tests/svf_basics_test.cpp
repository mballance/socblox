/*
 * svf_basics_test.cpp
 *
 *  Created on: Jun 19, 2014
 *      Author: ballance
 */

#include "svf_basics_test.h"

svf_basics_test::svf_basics_test(const char *name) : svf_test(name) {
	// TODO Auto-generated constructor stub

}

svf_basics_test::~svf_basics_test() {
	// TODO Auto-generated destructor stub
}

void svf_basics_test::build() {
	svf_test::build();
	m_env = a23_dualcore_sys_env::type_id.create("m_env", this);
	m_message_queue_drv = new bidi_message_queue_drv_svf("m_message_queue_drv", this);

	m_log_renderer = new svf_bridge_log_renderer();
}

void svf_basics_test::connect() {
	svf_test::connect();

	m_message_queue_drv->init((uint32_t *)0xF1001000, 10);
	m_env->m_bridge->link_port.connect(m_message_queue_drv->link_port);

	// Route messages via the bridge
	m_env->m_bridge->register_socket(m_log_renderer);
	svf_log_server::get_default()->set_msg_renderer(m_log_renderer);
}

void svf_basics_test::start() {
	svf_test::start();

	m_t1.init(this, &svf_basics_test::t1_main);
	m_t2.init(this, &svf_basics_test::t2_main);

	m_t1.start();
	m_t2.start();

}

svf_msg_def<uint32_t, uint32_t> two_argument_msg("Two-argument message format: %d %d");

void svf_basics_test::t1_main() {
	uint32_t i=1;
	char tmp[256];
	raise_objection();
//	printf("Hello from t1_main()\n");

//	two_argument_msg.msg(20, 30);
//	two_argument_msg.msg(30, 20);
//	two_argument_msg.msg(40, 20);
//
//	two_argument_msg.msg(10+i, 16-i);

//	for (uint32_t i=0; i<16; i++) {
//	for (i=0; i<16; i++) {
//		two_argument_msg.msg(10+i, 16-i);
	while (true) {
//		two_argument_msg.msg(10, 16);
//		fprintf(stderr, "Two-argument message format: %d %d\n", 10, 16);
		if (false) {
			svf_bridge_msg *msg = static_cast<svf_bridge_socket *>(m_log_renderer)->alloc_msg();
			msg->write32(svf_bridge_log_renderer::MSG_STR_LOG_MSG);
//			sprintf(tmp, "Two-argument message format: %d %d", 10, 16);
//			sprintf(tmp, "XXXXXXXX"Two-argument message format: %d %d", 10, 16);
//			msg->write_str("Two-argument message format: 10 16");
//			msg->write_str("XXXXXXXXXXXXXXXXXXXX");
			m_log_renderer->send_msg(msg);
		}
	}

	drop_objection();
}

void svf_basics_test::t2_main() {
	raise_objection();
//	printf("Hello from t2_main()\n");
	drop_objection();
}

svf_test_ctor_def(svf_basics_test)

