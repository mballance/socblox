/*
 * svf_closure.h
 *
 *  Created on: Dec 12, 2013
 *      Author: ballance
 */

#ifndef SVF_CLOSURE_H_
#define SVF_CLOSURE_H_
#include <stdio.h>

class svf_closure_base {
	public:
		svf_closure_base() { }

		virtual ~svf_closure_base() { }

		virtual void operator()() const { }

};


template <class cls> class svf_closure : public svf_closure_base {
	public:
		svf_closure(cls *t_cls, void (cls::*method)()) : m_cls(t_cls), m_method(method) {}

		void operator()() const {
			fprintf(stdout, "--> calling method\n");
			(*m_cls.*m_method)();
			fprintf(stdout, "<-- calling method\n");
		}

	private:
		cls				*m_cls;
		void (cls::*m_method)();
};

#endif /* SVF_CLOSURE_H_ */