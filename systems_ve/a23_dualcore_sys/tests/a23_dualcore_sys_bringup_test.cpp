/*
 * a23_dualcore_sys_bringup_test.cpp
 *
 *  Created on: Jun 19, 2014
 *      Author: ballance
 */

#include "a23_dualcore_sys_bringup_test.h"

a23_dualcore_sys_bringup_test::a23_dualcore_sys_bringup_test(const char *name) : a23_dualcore_sys_test_base(name) {
	// TODO Auto-generated constructor stub

}

a23_dualcore_sys_bringup_test::~a23_dualcore_sys_bringup_test() {
	// TODO Auto-generated destructor stub
}

void a23_dualcore_sys_bringup_test::build() {
	a23_dualcore_sys_test_base::build();
}

void a23_dualcore_sys_bringup_test::connect() {
	a23_dualcore_sys_test_base::connect();
}

void a23_dualcore_sys_bringup_test::start() {
	a23_dualcore_sys_test_base::start();
}

void a23_dualcore_sys_bringup_test::core0_msg_thread() {
	uint32_t sz;
	uint32_t buf_sz = 4096;
	uint32_t *buf = new uint32_t[buf_sz];
	char *str = new char[4*buf_sz];


	while (true) {
		sz = m_env->m_msg_queue_0->get_next_message_sz();

		if (sz > buf_sz) {
			// TODO
		}

		m_env->m_msg_queue_0->read_next_message(buf);

		for (uint32_t i=0; i<4*sz; i++) {
			uint32_t w = buf[i/4];
			uint32_t off = i%4;

			str[i] = w >> 8*off;
		}

		fprintf(stdout, "MSG: %s", str);
	}

}

svf_test_ctor_def(a23_dualcore_sys_bringup_test)

