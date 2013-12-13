/*
 * svm_component_ctor.h
 *
 *  Created on: Dec 8, 2013
 *      Author: ballance
 */

#ifndef SVM_COMPONENT_CTOR_H_
#define SVM_COMPONENT_CTOR_H_

#include "svm_factory.h"

#define svm_component_ctor_decl(cls) \
	public: static svm_component_ctor <cls>				type_id;

#define svm_component_ctor_def(cls) \
	svm_component_ctor<cls> cls :: type_id(#cls);

class svm_component_ctor_base {

	public:
		svm_component_ctor_base(svm_factory *factory, const char *type_name);

		virtual ~svm_component_ctor_base();

		virtual svm_component *create(const char *name, svm_component *parent);

		virtual svm_component *create_default(const char *name, svm_component *parent);

		const char *get_typename() {
			return m_typename;
		}

	private:
		const char						*m_typename;
		svm_factory						*m_factory;
};

template <class T> class svm_component_ctor : public svm_component_ctor_base {

	public:

		svm_component_ctor(const char *name) : svm_component_ctor_base(svm_factory::get_default(), name) {
		}

		virtual T *create(const char *name, svm_component *parent) {
			return static_cast<T *>(svm_component_ctor_base::create(name, parent));
		}

		virtual T *create_default(const char *name, svm_component *parent) {
			return new T(name, parent);
		}
};


#endif /* SVM_COMPONENT_CTOR_H_ */
