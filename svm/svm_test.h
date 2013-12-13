/*
 * svm_test.h
 *
 *  Created on: Dec 8, 2013
 *      Author: ballance
 */

#ifndef SVM_TEST_H_
#define SVM_TEST_H_

#include "svm_root.h"

class svm_test: public svm_root {

	public:
		svm_test(const char *name, svm_component *parent);

		virtual ~svm_test();
};

#endif /* SVM_TEST_H_ */
