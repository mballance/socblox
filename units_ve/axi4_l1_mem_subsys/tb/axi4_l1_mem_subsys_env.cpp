/*
 * axi4_l1_mem_subsys_env.cpp
 *
 *  Created on: Jan 11, 2014
 *      Author: ballance
 */

#include "axi4_l1_mem_subsys_env.h"

axi4_l1_mem_subsys_env::axi4_l1_mem_subsys_env(const char *name, svf_component *parent) : svf_component(name, parent) {


}

axi4_l1_mem_subsys_env::~axi4_l1_mem_subsys_env() {
	// TODO Auto-generated destructor stub
}

void axi4_l1_mem_subsys_env::build() {
	// TODO: instantiate BFMs
	m_m0 = axi4_master_bfm::type_id.create("m_m0", this);
	m_m1 = axi4_master_bfm::type_id.create("m_m1", this);
	m_timebase = timebase::type_id.create("m_timebase", this);
}

void axi4_l1_mem_subsys_env::connect() {
	// TODO: connect BFMs
}

svf_component_ctor_def(axi4_l1_mem_subsys_env)
