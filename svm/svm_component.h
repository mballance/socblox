/*
 * svm_component.h
 *
 *  Created on: Dec 8, 2013
 *      Author: ballance
 */

#ifndef SVM_COMPONENT_H_
#define SVM_COMPONENT_H_
#include <string>
#include <vector>
#include <stdint.h>
using namespace std;
#include "svm_component_ctor.h"

class svm_root;
class svm_component {
	friend class svm_root;

	public:
		svm_component(const char *name, svm_component *parent);

		virtual ~svm_component();

		const string &get_name() const;

	protected:

		virtual void build();

		virtual void connect();

		virtual void start();

		void raise_objection();

		void drop_objection();

	private:

		svm_root *get_root();

	protected:
		svm_component					*m_parent;
		string							m_name;
		vector<svm_component *>			m_children;
};

#endif /* SVM_COMPONENT_H_ */
