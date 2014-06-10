/*
 * bidi_message_queue_inbound_smoke_test.h
 *
 *  Created on: Jun 9, 2014
 *      Author: ballance
 */

#ifndef BIDI_MESSAGE_QUEUE_INBOUND_SMOKE_TEST_H_
#define BIDI_MESSAGE_QUEUE_INBOUND_SMOKE_TEST_H_
#include "bidi_message_queue_test_base.h"

class bidi_message_queue_inbound_smoke_test : public bidi_message_queue_test_base {

	svf_test_ctor_decl(bidi_message_queue_inbound_smoke_test)

	public:

		bidi_message_queue_inbound_smoke_test(const char *name);

		virtual ~bidi_message_queue_inbound_smoke_test();

		virtual void start();

		void run();

	private:

		svf_thread					m_run_thread;
};

#endif /* BIDI_MESSAGE_QUEUE_INBOUND_SMOKE_TEST_H_ */
