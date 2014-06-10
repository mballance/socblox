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

void bidi_message_queue_inbound_smoke_test::start()
{
	raise_objection();
	m_run_thread.init(this, &bidi_message_queue_inbound_smoke_test::run);
}

void bidi_message_queue_inbound_smoke_test::run()
{
	m_env->m_master_bfm->wait_for_reset();

	for (uint32_t i=0; i<100; i++) {
		m_env->m_message_queue_bfm->write32(i);
	}
	drop_objection();
}

svf_test_ctor_def(bidi_message_queue_inbound_smoke_test)
