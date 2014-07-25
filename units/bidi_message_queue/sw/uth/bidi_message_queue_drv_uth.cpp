/*
 * bidi_message_queue_drv_uth.cpp
 *
 *  Created on: Jun 27, 2014
 *      Author: ballance
 */

#include "bidi_message_queue_drv_uth.h"
#include <stdio.h>

bidi_message_queue_drv_uth::bidi_message_queue_drv_uth(
		uint32_t			*base,
		uint32_t			queue_bit_sz) : bidi_message_queue_drv_base(base, queue_bit_sz) {

	uth_mutex_init(&m_outbound_mutex);
	uth_mutex_init(&m_inbound_mutex);

}

bidi_message_queue_drv_uth::~bidi_message_queue_drv_uth() {
	// TODO Auto-generated destructor stub
}

// Wait for inbound data to be available
void bidi_message_queue_drv_uth::wait_inbound()
{
	fprintf(stderr, "--> wait_inbound\n");
	uth_thread_yield();
	fprintf(stderr, "<-- wait_inbound\n");
}

// Wait for space in the outbound queue to be available
void bidi_message_queue_drv_uth::wait_outbound()
{
	fprintf(stderr, "--> wait_outbound\n");
	uth_thread_yield();
	fprintf(stderr, "<-- wait_outbound\n");
}

void bidi_message_queue_drv_uth::inbound_lock()
{
	uth_mutex_lock(&m_inbound_mutex);
}

void bidi_message_queue_drv_uth::inbound_unlock()
{
	uth_mutex_unlock(&m_inbound_mutex);
}

void bidi_message_queue_drv_uth::outbound_lock()
{
	uth_mutex_lock(&m_outbound_mutex);
}

void bidi_message_queue_drv_uth::outbound_unlock()
{
	uth_mutex_unlock(&m_outbound_mutex);
}

//
uint32_t bidi_message_queue_drv_uth::read32(uint32_t *addr)
{
	volatile uint32_t *addr_v = addr;
	return (*addr_v);
}

void bidi_message_queue_drv_uth::write32(uint32_t *addr, uint32_t data)
{
	volatile uint32_t *addr_v = addr;
   (*addr_v) = data;
}

