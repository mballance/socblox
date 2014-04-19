/*
 * a23_tracer_bfm.cpp
 *
 *  Created on: Dec 24, 2013
 *      Author: ballance
 */

#include "a23_tracer_bfm.h"

a23_tracer_bfm::a23_tracer_bfm(const char *name, svf_component *parent) :
	svf_component(name, parent), bfm_port(this) {
	// TODO Auto-generated constructor stub

}

a23_tracer_bfm::~a23_tracer_bfm() {
	// TODO Auto-generated destructor stub
}

void a23_tracer_bfm::mem_access(
		uint32_t			addr,
		bool				is_write,
		uint32_t			data)
{
	port(&a23_tracer_if::mem_access, addr, is_write, data);
}

void a23_tracer_bfm::execute(
		uint32_t			addr,
		uint32_t			op)
{
	port(&a23_tracer_if::execute, addr, op);
}

void a23_tracer_bfm::regchange(
		uint32_t			reg,
		uint32_t			val)
{
	port(&a23_tracer_if::regchange, reg, val);
}



svf_component_ctor_def(a23_tracer_bfm)
