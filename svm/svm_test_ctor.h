/*
 * svm_test_ctor.h
 *
 *  Created on: Dec 14, 2013
 *      Author: ballance
 */

#ifndef SVM_TEST_CTOR_H_
#define SVM_TEST_CTOR_H_
#include "svm_factory.h"

#define svm_test_ctor_decl(cls) \
	public: static svm_test_ctor <cls>				type_id;

#define svm_test_ctor_def(cls) \
	svm_test_ctor<cls> cls :: type_id(#cls);

class svm_test_ctor_base {
	public:
		svm_test_ctor_base(svm_factory *factory, const char *type_name);

		virtual ~svm_test_ctor_base();

		virtual svm_test *create(const char *name);

		virtual svm_test *create_default(const char *name) = 0;

		const char *get_typename() {
			return m_typename;
		}

	private:
		const char					*m_typename;
		svm_factory					*m_factory;
};

template <class T> class svm_test_ctor : public svm_test_ctor_base {

	public:

		svm_test_ctor(const char *name) : svm_test_ctor_base(svm_factory::get_default(), name) {
		}

		virtual T *create(const char *name) {
			return static_cast<T *>(svm_test_ctor_base::create(name));
		}

		virtual T *create_default(const char *name) {
			return new T(name);
		}
};


#endif /* SVM_TEST_CTOR_H_ */
