/*
 * svm_object_ctor.cpp
 *
 *  Created on: Dec 8, 2013
 *      Author: ballance
 */
#include "svm_object_ctor.h"
#include "svm_object.h"

svm_object_ctor_base::svm_object_ctor_base(svm_factory *factory, const char *type_name) :
	m_factory(factory), m_typename(type_name) {
	m_factory->register_object_ctor(m_typename, this);
}

svm_object_ctor_base::~svm_object_ctor_base()
{
}

svm_object *svm_object_ctor_base::create(const char *name, svm_object *parent)
{
	return m_factory->create_object(m_typename, name);
}

svm_object *svm_object_ctor_base::create_default(const char *name, svm_object *parent)
{
	return 0;
}


