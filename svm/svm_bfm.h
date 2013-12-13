/*
 * svm_bfm.h
 *
 *  Created on: Dec 8, 2013
 *      Author: ballance
 */

#ifndef SVM_BFM_H_
#define SVM_BFM_H_

#include "svm_component.h"

class svm_bfm: public svm_component {
	public:

		static const char					*BFM_PATH;

	public:
		svm_bfm(const char *name, svm_component *parent);

		virtual ~svm_bfm();
};

#endif /* SVM_BFM_H_ */
