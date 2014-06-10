/*
 * bidi_message_queue_drv_base.cpp
 *
 *  Created on: Jun 8, 2014
 *      Author: ballance
 */

#include "bidi_message_queue_drv_base.h"

bidi_message_queue_drv_base::bidi_message_queue_drv_base(
		uint32_t		*base,
		uint32_t		queue_addr_bits // for both queues
		) {
	m_inbound_sz = -1;
	// TODO Auto-generated constructor stub
	uint32_t in_out_queue_sz = (1 << queue_addr_bits);

	m_base = base;
	m_queue_sz = in_out_queue_sz / 2;

	m_inbound  = &m_base[4096];
	m_outbound = &m_base[4096+m_queue_sz];
}

bidi_message_queue_drv_base::~bidi_message_queue_drv_base() {
	// TODO Auto-generated destructor stub
}

// Returns the size of the next inbound message.
// If block=false and there is no message, -1 is returned
int32_t bidi_message_queue_drv_base::get_next_message_sz(bool block)
{
	uint32_t rp, wp, szt=0;

	inbound_lock();

	// Just in case we read this already
	if (m_inbound_sz != -1) {
		return m_inbound_sz;
	}

	rp = read32(&m_base[INBOUND_RD_PTR]);
	while (true) {
		wp = read32(&m_base[INBOUND_WR_PTR]);
		szt = (wp>rp)?(m_queue_sz-(wp-rp)):(m_queue_sz-(rp-wp));

		if (szt > 0) {
			m_inbound_sz = read32(&m_inbound[rp]);
			rp = ((rp+1) % m_queue_sz);
			write32(&m_base[INBOUND_RD_PTR], rp);
			break;
		} else {
			wait_inbound();
		}
	}

	inbound_unlock();

	return m_inbound_sz;
}

int32_t bidi_message_queue_drv_base::read_next_message(uint32_t *data)
{
	uint32_t rp, wp, szt=0;
	uint32_t last_rp;
	uint32_t i=0;
	inbound_lock();

	rp = read32(&m_base[INBOUND_RD_PTR]);
	last_rp = rp;
	while (i < m_inbound_sz) {
		wp = read32(&m_base[INBOUND_WR_PTR]);
		szt = (wp>rp)?(m_queue_sz-(wp-rp)):(m_queue_sz-(rp-wp));

		if (szt > 0) {
			data[i] = read32(&m_inbound[rp]);
			rp = ((rp+1) % m_queue_sz);
			i++;
		} else {
			wait_inbound();
		}

		if (i == m_inbound_sz || (szt == 0 && last_rp != rp)) {
			write32(&m_base[INBOUND_RD_PTR], rp);
			last_rp = rp;
		}
	}

	// Reset for other callers
	m_inbound_sz = -1;

	inbound_unlock();
}

// Writes the message pointed to be 'data' to the
// outbound message queue
int32_t bidi_message_queue_drv_base::write_message(uint32_t sz, uint32_t *data)
{
	int32_t ret = 0;
	uint32_t rp, wp, szt=0;
	uint32_t i=0;

	outbound_lock();

	wp = read32(&m_base[OUTBOUND_WR_PTR]);
	while (i <= sz) {
		if (szt == 0) {
			rp = read32(&m_base[OUTBOUND_RD_PTR]);
			szt = (wp>rp)?(m_queue_sz-(wp-rp)):(m_queue_sz-(rp-wp));
		}

		if (szt > 0) {
			if (i == 0) {
				write32(&m_outbound[wp], sz);
			} else {
				write32(&m_outbound[wp], data[i-1]);
			}
			i++;
			szt--;
			wp = ((wp+1) % m_queue_sz);
		} else {
			wait_outbound();
		}

		if (szt == 0 || i==sz) {
			// Write-back the write pointer
			write32(&m_base[OUTBOUND_WR_PTR], wp);
		}
	}

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
