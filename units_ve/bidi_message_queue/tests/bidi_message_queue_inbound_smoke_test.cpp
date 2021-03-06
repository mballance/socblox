/*
 * bidi_message_queue_inbound_smoke_test.cpp
 *
 *  Created on: Jun 9, 2014
 *      Author: ballance
 */

#include "bidi_message_queue_inbound_smoke_test.h"

bidi_message_queue_inbound_smoke_test::bidi_message_queue_inbound_smoke_test(const char *name) : bidi_message_queue_test_base(name) {
	// TODO Auto-generated constructor stub

}

bidi_message_queue_inbound_smoke_test::~bidi_message_queue_inbound_smoke_test() {
	// TODO Auto-generated destructor stub
}

void bidi_message_queue_inbound_smoke_test::build()
{
	bidi_message_queue_test_base::build();
	fprintf(stdout, "--> new memif_drv %p\n", m_env);
	fflush(stdout);
	m_bidi_drv = new bidi_message_queue_memif_drv(
			static_cast<uint32_t *>(0x00000000),
			8);

	fprintf(stdout, "<-- new memif_drv %p\n", m_bidi_drv);
	fflush(stdout);
}

void bidi_message_queue_inbound_smoke_test::connect()
{
	bidi_message_queue_test_base::connect();
	fprintf(stdout, "--> connect %p %p\n", m_bidi_drv, m_env->m_master_bfm);
	fflush(stdout);
//	m_cond_mutex.lock();
//	m_cond.wait(m_cond_mutex);
	m_bidi_drv->set_memif(m_env->m_master_bfm);
	fprintf(stdout, "<-- connect %p %p\n", m_bidi_drv, m_env->m_master_bfm);
	fflush(stdout);
}

void bidi_message_queue_inbound_smoke_test::start()
{
	raise_objection();
	fprintf(stdout, "--> m_run_thread\n");
	m_run_thread.init(this, &bidi_message_queue_inbound_smoke_test::run);
	m_run_thread.start();
	fprintf(stdout, "<-- m_run_thread\n");

	fprintf(stdout, "--> m_sw_thread\n");
	m_sw_thread.init(this, &bidi_message_queue_inbound_smoke_test::sw_main);
	m_sw_thread.start();
	fprintf(stdout, "<-- m_sw_thread\n");
}

void bidi_message_queue_inbound_smoke_test::sw_main()
{
	uint32_t msg_sz;
	uint32_t msg[256];

//	m_cond_mutex.lock();
//	m_cond.wait(m_cond_mutex);

	while (true) {
	msg_sz = m_bidi_drv->get_next_message_sz();
	fprintf(stdout, "msg_sz=%0d\n", msg_sz);

	fprintf(stdout, "--> read_next_message\n");
	m_bidi_drv->read_next_message(msg);
	for (uint32_t i=0; i<msg_sz; i++) {
		fprintf(stdout, "  msg[%d] = 0x%08x\n", i, msg[i]);
	}
	fprintf(stdout, "<-- read_next_message\n");
	}
}

void bidi_message_queue_inbound_smoke_test::run()
{
	uint32_t data = 1;
	fprintf(stdout, "run\n");
	m_env->m_master_bfm->wait_for_reset();

	for (uint32_t i=0; i<512; i++) {
		fprintf(stdout, "  index %d\n", i);
		m_env->m_message_queue_bfm->write32(4);
		for (uint32_t j=0; j<4; j++) {
			m_env->m_message_queue_bfm->write32(data++);
		}
	}
	drop_objection();
}

svf_test_ctor_def(bidi_message_queue_inbound_smoke_test)
