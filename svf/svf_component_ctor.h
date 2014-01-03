/*
 * svf_component_ctor.h
 *
 *  Created on: Dec 8, 2013
 *      Author: ballance
 */

#ifndef SVF_COMPONENT_CTOR_H_
#define SVF_COMPONENT_CTOR_H_

#include "svf_factory.h"

#define svf_component_ctor_decl(cls) \
	public: static svf_component_ctor <cls>				type_id;

#define svf_component_ctor_def(cls) \
	svf_component_ctor<cls> cls :: type_id(#cls);

class svf_component_ctor_base {

	public:
		svf_component_ctor_base(svf_factory *factory, const char *type_name);

		virtual ~svf_component_ctor_base();

		virtual svf_component *create(const char *name, svf_component *parent);

		virtual svf_component *create_default(const char *name, svf_component *parent) = 0;

		const char *get_typename() {
			return m_typename;
		}

	private:
		const char						*m_typename;
		svf_factory						*m_factory;
};

template <class T> class svf_component_ctor : public svf_component_ctor_base {

	public:

		svf_component_ctor(const char *name) : svf_component_ctor_base(svf_factory::get_default(), name) {
		}

		virtual T *create(const char *name, svf_component *parent) {
			return static_cast<T *>(svf_component_ctor_base::create(name, parent));
		}

		virtual T *create_default(const char *name, svf_component *parent) {
			return new T(name, parent);
		}
};


#endif /* SVF_COMPONENT_CTOR_H_ */
