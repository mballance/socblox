/*
 * generic_sram_byte_en_bfm.cpp
 *
 *  Created on: Dec 22, 2013
 *      Author: ballance
 */

#include "generic_sram_byte_en_bfm.h"

generic_sram_byte_en_bfm::generic_sram_byte_en_bfm(const char *name, svf_component *parent) :
	svf_component(name, parent), bfm_port(0) {
	// TODO Auto-generated constructor stub

}

generic_sram_byte_en_bfm::~generic_sram_byte_en_bfm() {
	// TODO Auto-generated destructor stub
}

void generic_sram_byte_en_bfm::write32(uint64_t addr, uint32_t data)
{
	bfm_port->write32(addr, data);
}

void generic_sram_byte_en_bfm::write16(uint64_t addr, uint16_t data)
{
	bfm_port->write16(addr, data);
}

void generic_sram_byte_en_bfm::write8(uint64_t addr, uint8_t data)
{
	bfm_port->write8(addr, data);
}

uint32_t generic_sram_byte_en_bfm::read32(uint64_t addr)
{
	uint32_t ret;
	bfm_port->read32(addr, &ret);
	return ret;
}

uint16_t generic_sram_byte_en_bfm::read16(uint64_t addr)
{
	uint16_t ret;
	bfm_port->read16(addr, &ret);
	return ret;
}

uint8_t generic_sram_byte_en_bfm::read8(uint64_t addr)
{
	uint8_t ret;
	bfm_port->read8(addr, &ret);
	return ret;
}

svf_component_ctor_def(generic_sram_byte_en_bfm)
