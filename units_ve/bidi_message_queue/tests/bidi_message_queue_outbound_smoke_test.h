/*
 * bidi_message_queue_outbound_smoke_test.h
 *
 *  Created on: Jun 9, 2014
 *      Author: ballance
 */

#ifndef BIDI_MESSAGE_QUEUE_OUTBOUND_SMOKE_TEST_H_
#define BIDI_MESSAGE_QUEUE_OUTBOUND_SMOKE_TEST_H_
#include "bidi_message_queue_test_base.h"
#include "bidi_message_queue_memif_drv.h"

class bidi_message_queue_outbound_smoke_test : public bidi_message_queue_test_base {

	svf_test_ctor_decl(bidi_message_queue_outbound_smoke_test)

	public:

		bidi_message_queue_outbound_smoke_test(const char *name);

		virtual ~bidi_message_queue_outbound_smoke_test();

		virtual void build();

		virtual void connect();

		virtual void start();

		void run();

		void sw_main();

	private:

		bidi_message_queue_memif_drv	*m_bidi_drv;

		svf_thread						m_run_thread;
		svf_thread						m_sw_thread;
		svf_thread_mutex				m_cond_mutex;
		svf_thread_cond					m_cond;
};

#endif /* BIDI_MESSAGE_QUEUE_OUTBOUND_SMOKE_TEST_H_ */
