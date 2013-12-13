/*
 * svm_root.h
 *
 *  Created on: Dec 8, 2013
 *      Author: ballance
 */

#ifndef SVM_ROOT_H_
#define SVM_ROOT_H_

#include "svm_component.h"

class svm_root : public svm_component {

	public:
		svm_root(const char *name, svm_component *parent);

		virtual ~svm_root();

		static int svm_runtest_init(const char *testname);

};

#endif /* SVM_ROOT_H_ */
