/*
 * a23_mini_sys_env.cpp
 *
 *  Created on: Jan 11, 2014
 *      Author: ballance
 */

#include "a23_mini_sys_env.h"

a23_mini_sys_env::a23_mini_sys_env(const char *name, svf_component *parent) : svf_component(name, parent) {


}

a23_mini_sys_env::~a23_mini_sys_env() {
	// TODO Auto-generated destructor stub
}

void a23_mini_sys_env::build() {
	// TODO: instantiate BFMs
}

void a23_mini_sys_env::connect() {
	// TODO: connect BFMs
}

svf_component_ctor_def(a23_mini_sys_env)
