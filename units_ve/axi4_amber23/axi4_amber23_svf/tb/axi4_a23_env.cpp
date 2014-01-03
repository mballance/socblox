/*
 * axi4_a23_env.cpp
 *
 *  Created on: Dec 25, 2013
 *      Author: ballance
 */

#include "axi4_a23_env.h"

axi4_a23_env::axi4_a23_env(const char *name, svf_component *parent) :
	svf_component(name, parent) {
	// TODO Auto-generated constructor stub

}

axi4_a23_env::~axi4_a23_env() {
	// TODO Auto-generated destructor stub
}

void axi4_a23_env::build()
{
	m_s0_bfm = axi4_svf_sram_bfm::type_id.create("m_s0_bfm", this);
	m_tracer = a23_tracer::type_id.create("m_tracer", this);
}

void axi4_a23_env::connect()
{

}

svf_component_ctor_def(axi4_a23_env)
