/*
 * wb_2x2_env.cpp
 *
 *  Created on: Jan 11, 2014
 *      Author: ballance
 */

#include "wb_2x2_env.h"

wb_2x2_env::wb_2x2_env(const char *name, svf_component *parent) : svf_component(name, parent) {


}

wb_2x2_env::~wb_2x2_env() {
	// TODO Auto-generated destructor stub
}

void wb_2x2_env::build() {
	m_m0 = wb_master_bfm::type_id.create("m_m0", this);
	m_m1 = wb_master_bfm::type_id.create("m_m1", this);
}

void wb_2x2_env::connect() {

}

svf_component_ctor_def(wb_2x2_env)
