/*
 * svf_api_port.h
 *
 *  Created on: Dec 14, 2013
 *      Author: ballance
 */

#ifndef SVF_API_PORT_H_
#define SVF_API_PORT_H_
#include "svf_api_export.h"

template <class C> class svf_api_port {

	public:

		svf_api_port() : m_api(0) {}

		C *operator ()() { return m_api; }

		C *operator ->() { return m_api; }

		void connect(svf_api_export<C> &exp) {
			m_api = exp.provides();
		}

	private:
		C						*m_api;

};




#endif /* SVF_API_PORT_H_ */
