/*
 * svm_api_export.h
 *
 *  Created on: Dec 14, 2013
 *      Author: ballance
 */

#ifndef SVM_API_EXPORT_H_
#define SVM_API_EXPORT_H_

template <class C> class svm_api_export {

	public:

		svm_api_export(C *provides) : m_provides(provides) {}

		C *operator ()() { return m_provides; }

		void connect(svm_api_export<C> &exp) {
			m_provides = exp.provides();
		}

		C *provides() { return m_provides; }

	private:

		C					*m_provides;

};



#endif /* SVM_API_EXPORT_H_ */
