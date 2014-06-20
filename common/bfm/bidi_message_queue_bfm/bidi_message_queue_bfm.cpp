/*
 * bidi_message_queue_bfm.cpp
 *
 *  Created on: Dec 22, 2013
 *      Author: ballance
 */

#include "bidi_message_queue_bfm.h"

bidi_message_queue_bfm::bidi_message_queue_bfm(const char *name, svf_component *parent) :
	svf_component(name, parent), bfm_port(this) {
	// TODO Auto-generated constructor stub

}

bidi_message_queue_bfm::~bidi_message_queue_bfm() {
	// TODO Auto-generated destructor stub
}

void bidi_message_queue_bfm::write32(uint32_t data)
{
	m_outbound_mutex.lock();
	bfm_port->write_req(data);

	fprintf(stdout, "--> m_outbound_cond.wait\n");
	m_outbound_cond.wait(m_outbound_mutex);
	fprintf(stdout, "<-- m_outbound_cond.wait\n");

	m_outbound_mutex.unlock();
}

uint32_t bidi_message_queue_bfm::read32()
{
	uint32_t ret;
	m_inbound_mutex.lock();
	bfm_port->read_req();

	m_inbound_cond.wait(m_inbound_mutex);

	ret = m_read_data;
	m_inbound_mutex.unlock();

	return ret;
}

void bidi_message_queue_bfm::write_ack()
{
	m_outbound_mutex.lock();
	m_outbound_cond.notify();
	m_outbound_mutex.unlock();
}

void bidi_message_queue_bfm::read_ack(uint32_t data)
{
	m_inbound_mutex.lock();
	m_read_data = data;
	m_inbound_cond.notify();
	m_inbound_mutex.unlock();
}


svf_component_ctor_def(bidi_message_queue_bfm)
