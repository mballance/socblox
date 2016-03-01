/*
 * wb_interconnect_1x2_env.cpp
 *
 *  Created on: Jan 11, 2014
 *      Author: ballance
 */

#include "wb_interconnect_1x2_env.h"

wb_interconnect_1x2_env::wb_interconnect_1x2_env(const char *name, svf_component *parent) : svf_component(name, parent) {


}

wb_interconnect_1x2_env::~wb_interconnect_1x2_env() {
	// TODO Auto-generated destructor stub
}

void wb_interconnect_1x2_env::build() {
	// TODO: instantiate BFMs
	bfm0 = wb_master_bfm::type_id.create("bfm0", this);
}

void wb_interconnect_1x2_env::connect() {
	// TODO: connect BFMs
}

svf_component_ctor_def(wb_interconnect_1x2_env)
