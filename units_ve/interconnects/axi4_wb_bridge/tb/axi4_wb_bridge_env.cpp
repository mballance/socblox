/*
 * axi4_wb_bridge_env.cpp
 *
 *  Created on: Jan 11, 2014
 *      Author: ballance
 */

#include "axi4_wb_bridge_env.h"

axi4_wb_bridge_env::axi4_wb_bridge_env(const char *name, svf_component *parent) : svf_component(name, parent) {


}

axi4_wb_bridge_env::~axi4_wb_bridge_env() {
	// TODO Auto-generated destructor stub
}

void axi4_wb_bridge_env::build() {
	m_m0 = axi4_master_bfm::type_id.create("m_m0", this);
	m_m1 = axi4_master_bfm::type_id.create("m_m1", this);
	m_m2 = wb_master_bfm::type_id.create("m_m2", this);
}

void axi4_wb_bridge_env::connect() {

}

svf_component_ctor_def(axi4_wb_bridge_env)
