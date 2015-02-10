/*
 * axi4_svf_rom_bfm.cpp
 *
 *  Created on: Dec 22, 2013
 *      Author: ballance
 */

#include "axi4_svf_rom_bfm.h"

axi4_svf_rom_bfm::axi4_svf_rom_bfm(const char *name, svf_component *parent) :
	svf_component(name, parent) {
	// TODO Auto-generated constructor stub

}

axi4_svf_rom_bfm::~axi4_svf_rom_bfm() {
	// TODO Auto-generated destructor stub
}

void axi4_svf_rom_bfm::write(uint64_t addr, uint8_t *data, uint32_t sz) {
	for (uint32_t i=0; i<sz; i++) {
		write8(addr+i, data[i]);
	}
}

void axi4_svf_rom_bfm::write32(uint64_t addr, uint32_t data)
{
	port()->write32(addr, data);
}

void axi4_svf_rom_bfm::write16(uint64_t addr, uint16_t data)
{
	port()->write16(addr, data);
}

void axi4_svf_rom_bfm::write8(uint64_t addr, uint8_t data)
{
	port()->write8(addr, data);
}

void axi4_svf_rom_bfm::read(uint64_t addr, uint8_t *data, uint32_t sz) {
	for (uint32_t i=0; i<sz; i++) {
		data[i] = read8(addr+i);
	}
}

uint32_t axi4_svf_rom_bfm::read32(uint64_t addr)
{
	return port()->read32(addr);
}

uint16_t axi4_svf_rom_bfm::read16(uint64_t addr)
{
	return port()->read16(addr);
}

uint8_t axi4_svf_rom_bfm::read8(uint64_t addr)
{
	return port()->read8(addr);
}

svf_component_ctor_def(axi4_svf_rom_bfm)
