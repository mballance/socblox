/*
 * svm_api_port.h
 *
 *  Created on: Dec 14, 2013
 *      Author: ballance
 */

#ifndef SVM_API_PORT_H_
#define SVM_API_PORT_H_
#include "svm_api_export.h"

template <class C> class svm_api_port {

	public:

		svm_api_port() : m_api(0) {}

		C *operator ()() { return m_api; }

		void connect(svm_api_export<C> &exp) {
			m_api = exp.provides();
		}

	private:
		C						*m_api;

};




#endif /* SVM_API_PORT_H_ */
