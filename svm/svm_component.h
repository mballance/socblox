/*
 * svm_component.h
 *
 *  Created on: Dec 8, 2013
 *      Author: ballance
 */

#ifndef SVM_COMPONENT_H_
#define SVM_COMPONENT_H_
#include <string>
#include <stdint.h>
using namespace std;
#include "svm_component_ctor.h"

class svm_root;
class svm_component {

	public:
		svm_component(const char *name, svm_component *parent);

		virtual ~svm_component();

	protected:

		virtual void build();

		virtual void connect();

		virtual void start();

	private:

		svm_root *get_root();

	protected:
		svm_component					*m_parent;
};

#endif /* SVM_COMPONENT_H_ */
