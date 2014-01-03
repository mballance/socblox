/*
 * svf_test_ctor.h
 *
 *  Created on: Dec 14, 2013
 *      Author: ballance
 */

#ifndef SVF_TEST_CTOR_H_
#define SVF_TEST_CTOR_H_
#include "svf_factory.h"

#define svf_test_ctor_decl(cls) \
	public: static svf_test_ctor <cls>				type_id;

#define svf_test_ctor_def(cls) \
	svf_test_ctor<cls> cls :: type_id(#cls);

class svf_test_ctor_base {
	public:
		svf_test_ctor_base(svf_factory *factory, const char *type_name);

		virtual ~svf_test_ctor_base();

		virtual svf_test *create(const char *name);

		virtual svf_test *create_default(const char *name) = 0;

		const char *get_typename() {
			return m_typename;
		}

	private:
		const char					*m_typename;
		svf_factory					*m_factory;
};

template <class T> class svf_test_ctor : public svf_test_ctor_base {

	public:

		svf_test_ctor(const char *name) : svf_test_ctor_base(svf_factory::get_default(), name) {
		}

		virtual T *create(const char *name) {
			return static_cast<T *>(svf_test_ctor_base::create(name));
		}

		virtual T *create_default(const char *name) {
			return new T(name);
		}
};


#endif /* SVF_TEST_CTOR_H_ */
