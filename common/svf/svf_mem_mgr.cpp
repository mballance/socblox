/*
 * svf_mem_mgr.cpp
 *
 *  Created on: Mar 2, 2014
 *      Author: ballance
 */

#include "svf_mem_mgr.h"

struct svf_mem_mgr_region {
	svf_mem_if			*mem_if;
	uint64_t			base;
	uint64_t			limit;
};

svf_mem_mgr::svf_mem_mgr() {
	// TODO Auto-generated constructor stub

}

svf_mem_mgr::~svf_mem_mgr() {
	// TODO Auto-generated destructor stub
}

void svf_mem_mgr::add_region(
		svf_mem_if			*mem_if,
		uint64_t			base,
		uint64_t			limit)
{
	svf_mem_mgr_region *region = new svf_mem_mgr_region();

	region->mem_if = mem_if;
	region->base = base;
	region->limit = limit;

	m_regions.push_back(region);
}

void svf_mem_mgr::write8(uint64_t addr, uint8_t data)
{
	svf_mem_mgr_region *r = find(addr, addr+1);

	if (r) {
		r->mem_if->write8(addr-(r->base), data);
	} else {
		fprintf(stdout, "Error: write8 - no region for 0x%08llx\n", addr);
	}
}

void svf_mem_mgr::write16(uint64_t addr, uint16_t data)
{
	svf_mem_mgr_region *r = find(addr, addr+2);

	if (r) {
		r->mem_if->write16(addr-(r->base), data);
	} else {
		fprintf(stdout, "Error: write16 - no region for 0x%08llx\n", addr);
	}
}

void svf_mem_mgr::write32(uint64_t addr, uint32_t data)
{
	svf_mem_mgr_region *r = find(addr, addr+4);

	if (r) {
		r->mem_if->write32(addr-(r->base), data);
	} else {
		fprintf(stdout, "Error: write32 - no region for 0x%08llx\n", addr);
	}
}

uint8_t svf_mem_mgr::read8(uint64_t addr)
{
	uint8_t ret = 0xFF;
	svf_mem_mgr_region *r = find(addr, addr+1);

	if (r) {
		ret = r->mem_if->read8(addr-(r->base));
	} else {
		fprintf(stdout, "Error: read8 - no region for 0x%08llx\n", addr);
	}

	return ret;
}

uint16_t svf_mem_mgr::read16(uint64_t addr)
{
	uint16_t ret = 0xFFFF;
	svf_mem_mgr_region *r = find(addr, addr+1);

	if (r) {
		ret = r->mem_if->read16(addr-(r->base));
	} else {
		fprintf(stdout, "Error: read16 - no region for 0x%08llx\n", addr);
	}

	return ret;
}

uint32_t svf_mem_mgr::read32(uint64_t addr)
{
	uint32_t ret = 0xFFFF;
	svf_mem_mgr_region *r = find(addr, addr+1);

	if (r) {
		ret = r->mem_if->read32(addr-(r->base));
	} else {
		fprintf(stdout, "Error: read32 - no region for 0x%08llx\n", addr);
	}

	return ret;
}

svf_mem_mgr_region *svf_mem_mgr::find(uint64_t base, uint64_t limit)
{
	svf_mem_mgr_region *ret = 0;

	for (uint32_t i=0; i<m_regions.size(); i++) {
		svf_mem_mgr_region *tmp = m_regions.at(i);
		if (base >= tmp->base && limit <= tmp->limit) {
			ret = tmp;
			break;
		}
	}

	return ret;
}
