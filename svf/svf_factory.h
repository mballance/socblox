/*
 * svf_factory.h
 *
 *  Created on: Dec 8, 2013
 *      Author: ballance
 */

#ifndef SVF_FACTORY_H_
#define SVF_FACTORY_H_
#include "svf_string.h"
#include "svf_string_map.h"

class svf_component_ctor_base;
class svf_component;
class svf_test_ctor_base;
class svf_test;
class svf_object_ctor_base;
class svf_object;
class svf_factory {

	public:
		svf_factory();

		virtual ~svf_factory();

		void register_component_ctor(const char *name, svf_component_ctor_base *ctor);

		svf_component *create_component(const char *type_name, const char *name, svf_component *parent);

		void register_test_ctor(const char *name, svf_test_ctor_base *ctor);

		svf_test *create_test(const char *type_name, const char *name);

		void register_object_ctor(const char *name, svf_object_ctor_base *ctor);

		svf_object *create_object(const char *type_name, const char *name);

		static svf_factory *get_default();

	private:
		svf_string_map<svf_component_ctor_base>			m_component_ctor_rgy;
		svf_string_map<svf_test_ctor_base>				m_test_ctor_rgy;

		static svf_factory				*m_default;
};

#endif /* SVF_FACTORY_H_ */
