/*
 * bidi_message_queue_direct_bfm.cpp
 *
 *  Created on: Dec 22, 2013
 *      Author: ballance
 */

#include "bidi_message_queue_direct_bfm.h"

bidi_message_queue_direct_bfm::bidi_message_queue_direct_bfm(const char *name, svf_component *parent) :
	svf_component(name, parent), bfm_port(this) {
	m_inbound_sz = -1;

}

bidi_message_queue_direct_bfm::~bidi_message_queue_direct_bfm() {
	// TODO Auto-generated destructor stub
}

void bidi_message_queue_direct_bfm::start()
{
	if (!bfm_port.consumes()) {
		fprintf(stdout, "Note: bidi_message_queue_direct_bfm not connected\n");
		return;
	}
	bfm_port->get_queue_sz(&m_queue_sz);
}

// Returns the size of the next inbound message.
// If block=false and there is no message, -1 is returned
int32_t bidi_message_queue_direct_bfm::get_next_message_sz(bool block)
{
	uint32_t rp, wp;

	m_outbound_mutex.lock();

	// Just in case we read this already
	if (m_inbound_sz != -1) {
		return m_inbound_sz;
	}

	while (true) {
		bfm_port->get_outbound_ptrs(&rp, &wp);

		if (wp != rp) {
			uint32_t tmp;
			bfm_port->get_data(rp+m_queue_sz, &tmp);
			m_inbound_sz = tmp;

			rp = ((rp+1) % m_queue_sz);
			bfm_port->set_outbound_rd_ptr(rp);

			m_outbound_mutex.unlock();
			return m_inbound_sz;
			break;
		} else {
			bfm_port->wait_outbound_avail();
			m_outbound_avail_mutex.lock();
			m_outbound_avail_cond.wait(m_outbound_avail_mutex);
			m_outbound_avail_mutex.unlock();
		}
	}

	m_outbound_mutex.unlock();
	return -1;
}

int32_t bidi_message_queue_direct_bfm::read_next_message(uint32_t *data)
{
	uint32_t rp, wp;
	uint32_t i=0;

	m_outbound_mutex.lock();

	bfm_port->get_outbound_ptrs(&rp, &wp);
	while (i < m_inbound_sz) {

		if (rp != wp) {
			bfm_port->get_data(rp+m_queue_sz, &data[i]);
			rp = ((rp+1) % m_queue_sz);
			i++;
		} else {
			bfm_port->set_outbound_rd_ptr(rp);
			bfm_port->wait_outbound_avail();
			m_outbound_avail_mutex.lock();
			m_outbound_avail_cond.wait(m_outbound_avail_mutex);
			m_outbound_avail_mutex.unlock();
			bfm_port->get_outbound_ptrs(&rp, &wp);
		}
	}

	bfm_port->set_outbound_rd_ptr(rp);

	// Reset for other callers
	m_inbound_sz = -1;

	m_outbound_mutex.unlock();
}

// Writes the message pointed to be 'data' to the
// outbound message queue
int32_t bidi_message_queue_direct_bfm::write_message(uint32_t sz, uint32_t *data)
{
	int32_t ret = 0;
	uint32_t rp, wp;
	uint32_t wp_next;
	uint32_t i=0;

	m_inbound_mutex.lock();

	bfm_port->get_inbound_ptrs(&rp, &wp);

	while (i <= sz) {
		wp_next = ((wp+1) % m_queue_sz);

		if (wp_next != rp) {
			if (i == 0) {
				bfm_port->set_data(wp, sz);
			} else {
				bfm_port->set_data(wp, data[i-1]);
			}
			i++;
			wp = ((wp+1) % m_queue_sz);
		} else {
			bfm_port->set_inbound_wr_ptr(wp);
			bfm_port->wait_inbound_avail();
			m_inbound_avail_mutex.lock();
			m_inbound_avail_cond.wait(m_inbound_avail_mutex);
			m_inbound_avail_mutex.unlock();
			bfm_port->get_inbound_ptrs(&rp, &wp);
		}
	}

	// Write-back the write pointer
	bfm_port->set_inbound_wr_ptr(wp);

	m_inbound_mutex.unlock();

	return ret;
}

void bidi_message_queue_direct_bfm::inbound_avail_ack()
{
	m_inbound_avail_mutex.lock();
	m_inbound_avail_cond.notify();
	m_inbound_avail_mutex.unlock();
}

void bidi_message_queue_direct_bfm::outbound_avail_ack()
{
	m_outbound_avail_mutex.lock();
	m_outbound_avail_cond.notify();
	m_outbound_avail_mutex.unlock();
}


svf_component_ctor_def(bidi_message_queue_direct_bfm)
