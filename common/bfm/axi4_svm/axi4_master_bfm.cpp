/*
 * axi4_master_bfm.cpp
 *
 *  Created on: Dec 8, 2013
 *      Author: ballance
 */

#include "axi4_master_bfm.h"

axi4_master_bfm::axi4_master_bfm(const char *name, svm_component *parent) :
		svm_bfm(name, parent), bfm_port(this) {
	// TODO Auto-generated constructor stub

}

axi4_master_bfm::~axi4_master_bfm() {
	// TODO Auto-generated destructor stub
}

uint8_t axi4_master_bfm::write32(
		uint64_t			addr,
		uint32_t			data)
{
	uint32_t ret = 0;

	m_mutex.lock();

	// TODO: set SV context

	bfm_port()->aw_valid(
			addr,
			0,
			0, // AWLEN
			0, // AWSIZE
			0, // AWBURST
			0, // AWCACHE
			0, // AWPROT
			0, // AWQOS
			0  // AWREGION
			);

	m_aw_sem.get(); // Wait for acknowledge of the AW phase

	// TODO: data phase, etc

	m_mutex.unlock();
	return ret;
}

void axi4_master_bfm::aw_ready()
{
	m_aw_sem.put();
}

svm_component_ctor_def(axi4_master_bfm)


