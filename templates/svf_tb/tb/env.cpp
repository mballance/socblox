/*
 * ${name}_env.cpp
 *
 *  Created on: Jan 11, 2014
 *      Author: ballance
 */

#include "${name}_env.h"

${name}_env::${name}_env(const char *name, svf_component *parent) : svf_component(name, parent) {


}

${name}_env::~${name}_env() {
	// TODO Auto-generated destructor stub
}

void ${name}_env::build() {
	// TODO: instantiate BFMs
}

void ${name}_env::connect() {
	// TODO: connect BFMs
}

svf_component_ctor_def(${name}_env)
