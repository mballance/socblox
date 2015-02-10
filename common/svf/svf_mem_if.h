/*
 * svf_mem_if.h
 *
 *  Created on: Dec 21, 2013
 *      Author: ballance
 */

#ifndef SVF_MEM_IF_H_
#define SVF_MEM_IF_H_
#include "svf.h"

class svf_mem_if {

	public:

		virtual ~svf_mem_if() {}

		virtual void write(uint64_t addr, uint8_t *data, uint32_t sz) = 0;

		virtual void write8(uint64_t addr, uint8_t data) = 0;

		virtual void write16(uint64_t addr, uint16_t data) = 0;

		virtual void write32(uint64_t addr, uint32_t data) = 0;

		virtual void read(uint64_t addr, uint8_t *data, uint32_t sz) = 0;

		virtual uint8_t read8(uint64_t addr) = 0;

		virtual uint16_t read16(uint64_t addr) = 0;

		virtual uint32_t read32(uint64_t addr) = 0;

};

class svf_mem_host_if {

	public:
		virtual ~svf_mem_host_if() {}

};



#endif /* SVF_MEM_IF_H_ */
