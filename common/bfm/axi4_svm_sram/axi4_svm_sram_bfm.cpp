/*
 * axi4_svm_sram_bfm.cpp
 *
 *  Created on: Dec 22, 2013
 *      Author: ballance
 */

#include "axi4_svm_sram_bfm.h"

axi4_svm_sram_bfm::axi4_svm_sram_bfm(const char *name, svm_component *parent) :
	svm_component(name, parent) {
	// TODO Auto-generated constructor stub

}

axi4_svm_sram_bfm::~axi4_svm_sram_bfm() {
	// TODO Auto-generated destructor stub
}

void axi4_svm_sram_bfm::write32(uint64_t addr, uint32_t data)
{
	port()->write32(addr, data);
}

void axi4_svm_sram_bfm::write16(uint64_t addr, uint16_t data)
{
	port()->write16(addr, data);
}

void axi4_svm_sram_bfm::write8(uint64_t addr, uint8_t data)
{
	port()->write8(addr, data);
}

uint32_t axi4_svm_sram_bfm::read32(uint64_t addr)
{
	return port()->read32(addr);
}

uint16_t axi4_svm_sram_bfm::read16(uint64_t addr)
{
	return port()->read16(addr);
}

uint8_t axi4_svm_sram_bfm::read8(uint64_t addr)
{
	return port()->read8(addr);
}

