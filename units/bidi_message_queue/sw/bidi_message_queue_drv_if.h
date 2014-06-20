/*
 * bidi_message_queue_drv_if.h
 *
 *  Created on: Jun 18, 2014
 *      Author: ballance
 */

#ifndef BIDI_MESSAGE_QUEUE_DRV_IF_H_
#define BIDI_MESSAGE_QUEUE_DRV_IF_H_

#include <stdint.h>

class bidi_message_queue_drv_if {

	public:

		virtual ~bidi_message_queue_drv_if() {}

		virtual int32_t get_next_message_sz(bool block=true) = 0;

		virtual int32_t read_next_message(uint32_t *data) = 0;

		virtual int32_t write_message(uint32_t sz, uint32_t *data) = 0;

};



#endif /* BIDI_MESSAGE_QUEUE_DRV_IF_H_ */
