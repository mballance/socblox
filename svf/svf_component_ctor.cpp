/*
 * svf_component_ctor.cpp
 *
 *  Created on: Dec 8, 2013
 *      Author: ballance
 */
#include "svf_component_ctor.h"

svf_component_ctor_base::svf_component_ctor_base(svf_factory *factory, const char *type_name) :
	m_typename(type_name), m_factory(factory) {
	m_factory->register_component_ctor(m_typename, this);
}

svf_component_ctor_base::~svf_component_ctor_base()
{
}

svf_component *svf_component_ctor_base::create(const char *name, svf_component *parent)
{
	return m_factory->create_component(m_typename, name, parent);
}



