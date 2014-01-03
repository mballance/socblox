/*
 * svf_object_ctor.cpp
 *
 *  Created on: Dec 8, 2013
 *      Author: ballance
 */
#include "svf_object_ctor.h"
#include "svf_object.h"

svf_object_ctor_base::svf_object_ctor_base(svf_factory *factory, const char *type_name) :
	m_factory(factory), m_typename(type_name) {
	m_factory->register_object_ctor(m_typename, this);
}

svf_object_ctor_base::~svf_object_ctor_base()
{
}

svf_object *svf_object_ctor_base::create(const char *name, svf_object *parent)
{
	return m_factory->create_object(m_typename, name);
}

svf_object *svf_object_ctor_base::create_default(const char *name, svf_object *parent)
{
	return 0;
}


