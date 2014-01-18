/*
 * svf_component.h
 *
 *  Created on: Dec 8, 2013
 *      Author: ballance
 */

#ifndef SVF_COMPONENT_H_
#define SVF_COMPONENT_H_
#include <string>
#include <vector>
#include <stdint.h>
using namespace std;
#include "svf_component_ctor.h"

class svf_root;
class svf_task_base;
class svf_component {
	friend class svf_root;
	friend class svf_task_base;

	public:
		svf_component(const char *name, svf_component *parent);

		virtual ~svf_component();

		const string &get_name() const;

	protected:

		virtual void build();

		virtual void connect();

		virtual void start();

		virtual void shutdown();

		virtual void raise_objection();

		virtual void drop_objection();

		bool get_config_string(const char *key, const char **val);

	private:

		svf_root *get_root();

	protected:
		svf_component					*m_parent;
		string							m_name;
		vector<svf_component *>			m_children;
};

#endif /* SVF_COMPONENT_H_ */
