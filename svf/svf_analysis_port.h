/*
 * svf_analysis_port.h
 *
 *  Created on: Oct 23, 2014
 *      Author: ballance
 */

#ifndef SVF_ANALYSIS_PORT_H_
#define SVF_ANALYSIS_PORT_H_
#include "svf_ptr_vector.h"
#include "svf_analysis_port.h"

template <class T> class svf_analysis_port {
	private:

		svf_ptr_vector<svf_analysis_export<T> >		m_exports;

	public:

		void connect(svf_analysis_export<T> &exp);

		void write(T &t) {
			for (uint32_t i=0; i<m_exports.size(); i++) {
				m_exports.at(i)->write(t);
			}
		}

};

template <class T> void svf_analysis_port<T>::connect(svf_analysis_export<T> &exp)
{
	m_exports.push_back(&exp);
}





#endif /* SVF_ANALYSIS_PORT_H_ */
