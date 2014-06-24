/*
 * bidi_message_queue_direct_inout_smoke_test.cpp
 *
 *  Created on: Jun 19, 2014
 *      Author: ballance
 */

#include "bidi_message_queue_direct_inout_smoke_test.h"

bidi_message_queue_direct_inout_smoke_test::bidi_message_queue_direct_inout_smoke_test(const char *name) : bidi_message_queue_direct_test_base(name) {
	// TODO Auto-generated constructor stub
	m_bfm_outbound_count = 0;
	m_sw_inbound_count = 0;
	m_sw_inbound_msgs = 100;
	m_bfm_outbound_msgs = 100;
}

bidi_message_queue_direct_inout_smoke_test::~bidi_message_queue_direct_inout_smoke_test() {
	// TODO Auto-generated destructor stub
}

void bidi_message_queue_direct_inout_smoke_test::build() {
	bidi_message_queue_direct_test_base::build();
	m_bidi_drv = new bidi_message_queue_memif_drv(
			static_cast<uint32_t *>(0x00000000),
			8);
}

void bidi_message_queue_direct_inout_smoke_test::connect() {
	bidi_message_queue_direct_test_base::connect();
	m_bidi_drv->set_memif(m_env->m_master_bfm);
}

void bidi_message_queue_direct_inout_smoke_test::start() {
	bidi_message_queue_direct_test_base::start();

	m_sw_outbound_thread.init(this, &bidi_message_queue_direct_inout_smoke_test::sw_outbound);
	m_sw_outbound_thread.start();
	m_sw_inbound_thread.init(this, &bidi_message_queue_direct_inout_smoke_test::sw_inbound);
	m_sw_inbound_thread.start();
	m_bfm_outbound_thread.init(this, &bidi_message_queue_direct_inout_smoke_test::bfm_outbound);
	m_bfm_outbound_thread.start();
	m_bfm_inbound_thread.init(this, &bidi_message_queue_direct_inout_smoke_test::bfm_inbound);
	m_bfm_inbound_thread.start();
}

// Produces messages from sw out to the BFM
void bidi_message_queue_direct_inout_smoke_test::sw_outbound() {
	uint32_t msg_len = 1;
	uint32_t n_msgs = m_bfm_outbound_msgs;
	uint32_t msg[512];
	uint32_t data = 1;

	raise_objection();

	m_env->m_master_bfm->wait_for_reset();

	for (uint32_t i=0; i<n_msgs; i++) {
		for (uint32_t j=0; j<msg_len; j++) {
			msg[j] = data++;
		}

		// Send message
		m_bidi_drv->write_message(msg_len, msg);

		msg_len = ((msg_len + 2) % 512);
	}

	drop_objection();
}

// Reads messages inbound from the BFM
void bidi_message_queue_direct_inout_smoke_test::sw_inbound() {
	uint32_t msg_len = 50;
	int32_t msg_sz;
	uint32_t msg[512];
	uint32_t data = 25;

	raise_objection();

	m_env->m_master_bfm->wait_for_reset();

	while (m_sw_inbound_count < m_sw_inbound_msgs) {
		// Read message
		msg_sz = m_bidi_drv->get_next_message_sz();

		if (msg_sz != msg_len) {
			// Error
			fprintf(stdout, "Error: sw_inbound - expect length %d ; receive %d\n",
					msg_len, msg_sz);
			drop_objection();
		}

		// Receive data
		m_bidi_drv->read_next_message(msg);

		for (uint32_t j=0; j<msg_len; j++) {
			if (msg[j] != data) {
				fprintf(stdout, "Error: sw_inbound - expect data[%d] == %d ; receive %d\n",
						j, data, msg[j]);
			}
			data++;
		}

		// Compute next expected message length
		msg_len = ((msg_len + 2) % 512);
		m_sw_inbound_count++;
	}


	drop_objection();
}

// Reads messages from the sw
void bidi_message_queue_direct_inout_smoke_test::bfm_outbound() {
	uint32_t msg_len = 1;
	int32_t msg_sz;
	uint32_t msg[512];
	uint32_t data = 1;

	raise_objection();
	m_env->m_master_bfm->wait_for_reset();

	while (m_bfm_outbound_count < m_bfm_outbound_msgs) {
		// Read message
		msg_sz = m_env->m_message_queue_bfm->get_next_message_sz();

		if (msg_sz != msg_len) {
			// Error
			fprintf(stdout, "Error: bfm_outbound - expect length %d ; receive %d\n",
					msg_len, msg_sz);
			drop_objection();
		}

		// Receive data
		m_env->m_message_queue_bfm->read_next_message(msg);

		for (uint32_t j=0; j<msg_len; j++) {
			if (msg[j] != data) {
				fprintf(stdout, "Error: bfm_outbound - expect data[%d] == %d ; receive %d\n",
						j, data, msg[j]);
			}
			data++;
		}

		// Compute next expected message length
		msg_len = ((msg_len + 2) % 512);

		m_bfm_outbound_count++;
	}


	drop_objection();
}

void bidi_message_queue_direct_inout_smoke_test::bfm_inbound() {
	uint32_t msg_len = 50;
	uint32_t msg[512];
	uint32_t data = 25;

	raise_objection();
	m_env->m_master_bfm->wait_for_reset();

	for (uint32_t i=0; i<m_sw_inbound_msgs; i++) {
		for (uint32_t j=0; j<msg_len; j++) {
			msg[j] = data++;
		}

		// Send message
		m_env->m_message_queue_bfm->write_message(msg_len, msg);

		msg_len = ((msg_len + 2) % 512);
	}

	drop_objection();
}

void bidi_message_queue_direct_inout_smoke_test::shutdown() {
	const char *msg = 0;
	char buf[256];

	if (m_sw_inbound_count != m_sw_inbound_msgs) {
		sprintf(buf, "Error: received %d sw inbound messages", m_sw_inbound_count);
		msg = buf;
	}

	if (m_bfm_outbound_count != m_bfm_outbound_msgs) {
		sprintf(buf, "Error: received %d bfm outbound messages", m_bfm_outbound_count);
		msg = buf;
	}

	if (msg) {
		fprintf(stdout, "FAIL: %s\n", msg);
	} else {
		fprintf(stdout, "PASS: bidi_message_queue_direct_inout_smoke_test\n");
	}
}

svf_test_ctor_def(bidi_message_queue_direct_inout_smoke_test)

