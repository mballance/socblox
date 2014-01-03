/*
 * svf_api_export.h
 *
 *  Created on: Dec 14, 2013
 *      Author: ballance
 */

#ifndef SVF_API_EXPORT_H_
#define SVF_API_EXPORT_H_

template <class C> class svf_api_export {

	public:

		svf_api_export(C *provides) : m_provides(provides) {}

		C *operator ()() { return m_provides; }

		void connect(svf_api_export<C> &exp) {
			m_provides = exp.provides();
		}

		C *provides() { return m_provides; }

	private:

		C					*m_provides;

};



#endif /* SVF_API_EXPORT_H_ */
