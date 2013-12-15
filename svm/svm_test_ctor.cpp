/*
 * svm_test_ctor.cpp
 *
 *  Created on: Dec 14, 2013
 *      Author: ballance
 */

#include "svm_test_ctor.h"

svm_test_ctor_base::svm_test_ctor_base(svm_factory *factory, const char *type_name) :
	m_factory(factory), m_typename(type_name) {
	m_factory->register_test_ctor(m_typename, this);
}

svm_test_ctor_base::~svm_test_ctor_base()
{
}

svm_test *svm_test_ctor_base::create(const char *name)
{
	return m_factory->create_test(m_typename, name);
}



