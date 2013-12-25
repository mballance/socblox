/*
 * svm_api_publisher_port.h
 *
 *  Created on: Dec 24, 2013
 *      Author: ballance
 */

#ifndef SVM_API_PUBLISHER_PORT_H_
#define SVM_API_PUBLISHER_PORT_H_
#include <vector>
#include <stdint.h>
#include "svm_api_export.h"

using namespace std;


template <class P> class svm_api_publisher_port {
	private:
		vector<svm_api_export<P> *>			m_observers;

	public:

		void connect(svm_api_export<P> &exp);

		const vector<svm_api_export<P> *> observers() const;

		template <typename ...Ts> void operator()(void (P::*method)(Ts...), Ts... args) {
			for (uint32_t i=0; i<m_observers.size(); i++) {
//				*m_observers.at(i)->provides().*method(args...);
			}
		}

};

template <class P> void svm_api_publisher_port<P>::connect(svm_api_export<P> &exp)
{
	m_observers.push_back(&exp);
}


#endif /* SVM_API_PUBLISHER_PORT_H_ */

