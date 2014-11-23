/*
 * ${name}.cpp
 *
 *  Created on: Jun 19, 2014
 *      Author: ballance
 */

#include "${name}.h"

${name}::${name}(const char *name, svf_component *parent) :
	${baseclass}(name, parent) {
	// TODO Auto-generated constructor stub

}

${name}::~${name}() {
	// TODO Auto-generated destructor stub
}

void ${name}::build() {
	${baseclass}::build();
}

void ${name}::connect() {
	${baseclass}::connect();
}

void ${name}::start() {
	${baseclass}::start();
}

svf_component_ctor_def(${name})

