/*
 * axi4_interconnect_env.cpp
 *
 *  Created on: Dec 11, 2013
 *      Author: ballance
 */

#include "axi4_interconnect_env.h"

axi4_interconnect_env::axi4_interconnect_env(const char *name, svf_component *parent) :
	svf_component(name, parent) {
	// TODO Auto-generated constructor stub

}

axi4_interconnect_env::~axi4_interconnect_env() {
	// TODO Auto-generated destructor stub
}

void axi4_interconnect_env::build()
{
	fprintf(stdout, "env::build this=%p\n", this);
	m_m1_bfm = axi4_master_bfm::type_id.create("m_m1_bfm", this);
	m_m2_bfm = axi4_master_bfm::type_id.create("m_m2_bfm", this);
}

void axi4_interconnect_env::connect()
{
	fprintf(stdout, "env::connect: m_m1_bfm=%p this=%p\n", m_m1_bfm, this);

}

svf_component_ctor_def(axi4_interconnect_env)
