/*
 * bidi_message_queue_ptr_drv.h
 *
 *  Created on: Jun 24, 2014
 *      Author: ballance
 */

#ifndef BIDI_MESSAGE_QUEUE_PTR_DRV_H_
#define BIDI_MESSAGE_QUEUE_PTR_DRV_H_
#include "bidi_message_queue_drv_base.h"

class bidi_message_queue_ptr_drv : public bidi_message_queue_drv_base {

	public:

		bidi_message_queue_ptr_drv(uint32_t *base, uint32_t queue_addr_bits);

		virtual ~bidi_message_queue_ptr_drv();


		virtual uint32_t read32(uint32_t *addr);

		virtual void write32(uint32_t *addr, uint32_t data);
};

#endif /* BIDI_MESSAGE_QUEUE_PTR_DRV_H_ */
