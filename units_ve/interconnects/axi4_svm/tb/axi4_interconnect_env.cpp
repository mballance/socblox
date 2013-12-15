/*
 * axi4_interconnect_env.cpp
 *
 *  Created on: Dec 11, 2013
 *      Author: ballance
 */

#include "axi4_interconnect_env.h"

svm_component_ctor_def(axi4_interconnect_env)

axi4_interconnect_env::axi4_interconnect_env(const char *name, svm_component *parent) :
	svm_component(name, parent), m_bfm(0) {
	// TODO Auto-generated constructor stub

}

axi4_interconnect_env::~axi4_interconnect_env() {
	// TODO Auto-generated destructor stub
}

void axi4_interconnect_env::build()
{
	fprintf(stdout, "env::build this=%p\n", this);
	m_bfm = axi4_master_bfm::type_id.create("m_bfm", this);
	fprintf(stdout, "m_bfm=%p\n", m_bfm);
}

void axi4_interconnect_env::connect()
{
	fprintf(stdout, "env::connect: m_bfm=%p this=%p\n", m_bfm, this);
	axi4_master_bfm_dpi_mgr::connect("foo", m_bfm->bfm_port);

}
