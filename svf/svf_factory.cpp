/*
 * svf_factory.cpp
 *
 *  Created on: Dec 8, 2013
 *      Author: ballance
 */

#include "svf_factory.h"
#include "svf_component_ctor.h"
#include "svf_component.h"
#include "svf_test_ctor.h"
#include "svf_test.h"
#include "svf_object_ctor.h"
#include "svf_object.h"
#include <stdio.h>

svf_factory::svf_factory() {
	// TODO Auto-generated constructor stub

}

svf_factory::~svf_factory() {
	// TODO Auto-generated destructor stub
}

void svf_factory::register_component_ctor(const char *name, svf_component_ctor_base *ctor)
{
	fprintf(stdout, "register_component_ctor: %s\n", name);
	m_component_ctor_rgy.insert(name, ctor);
}

svf_factory *svf_factory::get_default()
{
	if (!m_default) {
		m_default = new svf_factory();
	}
	return m_default;
}

svf_component *svf_factory::create_component(
		const char			*type_name,
		const char			*name,
		svf_component		*parent) {
	svf_component *ret = 0;
	int32_t it;

	// TODO: detect remap

	svf_component_ctor_base *ctor;

	if ((ctor = m_component_ctor_rgy.find(type_name))) {
		ret = ctor->create_default(name, parent);
	} else {
		// Error
	}

	if (!ret) {
		fprintf(stdout, "ERROR: Failed to create a component of type %s\n", type_name);
	}

	return ret;
}

void svf_factory::register_test_ctor(const char *name, svf_test_ctor_base *ctor)
{
	fprintf(stdout, "register_test_ctor: %s\n", name);
	m_test_ctor_rgy.insert(name, ctor);
}

svf_test *svf_factory::create_test(const char *type_name, const char *name)
{
	svf_test *ret = 0;
	int32_t it;

	// TODO: detect remap

	svf_test_ctor_base *ctor = m_test_ctor_rgy.find(type_name);

	if ((ctor = m_test_ctor_rgy.find(type_name))) {
		ret = ctor->create_default(name);
	} else {
		// Error
	}

	return ret;
}

void svf_factory::register_object_ctor(const char *name, svf_object_ctor_base *ctor)
{

}

svf_object *svf_factory::create_object(
		const char			*type_name,
		const char			*name)
{
	return 0;
}

svf_factory *svf_factory::m_default = 0;
