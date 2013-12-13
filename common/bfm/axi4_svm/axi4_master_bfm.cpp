/*
 * axi4_master_bfm.cpp
 *
 *  Created on: Dec 8, 2013
 *      Author: ballance
 */

#include "axi4_master_bfm.h"

extern "C" {
void svm_axi4_master_bfm_aw_valid(
		uint64_t				AWADDR,
		uint32_t				AWID,
		uint8_t					AWLEN,
		uint8_t					AWSIZE,
		uint8_t					AWBURST,
		uint8_t					AWCACHE,
		uint8_t					AWPROT,
		uint8_t					AWQOS,
		uint8_t					AWREGION);

void svm_axi4_master_bfm_aw_ready();
}



axi4_master_bfm::axi4_master_bfm(const char *name, svm_component *parent) :
		svm_bfm(name, parent),
		m_initialized(false) {
	// TODO Auto-generated constructor stub

}

axi4_master_bfm::~axi4_master_bfm() {
	// TODO Auto-generated destructor stub
}

void axi4_master_bfm::init(const char *bfm_path)
{
	m_bfm_path = bfm_path;
}

uint8_t axi4_master_bfm::write32(
		uint64_t			addr,
		uint32_t			data)
{
	uint32_t ret = 0;

	svm_axi4_master_bfm_aw_valid(
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

	// Wait for acknowledge
//	wait(m_aw_ack_ev);

	return ret;
}

svm_component_ctor_def(axi4_master_bfm)

void svm_axi4_master_bfm_aw_ready() {

}
