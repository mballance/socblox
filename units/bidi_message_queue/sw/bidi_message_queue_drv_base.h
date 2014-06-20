/*
 * bidi_message_queue_drv_base.h
 *
 *  Created on: Jun 8, 2014
 *      Author: ballance
 */

#ifndef BIDI_MESSAGE_QUEUE_DRV_BASE_H_
#define BIDI_MESSAGE_QUEUE_DRV_BASE_H_
#include <stdint.h>

class bidi_message_queue_drv_base {

	public:

		bidi_message_queue_drv_base(
				uint32_t			*base,
				uint32_t			queue_addr_bits);

		virtual ~bidi_message_queue_drv_base();

		// Returns the size of the next inbound message.
		// If block=false and there is no message, -1 is returned
		int32_t get_next_message_sz(bool block=true);

		// Reads the next message. data must point to a buffer
		// of sufficient size to hold the message data
		int32_t read_next_message(uint32_t *data);

		// Writes the message pointed to be 'data' to the
		// outbound message queue
		int32_t write_message(uint32_t sz, uint32_t *data);

		// Wait for inbound data to be available
		virtual void wait_inbound();

		// Wait for space in the outbound queue to be available
		virtual void wait_outbound();

		virtual void inbound_lock();
		virtual void inbound_unlock();

		virtual void outbound_lock();
		virtual void outbound_unlock();

		//
		virtual uint32_t read32(uint32_t *addr) = 0;

		virtual void write32(uint32_t *addr, uint32_t data) = 0;

	protected:
		const uint32_t				INBOUND_RD_PTR  = 0;
		const uint32_t				INBOUND_WR_PTR  = 1;
		const uint32_t				OUTBOUND_RD_PTR = 2;
		const uint32_t				OUTBOUND_WR_PTR = 3;

	private:
		uint32_t					*m_base;
		uint32_t					m_queue_sz;
		uint32_t					*m_inbound;
		uint32_t					*m_outbound;
		int32_t						m_inbound_sz;

};

#endif /* BIDI_MESSAGE_QUEUE_DRV_BASE_H_ */
