/*
 * svf_thread.h
 *
 *  Created on: Dec 12, 2013
 *      Author: ballance
 */

#ifndef SVF_THREAD_H_
#define SVF_THREAD_H_
#include "svf_closure.h"

typedef void *svf_native_thread_h;

class svf_thread {
	public:
		template <class cls> svf_thread(cls *client, void (cls::*method)()) :
			m_closure(new svf_closure<cls>(client, method)) { }

		svf_thread();

		svf_thread(svf_closure_base *closure);

		template <class cls> void init(cls *client, void (cls::*method)()) {
			init(new svf_closure<cls>(client, method));
		}

		void init(svf_closure_base *closure);

		virtual ~svf_thread();

		void start();

		static void yield();

		// Implementation-specific
		static svf_thread *self();

		template <class cls> static svf_thread *create(cls *client, void (cls::*method)()) {
			return new svf_thread(new svf_closure<cls>(client, method));
		}

	private:

		svf_closure_base				*m_closure;

		static svf_native_thread_h create_thread(svf_closure_base *closure);

		static void cleanup_thread(svf_native_thread_h);

		static void yield_thread();

};

#endif /* SVF_THREAD_H_ */
