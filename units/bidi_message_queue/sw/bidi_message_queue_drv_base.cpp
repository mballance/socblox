/*
 * bidi_message_queue_drv_base.cpp
 *
 *  Created on: Jun 8, 2014
 *      Author: ballance
 */

#include "bidi_message_queue_drv_base.h"
#include <stdio.h>

bidi_message_queue_drv_base::bidi_message_queue_drv_base(
		uint32_t		*base,
		uint32_t		queue_addr_bits // for both queues
		) {
	m_inbound_sz = -1;
	// TODO Auto-generated constructor stub
	uint32_t in_out_queue_sz = (1 << queue_addr_bits);

	m_base = base;
	m_queue_sz = in_out_queue_sz / 2;

	m_inbound  = &m_base[4096/4];
	m_outbound = &m_base[(4096/4)+m_queue_sz];
}

bidi_message_queue_drv_base::~bidi_message_queue_drv_base() {
	// TODO Auto-generated destructor stub
}

// Returns the size of the next inbound message.
// If block=false and there is no message, -1 is returned
int32_t bidi_message_queue_drv_base::get_next_message_sz(bool block)
{
	uint32_t rp, wp;

	inbound_lock();

	// Just in case we read this already
	if (m_inbound_sz != -1) {
		return m_inbound_sz;
	}

	rp = read32(&m_base[INBOUND_RD_PTR]);
	while (true) {
		wp = read32(&m_base[INBOUND_WR_PTR]);

		if (wp != rp) {
			m_inbound_sz = read32(&m_inbound[rp]);
			rp = ((rp+1) % m_queue_sz);
			write32(&m_base[INBOUND_RD_PTR], rp);

			inbound_unlock();
			return m_inbound_sz;
			break;
		} else {
			wait_inbound();
		}
	}

	inbound_unlock();
	return -1;
}

int32_t bidi_message_queue_drv_base::read_next_message(uint32_t *data)
{
	uint32_t rp, wp;
	uint32_t i=0;
	inbound_lock();

	rp = read32(&m_base[INBOUND_RD_PTR]);
	while (i < m_inbound_sz) {
		wp = read32(&m_base[INBOUND_WR_PTR]);

		if (rp != wp) {
			data[i] = read32(&m_inbound[rp]);
			rp = ((rp+1) % m_queue_sz);
			i++;
		} else {
			write32(&m_base[INBOUND_RD_PTR], rp);
			wait_inbound();
		}
	}
	write32(&m_base[INBOUND_RD_PTR], rp);

	// Reset for other callers
	m_inbound_sz = -1;

	inbound_unlock();
}

// Writes the message pointed to be 'data' to the
// outbound message queue
int32_t bidi_message_queue_drv_base::write_message(uint32_t sz, uint32_t *data)
{
	int32_t ret = 0;
	uint32_t rp, wp;
	uint32_t i=0;

	outbound_lock();

	wp = read32(&m_base[OUTBOUND_WR_PTR]);
	rp = read32(&m_base[OUTBOUND_RD_PTR]);
	while (i <= sz) {
		if (rp != wp) {
			if (i == 0) {
				write32(&m_outbound[wp], sz);
			} else {
				write32(&m_outbound[wp], data[i-1]);
			}
			i++;
			wp = ((wp+1) % m_queue_sz);
		} else {
			write32(&m_base[OUTBOUND_WR_PTR], wp);
			wait_outbound();
			rp = read32(&m_base[OUTBOUND_RD_PTR]);
		}
	}

	write32(&m_base[OUTBOUND_WR_PTR], wp);

	outbound_unlock();

	return ret;
}

void bidi_message_queue_drv_base::wait_inbound()
{
}

void bidi_message_queue_drv_base::wait_outbound()
{
}

void bidi_message_queue_drv_base::inbound_lock()
{
}

void bidi_message_queue_drv_base::inbound_unlock()
{
}

void bidi_message_queue_drv_base::outbound_lock()
{
}

void bidi_message_queue_drv_base::outbound_unlock()
{
}
