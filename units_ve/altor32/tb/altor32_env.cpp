/*
 * altor32_env.cpp
 *
 *  Created on: Jan 11, 2014
 *      Author: ballance
 */

#include "altor32_env.h"

altor32_env::altor32_env(const char *name, svf_component *parent) : svf_component(name, parent) {


}

altor32_env::~altor32_env() {
	// TODO Auto-generated destructor stub
}

void altor32_env::build() {
	// TODO: instantiate BFMs
}

void altor32_env::connect() {
	// TODO: connect BFMs
}

svf_component_ctor_def(altor32_env)
