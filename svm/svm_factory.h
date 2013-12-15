/*
 * svm_factory.h
 *
 *  Created on: Dec 8, 2013
 *      Author: ballance
 */

#ifndef SVM_FACTORY_H_
#define SVM_FACTORY_H_
#include <map>
#include <string>

using namespace std;

class svm_component_ctor_base;
class svm_component;
class svm_test_ctor_base;
class svm_test;
class svm_object_ctor_base;
class svm_object;
class svm_factory {

	public:
		svm_factory();

		virtual ~svm_factory();

		void register_component_ctor(const char *name, svm_component_ctor_base *ctor);

		svm_component *create_component(const char *type_name, const char *name, svm_component *parent);

		void register_test_ctor(const char *name, svm_test_ctor_base *ctor);

		svm_test *create_test(const char *type_name, const char *name);

		void register_object_ctor(const char *name, svm_object_ctor_base *ctor);

		svm_object *create_object(const char *type_name, const char *name);

		static svm_factory *get_default();

	private:
		map<string, svm_component_ctor_base *>			m_component_ctor_rgy;
		map<string, svm_test_ctor_base *>				m_test_ctor_rgy;

		static svm_factory				*m_default;
};

#endif /* SVM_FACTORY_H_ */
