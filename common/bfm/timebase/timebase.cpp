/*
 * timebase.cpp
 *
 *  Created on: Dec 22, 2013
 *      Author: ballance
 */

#include "timebase.h"

timebase::timebase(const char *name, svf_component *parent) :
	svf_component(name, parent), bfm_port(0) {
	// TODO Auto-generated constructor stub

}

timebase::~timebase() {
	// TODO Auto-generated destructor stub
}

uint64_t timebase::gettime()
{
	uint64_t curr_time;
	bfm_port->gettime(&curr_time);

	return curr_time;
}

svf_component_ctor_def(timebase)
