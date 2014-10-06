/*
 * axi4_l1_interconnect_2_env.cpp
 *
 *  Created on: Jan 11, 2014
 *      Author: ballance
 */

#include "axi4_l1_interconnect_2_env.h"

axi4_l1_interconnect_2_env::axi4_l1_interconnect_2_env(const char *name, svf_component *parent) : svf_component(name, parent) {


}

axi4_l1_interconnect_2_env::~axi4_l1_interconnect_2_env() {
	// TODO Auto-generated destructor stub
}

void axi4_l1_interconnect_2_env::build() {
	// TODO: instantiate BFMs

	m_m0 = axi4_master_bfm::type_id.create("m_m0", this);
	m_m1 = axi4_master_bfm::type_id.create("m_m1", this);

	m_sram = generic_sram_byte_en_bfm::type_id.create("m_sram", this);
}

void axi4_l1_interconnect_2_env::connect() {
	// TODO: connect BFMs
}

svf_component_ctor_def(axi4_l1_interconnect_2_env)
