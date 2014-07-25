/*
 * bidi_message_queue_drv_uth.h
 *
 *  Created on: Jun 27, 2014
 *      Author: ballance
 */

#ifndef BIDI_MESSAGE_QUEUE_DRV_UTH_H_
#define BIDI_MESSAGE_QUEUE_DRV_UTH_H_

#include "bidi_message_queue_drv_base.h"
#include "uth.h"

class bidi_message_queue_drv_uth: public bidi_message_queue_drv_base {

	public:
		bidi_message_queue_drv_uth(
				uint32_t			*base,
				uint32_t			queue_bit_sz);

		virtual ~bidi_message_queue_drv_uth();

		// Wait for inbound data to be available
		virtual void wait_inbound();

		// Wait for space in the outbound queue to be available
		virtual void wait_outbound();

		virtual void inbound_lock();
		virtual void inbound_unlock();

		virtual void outbound_lock();
		virtual void outbound_unlock();

		//
		virtual uint32_t read32(uint32_t *addr);

		virtual void write32(uint32_t *addr, uint32_t data);

	private:
		uth_mutex_t					m_outbound_mutex;
		uth_mutex_t					m_inbound_mutex;

};

#endif /* BIDI_MESSAGE_QUEUE_DRV_UTH_H_ */
