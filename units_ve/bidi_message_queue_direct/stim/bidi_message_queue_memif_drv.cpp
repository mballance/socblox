/*
 * bidimessagequeuememifdrv.cpp
 *
 *  Created on: Jun 11, 2014
 *      Author: ballance
 */

#include "bidi_message_queue_memif_drv.h"
#include <stdio.h>

bidi_message_queue_memif_drv::bidi_message_queue_memif_drv(
		uint32_t		*base_addr,
		uint32_t		n_bits) : bidi_message_queue_drv_base(base_addr, n_bits) {
}

bidi_message_queue_memif_drv::~bidi_message_queue_memif_drv() {
	// TODO Auto-generated destructor stub
}

void bidi_message_queue_memif_drv::write32(uint32_t *addr, uint32_t data)
{
//	fprintf(stdout, "--> write32 0x%08llx 0x%08x\n", reinterpret_cast<uint64_t>(addr), data);
	m_mem_if->write32(reinterpret_cast<uint64_t>(addr), data);
//	fprintf(stdout, "<-- write32 0x%08llx 0x%08x\n", reinterpret_cast<uint64_t>(addr), data);
}

uint32_t bidi_message_queue_memif_drv::read32(uint32_t *addr)
{
	uint32_t ret;
//	fprintf(stdout, "--> read32 0x%08llx\n", reinterpret_cast<uint64_t>(addr));
	ret = m_mem_if->read32(reinterpret_cast<uint64_t>(addr));
//	fprintf(stdout, "<-- read32 0x%08llx 0x%08x\n", reinterpret_cast<uint64_t>(addr), ret);
	return ret;
}
