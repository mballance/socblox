/*
 * svf_object_ctor.h
 *
 *  Created on: Dec 8, 2013
 *      Author: ballance
 */

#ifndef SVF_OBJECT_CTOR_H_
#define SVF_OBJECT_CTOR_H_

#include "svf_factory.h"
class svf_object;

#define svf_object_ctor_decl(cls) \
	public: static svf_object_ctor <cls>				type_id;

#define svf_object_ctor_def(cls) \
	svf_object_ctor<cls> cls :: type_id(#cls);

class svf_object_ctor_base {

	public:
		svf_object_ctor_base(svf_factory *factory, const char *type_name);

		virtual ~svf_object_ctor_base();

		virtual svf_object *create(const char *name, svf_object *parent);

		virtual svf_object *create_default(const char *name, svf_object *parent);

		const char *get_typename() {
			return m_typename;
		}

	private:
		const char						*m_typename;
		svf_factory						*m_factory;
};

template <class T> class svf_object_ctor : public svf_object_ctor_base {

	public:

		svf_object_ctor(const char *name) : svf_object_ctor_base(svf_factory::get_default(), name) {
		}

		virtual T *create(const char *name, svf_object *parent) {
			return static_cast<T *>(svf_object_ctor_base::create(name, parent));
		}

		virtual T *create_default(const char *name, svf_object *parent) {
			return new T(name, parent);
		}
};


#endif /* SVF_OBJECT_CTOR_H_ */
