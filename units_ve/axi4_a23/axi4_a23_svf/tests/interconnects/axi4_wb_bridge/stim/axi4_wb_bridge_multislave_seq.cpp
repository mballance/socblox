/*
 * axi4_wb_bridge_multislave_seq.cpp
 *
 *  Created on: Jan 15, 2014
 *      Author: ballance
 */

#include "axi4_wb_bridge_multislave_seq.h"

axi4_wb_bridge_multislave_seq::axi4_wb_bridge_multislave_seq(svf_mem_if *mem_if) {
	m_mem_if = mem_if;
	m_count = 64;
}

axi4_wb_bridge_multislave_seq::~axi4_wb_bridge_multislave_seq() {
	// TODO Auto-generated destructor stub
}

void axi4_wb_bridge_multislave_seq::run()
{
	for (uint32_t i=0; i<m_count; i++) {
		for (uint32_t j=0; j<m_base_addrs.size(); j++) {

		}
	}
}

