/*
 * svm_object_ctor.h
 *
 *  Created on: Dec 8, 2013
 *      Author: ballance
 */

#ifndef SVM_OBJECT_CTOR_H_
#define SVM_OBJECT_CTOR_H_

#include "svm_factory.h"
class svm_object;

#define svm_object_ctor_decl(cls) \
	public: static svm_object_ctor <cls>				type_id;

#define svm_object_ctor_def(cls) \
	svm_object_ctor<cls> cls :: type_id(#cls);

class svm_object_ctor_base {

	public:
		svm_object_ctor_base(svm_factory *factory, const char *type_name);

		virtual ~svm_object_ctor_base();

		virtual svm_object *create(const char *name, svm_object *parent);

		virtual svm_object *create_default(const char *name, svm_object *parent);

		const char *get_typename() {
			return m_typename;
		}

	private:
		const char						*m_typename;
		svm_factory						*m_factory;
};

template <class T> class svm_object_ctor : public svm_object_ctor_base {

	public:

		svm_object_ctor(const char *name) : svm_object_ctor_base(svm_factory::get_default(), name) {
		}

		virtual T *create(const char *name, svm_object *parent) {
			return static_cast<T *>(svm_object_ctor_base::create(name, parent));
		}

		virtual T *create_default(const char *name, svm_object *parent) {
			return new T(name, parent);
		}
};


#endif /* SVM_OBJECT_CTOR_H_ */
