/*
 * svm_factory.cpp
 *
 *  Created on: Dec 8, 2013
 *      Author: ballance
 */

#include "svm_factory.h"
#include "svm_component_ctor.h"
#include "svm_component.h"
#include "svm_object_ctor.h"
#include "svm_object.h"

svm_factory::svm_factory() {
	// TODO Auto-generated constructor stub

}

svm_factory::~svm_factory() {
	// TODO Auto-generated destructor stub
}

void svm_factory::register_component_ctor(const char *name, svm_component_ctor_base *ctor)
{
	m_component_ctor_rgy.insert(pair<string, svm_component_ctor_base *>(name, ctor));
}

svm_factory *svm_factory::get_default()
{
	if (!m_default) {
		m_default = new svm_factory();
	}
	return m_default;
}

svm_component *svm_factory::create_component(
		const char			*type_name,
		const char			*name,
		svm_component		*parent) {
	svm_component *ret = 0;
	map<string, svm_component_ctor_base *>::iterator it;

	it = m_component_ctor_rgy.find(type_name);

	if (it != m_component_ctor_rgy.end()) {
		svm_component_ctor_base *ctor = it->second;
		ret = ctor->create(name, parent);
	} else {
		// Error
	}

	return ret;
}

void svm_factory::register_object_ctor(const char *name, svm_object_ctor_base *ctor)
{

}

svm_object *svm_factory::create_object(
		const char			*type_name,
		const char			*name)
{
	return 0;
}

svm_factory *svm_factory::m_default = 0;
