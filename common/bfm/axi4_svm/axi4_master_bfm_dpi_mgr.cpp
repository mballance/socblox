/*
 * axi4_master_bfm_dpi_mgr.cpp
 *
 *  Created on: Dec 13, 2013
 *      Author: ballance
 */

#include "axi4_master_bfm_dpi_mgr.h"
#include "dpi/svm_dpi.h"

extern "C" {
	void axi4_master_bfm_register();
	int axi4_master_bfm_aw_ready();
	void axi4_master_bfm_aw_valid(
			uint64_t			AWADDR,
			uint32_t			AWID,
			uint8_t				AWLEN,
			uint8_t				AWSIZE,
			uint8_t				AWBURST,
			uint8_t				AWCACHE,
			uint8_t				AWPROT,
			uint8_t				AWQOS,
			uint8_t				AWREGION);
}

void axi4_master_bfm_dpi_closure::aw_valid(
				uint64_t			AWADDR,
				uint32_t			AWID,
				uint8_t				AWLEN,
				uint8_t				AWSIZE,
				uint8_t				AWBURST,
				uint8_t				AWCACHE,
				uint8_t				AWPROT,
				uint8_t				AWQOS,
				uint8_t				AWREGION)
{
	svScope scope = svGetScopeFromName(m_target.c_str());
	svSetScope(scope);

	axi4_master_bfm_aw_valid(AWADDR, AWID, AWLEN, AWSIZE, AWBURST, AWCACHE, AWPROT, AWQOS, AWREGION);
}

void axi4_master_bfm_dpi_mgr::connect(
		const string							&target,
		axi4_master_bfm_dpi_closure::port_t		&port)
{
	map<string, axi4_master_bfm_dpi_closure *>::iterator it;

	it = m_closure_map.find(target);

	axi4_master_bfm_dpi_closure *c;

	if (it == m_closure_map.end()) {
		// Must add
		c = new axi4_master_bfm_dpi_closure(target);
		m_closure_map[target] = c;
	} else {
		c = it->second;
	}

	c->connect(&port);
}

void axi4_master_bfm_dpi_mgr::register_bfm(const string &target)
{
	map<string, axi4_master_bfm_dpi_closure *>::iterator it;

	it = m_closure_map.find(target);

	axi4_master_bfm_dpi_closure *c;

	if (it == m_closure_map.end()) {
		// Must add
		c = new axi4_master_bfm_dpi_closure(target);
		m_closure_map[target] = c;
	}
}

axi4_master_bfm_dpi_closure *axi4_master_bfm_dpi_mgr::get_closure(const string &target)
{
	map<string, axi4_master_bfm_dpi_closure *>::iterator it;

	it = m_closure_map.find(target);

	axi4_master_bfm_dpi_closure *c = 0;

	if (it != m_closure_map.end()) {
		c = it->second;
	}

	return c;
}


void axi4_master_bfm_register()
{
	svScope scope = svGetScope();
	const char *name = svGetNameFromScope(scope);

	fprintf(stdout, "axi4_master_bfm_register: %s\n", name);

	axi4_master_bfm_dpi_mgr::register_bfm(name);
}

int axi4_master_bfm_aw_ready()
{
	svScope scope = svGetScope();
	const char *name = svGetNameFromScope(scope);

	axi4_master_bfm_dpi_closure *c = axi4_master_bfm_dpi_mgr::get_closure(name);

	if (c) {
		c->host_if()->aw_ready();
	}

	return 0;
}

map<string, axi4_master_bfm_dpi_closure *> axi4_master_bfm_dpi_mgr::m_closure_map;



