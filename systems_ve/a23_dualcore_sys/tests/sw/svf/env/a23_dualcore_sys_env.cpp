/*
 * a23_dualcore_sys_env.cpp
 *
 *  Created on: Jun 19, 2014
 *      Author: ballance
 */

#include "a23_dualcore_sys_env.h"

a23_dualcore_sys_env::a23_dualcore_sys_env(const char *name, svf_component *parent) :
	svf_component(name, parent) {
	// TODO Auto-generated constructor stub

}

a23_dualcore_sys_env::~a23_dualcore_sys_env() {
	// TODO Auto-generated destructor stub
}

void a23_dualcore_sys_env::build() {
	svf_component::build();

	m_bridge = new svf_bridge("m_bridge", this);
}

void a23_dualcore_sys_env::connect() {
	svf_component::connect();
}

void a23_dualcore_sys_env::start() {
	svf_component::start();
}

svf_component_ctor_def(a23_dualcore_sys_env)

