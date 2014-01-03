/*
 * svf_api_publisher_port.h
 *
 *  Created on: Dec 24, 2013
 *      Author: ballance
 */

#ifndef SVF_API_PUBLISHER_PORT_H_
#define SVF_API_PUBLISHER_PORT_H_
#include <vector>
#include <stdint.h>
#include "svf_api_export.h"

using namespace std;


template <class P> class svf_api_publisher_port {
	private:
		vector<svf_api_export<P> *>			m_observers;

	public:

		void connect(svf_api_export<P> &exp);

		const vector<svf_api_export<P> *> observers() const;

		template <typename ...Ts> void operator()(void (P::*method)(Ts...), Ts... args) {
			for (uint32_t i=0; i<m_observers.size(); i++) {
				P *api = m_observers.at(i)->provides();
				(*api.*method)(args...);
			}
		}

};

template <class P> void svf_api_publisher_port<P>::connect(svf_api_export<P> &exp)
{
	m_observers.push_back(&exp);
}


#endif /* SVF_API_PUBLISHER_PORT_H_ */

