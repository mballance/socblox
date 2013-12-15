/*
 * axi4_interconnect_testbase.cpp
 *
 *  Created on: Dec 11, 2013
 *      Author: ballance
 */

#include "axi4_interconnect_test_base.h"

axi4_interconnect_test_base::axi4_interconnect_test_base(const char *name) : svm_test(name) {

}

axi4_interconnect_test_base::~axi4_interconnect_test_base() {
	// TODO Auto-generated destructor stub
}

void axi4_interconnect_test_base::build()
{
	m_env = axi4_interconnect_env::type_id.create("m_env", this);
}

void axi4_interconnect_test_base::connect()
{

}

void axi4_interconnect_test_base::start()
{
	fprintf(stdout, "start\n");
}

svm_test_ctor_def(axi4_interconnect_test_base);
