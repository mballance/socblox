/*
 * svm_bidir_api_port.h
 *
 *  Created on: Dec 13, 2013
 *      Author: ballance
 */

#ifndef SVM_BIDIR_API_PORT_H_
#define SVM_BIDIR_API_PORT_H_

template <class P, class C> class svm_bidi_api_port {

	public:
		svm_bidi_api_port(P *provides) : m_provides(provides), m_consumes(0) {

		}

		void set_provides(P *provides) {
			m_provides = provides;
		}

		void set_consumes(C *consumes) {
			m_consumes = consumes;
		}

		C *operator ()() const { return m_consumes; }

		C *operator ->() const { return m_consumes; }

		P *provides() const { return m_provides; }
		C *consumes() const { return m_consumes; }

		void connect(svm_bidi_api_port<C, P> &other) {
			m_consumes = other.m_provides;
			other.m_consumes = m_provides;
		}

	private:
		P						*m_provides;
		C						*m_consumes;

};




#endif /* SVM_BIDIR_API_PORT_H_ */
