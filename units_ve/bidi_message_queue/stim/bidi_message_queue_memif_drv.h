/*
 * bidimessagequeuememifdrv.h
 *
 *  Created on: Jun 11, 2014
 *      Author: ballance
 */

#ifndef BIDIMESSAGEQUEUEMEMIFDRV_H_
#define BIDIMESSAGEQUEUEMEMIFDRV_H_

#include "bidi_message_queue_drv_base.h"
#include "svf_mem_if.h"

class bidi_message_queue_memif_drv: public bidi_message_queue_drv_base {

	public:

		bidi_message_queue_memif_drv(
				uint32_t			*base,
				uint32_t			queue_addr_bits);

		virtual ~bidi_message_queue_memif_drv();

		void set_memif(svf_mem_if *mem_if) {
			m_mem_if = mem_if;
		}

		virtual void write32(uint32_t *addr, uint32_t data);

		virtual uint32_t read32(uint32_t *addr);

	private:

		svf_mem_if					*m_mem_if;
};

#endif /* BIDIMESSAGEQUEUEMEMIFDRV_H_ */
