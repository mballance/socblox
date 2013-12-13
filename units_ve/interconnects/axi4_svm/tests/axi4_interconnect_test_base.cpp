/*
 * axi4_interconnect_testbase.cpp
 *
 *  Created on: Dec 11, 2013
 *      Author: ballance
 */

#include "axi4_interconnect_test_base.h"

axi4_interconnect_test_base::axi4_interconnect_test_base(const char *name, svm_component *parent) :
	svm_test(name, parent) {

	m_env = axi4_interconnect_tb::type_id.create("m_env", this);
}

axi4_interconnect_test_base::~axi4_interconnect_test_base() {
	// TODO Auto-generated destructor stub
}

svm_component_ctor_def(axi4_interconnect_test_base);
