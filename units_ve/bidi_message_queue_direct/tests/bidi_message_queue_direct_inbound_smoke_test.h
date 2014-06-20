/*
 * bidi_message_queue_direct_inbound_smoke_test.h
 *
 *  Created on: Jun 18, 2014
 *      Author: ballance
 */

#ifndef BIDI_MESSAGE_QUEUE_DIRECT_INBOUND_SMOKE_TEST_H_
#define BIDI_MESSAGE_QUEUE_DIRECT_INBOUND_SMOKE_TEST_H_

#include "bidi_message_queue_direct_test_base.h"
#include "bidi_message_queue_memif_drv.h"

class bidi_message_queue_direct_inbound_smoke_test: public bidi_message_queue_direct_test_base {

	svf_test_ctor_decl(bidi_message_queue_direct_inbound_smoke_test)

	public:
		bidi_message_queue_direct_inbound_smoke_test(const char *name);

		virtual ~bidi_message_queue_direct_inbound_smoke_test();

		virtual void build();

		virtual void connect();

		virtual void start();

		void sw_thread();

		void bfm_thread();

	private:
		svf_thread						m_sw_thread;
		svf_thread						m_bfm_thread;
		bidi_message_queue_memif_drv	*m_bidi_drv;

};

#endif /* BIDI_MESSAGE_QUEUE_DIRECT_INBOUND_SMOKE_TEST_H_ */
