/*
 * axi4_l1_mem_unit_env.cpp
 *
 *  Created on: Jan 11, 2014
 *      Author: ballance
 */

#include "axi4_l1_mem_unit_env.h"

axi4_l1_mem_unit_env::axi4_l1_mem_unit_env(const char *name, svf_component *parent) : svf_component(name, parent) {


}

axi4_l1_mem_unit_env::~axi4_l1_mem_unit_env() {
	// TODO Auto-generated destructor stub
}

void axi4_l1_mem_unit_env::build() {
	// TODO: instantiate BFMs

	m_m0 = axi4_master_bfm::type_id.create("m_m0", this);

}

void axi4_l1_mem_unit_env::connect() {
	// TODO: connect BFMs
}

svf_component_ctor_def(axi4_l1_mem_unit_env)
