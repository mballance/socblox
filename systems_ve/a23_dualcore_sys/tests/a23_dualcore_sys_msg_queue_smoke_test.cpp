/*
 * a23_dualcore_sys_msg_queue_smoke_test.cpp
 *
 *  Created on: Jun 19, 2014
 *      Author: ballance
 */

#include "a23_dualcore_sys_msg_queue_smoke_test.h"
#include "svf_elf_loader.h"
#include "svf_msg_def.h"
#include <string.h>

a23_dualcore_sys_msg_queue_smoke_test::a23_dualcore_sys_msg_queue_smoke_test(const char *name) : a23_dualcore_sys_test_base(name) {
	fprintf(stdout, "--> test::ctor(%s)\n", name);
	// TODO Auto-generated constructor stub

	fprintf(stdout, "<-- test::ctor(%s)\n", name);
}

a23_dualcore_sys_msg_queue_smoke_test::~a23_dualcore_sys_msg_queue_smoke_test() {
	// TODO Auto-generated destructor stub
}

void a23_dualcore_sys_msg_queue_smoke_test::build() {
	a23_dualcore_sys_test_base::build();
}

void a23_dualcore_sys_msg_queue_smoke_test::connect() {
	a23_dualcore_sys_test_base::connect();
}

svf_msg_def<uint32_t, const char *,uint32_t> my_msg("Hello World: %d %s %d");

void a23_dualcore_sys_msg_queue_smoke_test::start() {
	fprintf(stdout, "--> start()\n");
	a23_dualcore_sys_test_base::start();

	my_msg.msg(5, "Hello Too", 25);

	svf_string target_exe;
	if (!cmdline().valueplusarg("TARGET_EXE=", target_exe)) {

	}

	svf_elf_loader loader(m_env->m_mem_mgr);

	int ret = loader.load(target_exe.c_str());

	m_entry = loader.get_entry();

	uint32_t msg[4096];

	char *argv[] = {
			"+SVF_TESTNAME=svf_basics_test",
			"arg2",
			"arg3",
			"arg4"
	};


	msg[0] = 1; // GO_MSG
	msg[1] = loader.get_entry(); // Address
	msg[2] = 2; // argc
	uint32_t arg_off = 4*3 + 4*msg[2]; // argc
	uint32_t str_len=0;

	for (uint32_t i=0; i<msg[2]; i++) {
		uint32_t len = strlen(argv[i])+1;
		msg[3+i] = arg_off;
		memcpy(((uint8_t *)msg)+arg_off, argv[i], len);
		arg_off += len;
		str_len += len;
	}

	uint32_t msg_len = 3 + msg[2] + ((str_len-1)/4)+1;

	m_env->m_msg_queue_0->write_message(msg_len, msg);

	// Wait for an ack
	uint32_t sz = m_env->m_msg_queue_0->get_next_message_sz();

	m_env->m_msg_queue_0->read_next_message(msg);

	m_inbound.init(this, &a23_dualcore_sys_msg_queue_smoke_test::inbound_thread);
	m_inbound.start();

//	m_outbound.init(this, &a23_dualcore_sys_msg_queue_smoke_test::outbound_thread);
//	m_outbound.start();

}

void a23_dualcore_sys_msg_queue_smoke_test::inbound_thread() {
//	uint32_t msg[4096];
//	uint32_t msg_sz = 4;
//
	raise_objection();
//	fprintf(stdout, "--> inbound_thread\n");
//	fflush(stdout);
//
//	msg[0] = 0; // LOAD_MSG
//	msg[1] = 0x03000000; // Address
//	msg[2] = 1024; // size
//
//	msg[0] = 1; // GO_MSG
//	msg[1] = m_entry; // Address
//	msg[2] = 0; // argc
//	msg[3] = 0; // argv
//	m_env->m_msg_queue_0->write_message(4, msg);

//	msg[3] = 0x55aaeeff; // data

//	for (uint32_t j=0; j<16; j++) {
//		for (uint32_t i=0; i<msg[2]; i+=4) {
//			msg[3+i/4] = (j << 24)+0x00aaee00+(i/4);
//		}
//		uint32_t msg_sz = ((msg[2]-1)/4)+1;
//		msg_sz += 3;
//
//		m_env->m_msg_queue_0->write_message(msg_sz, msg);
//		//		msg[1] += 4; // increment address
//	}
//
//	fprintf(stdout, "<-- inbound_thread\n");
//	fflush(stdout);
//	drop_objection();
}

void a23_dualcore_sys_msg_queue_smoke_test::outbound_thread() {
	uint32_t sz;
	uint32_t msg[4096];

	raise_objection();
	fprintf(stdout, "--> outbound_thread\n");
	fflush(stdout);

	for (uint32_t j=0; j<16; j++) {
		fprintf(stdout, "--> outbound: get_next_message_sz %d\n", j);
		sz = m_env->m_msg_queue_0->get_next_message_sz();
		fprintf(stdout, "<-- outbound: get_next_message_sz %d %d\n", j, sz);


		fprintf(stdout, "--> outbound: read_next_message %d\n", j);
		m_env->m_msg_queue_0->read_next_message(msg);
		fprintf(stdout, "<-- outbound: read_next_message %d\n", j);
	}

	fprintf(stdout, "<-- outbound_thread\n");
	fflush(stdout);

	drop_objection();
}

void a23_dualcore_sys_msg_queue_smoke_test::run() {
	uint32_t sz;
	uint32_t msg[4096];
	fprintf(stdout, "--> run()\n");

	for (uint32_t j=0; j<16; j++) {
	sz = m_env->m_msg_queue_0->get_next_message_sz();

	fprintf(stdout, "sz=%d\n", sz);

	m_env->m_msg_queue_0->read_next_message(msg);

	for (uint32_t i=0; i<sz; i++) {
		fprintf(stdout, "msg[%d] = %d\n", i, msg[i]);
	}
	}
//	drop_objection();

	fprintf(stdout, "<-- run()\n");
}

svf_test_ctor_def(a23_dualcore_sys_msg_queue_smoke_test)

