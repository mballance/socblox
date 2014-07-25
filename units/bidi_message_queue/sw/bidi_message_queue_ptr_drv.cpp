/*
 * bidi_message_queue_ptr_drv.cpp
 *
 *  Created on: Jun 24, 2014
 *      Author: ballance
 */

#include "bidi_message_queue_ptr_drv.h"

bidi_message_queue_ptr_drv::bidi_message_queue_ptr_drv(uint32_t *base, uint32_t queue_addr_bits) :
	bidi_message_queue_drv_base(base, queue_addr_bits) {
	// TODO Auto-generated constructor stub

}

bidi_message_queue_ptr_drv::~bidi_message_queue_ptr_drv() {
	// TODO Auto-generated destructor stub
}

uint32_t bidi_message_queue_ptr_drv::read32(uint32_t *addr)
{
	volatile uint32_t *addr_v = addr;
	return (*addr_v);
}

void bidi_message_queue_ptr_drv::write32(uint32_t *addr, uint32_t data)
{
	volatile uint32_t *addr_v = addr;

	(*addr_v) = data;
}
