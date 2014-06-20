/*
 * bidi_message_queue_direct_test_base.h
 *
 *  Created on: Jan 11, 2014
 *      Author: ballance
 */

#ifndef bidi_message_queue_direct_TEST_BASE_H_
#define bidi_message_queue_direct_TEST_BASE_H_
#include "svf.h"
#include "bidi_message_queue_direct_env.h"

class bidi_message_queue_direct_test_base : public svf_test {
	svf_test_ctor_decl(bidi_message_queue_direct_test_base)

	public:
		bidi_message_queue_direct_test_base(const char *name);

		virtual ~bidi_message_queue_direct_test_base();

		virtual void build();

		virtual void connect();

		virtual void start();

		virtual void run();

		virtual void shutdown();

	protected:

		bidi_message_queue_direct_env				*m_env;
		svf_thread						m_runthread;
};

#endif /* bidi_message_queue_direct_TEST_BASE_H_ */
