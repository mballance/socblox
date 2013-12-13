/*
 * svm_component_ctor.cpp
 *
 *  Created on: Dec 8, 2013
 *      Author: ballance
 */
#include "svm_component_ctor.h"

svm_component_ctor_base::svm_component_ctor_base(svm_factory *factory, const char *type_name) :
	m_factory(factory), m_typename(type_name) {
	m_factory->register_component_ctor(m_typename, this);
}

svm_component_ctor_base::~svm_component_ctor_base()
{
}

svm_component *svm_component_ctor_base::create(const char *name, svm_component *parent)
{
	return m_factory->create_component(m_typename, name, parent);
}

svm_component *svm_component_ctor_base::create_default(const char *name, svm_component *parent)
{
	return 0;
}


