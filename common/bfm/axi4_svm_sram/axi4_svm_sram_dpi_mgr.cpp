/*
 * axi4_svm_sram_dpi_mgr.cpp
 *
 *  Created on: Dec 13, 2013
 *      Author: ballance
 */

#include "axi4_svm_sram_dpi_mgr.h"
#include "dpi/svm_dpi.h"

extern "C" {
	void axi4_svm_sram_register();
	void axi4_svm_sram_write8(uint64_t addr, uint8_t data);
	void axi4_svm_sram_write16(uint64_t addr, uint16_t data);
	void axi4_svm_sram_write32(uint64_t addr, uint32_t data);

	void axi4_svm_sram_read8(uint64_t addr, uint8_t *data);
	void axi4_svm_sram_read16(uint64_t addr, uint16_t *data);
	void axi4_svm_sram_read32(uint64_t addr, uint32_t *data);
}

void axi4_svm_sram_dpi_closure::write32(uint64_t addr, uint32_t data)
{
	svScope scope = svGetScopeFromName(m_target.c_str());
	svSetScope(scope);

	axi4_svm_sram_write32(addr, data);
}

void axi4_svm_sram_dpi_closure::write16(uint64_t addr, uint16_t data)
{
	svScope scope = svGetScopeFromName(m_target.c_str());
	svSetScope(scope);

	axi4_svm_sram_write16(addr, data);
}

void axi4_svm_sram_dpi_closure::write8(uint64_t addr, uint8_t data)
{
	svScope scope = svGetScopeFromName(m_target.c_str());
	svSetScope(scope);

	axi4_svm_sram_write8(addr, data);
}

uint32_t axi4_svm_sram_dpi_closure::read32(uint64_t addr)
{
	svScope scope = svGetScopeFromName(m_target.c_str());
	uint32_t data;
	svSetScope(scope);

	axi4_svm_sram_read32(addr, &data);

	return data;
}

uint16_t axi4_svm_sram_dpi_closure::read16(uint64_t addr)
{
	svScope scope = svGetScopeFromName(m_target.c_str());
	uint16_t data;
	svSetScope(scope);

	axi4_svm_sram_read16(addr, &data);

	return data;
}

uint8_t axi4_svm_sram_dpi_closure::read8(uint64_t addr)
{
	svScope scope = svGetScopeFromName(m_target.c_str());
	uint8_t data;
	svSetScope(scope);

	axi4_svm_sram_read8(addr, &data);

	return data;
}

void axi4_svm_sram_dpi_mgr::connect(
		const string							&target,
		svm_api_port<svm_mem_if>				&port)
{
	map<string, axi4_svm_sram_dpi_closure *>::iterator it;

	it = m_closure_map.find(target);

	axi4_svm_sram_dpi_closure *c;

	if (it == m_closure_map.end()) {
		// Must add
		c = new axi4_svm_sram_dpi_closure(target);
		m_closure_map[target] = c;
	} else {
		c = it->second;
	}

	port.connect(*c);
}

void axi4_svm_sram_dpi_mgr::register_bfm(const string &target)
{
	map<string, axi4_svm_sram_dpi_closure *>::iterator it;

	it = m_closure_map.find(target);

	axi4_svm_sram_dpi_closure *c;

	if (it == m_closure_map.end()) {
		// Must add
		c = new axi4_svm_sram_dpi_closure(target);
		m_closure_map[target] = c;
	}
}

axi4_svm_sram_dpi_closure *axi4_svm_sram_dpi_mgr::get_closure(const string &target)
{
	map<string, axi4_svm_sram_dpi_closure *>::iterator it;

	it = m_closure_map.find(target);

	axi4_svm_sram_dpi_closure *c = 0;

	if (it != m_closure_map.end()) {
		c = it->second;
	}

	return c;
}


void axi4_svm_sram_register()
{
	svScope scope = svGetScope();
	const char *name = svGetNameFromScope(scope);

	fprintf(stdout, "axi4_svm_sram_dpi_mgr: %s\n", name);

	axi4_svm_sram_dpi_mgr::register_bfm(name);
}


map<string, axi4_svm_sram_dpi_closure *> axi4_svm_sram_dpi_mgr::m_closure_map;



