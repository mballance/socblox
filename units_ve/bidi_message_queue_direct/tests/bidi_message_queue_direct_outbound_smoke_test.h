/*
 * bidi_message_queue_direct_outbound_smoke_test.h
 *
 *  Created on: Jun 19, 2014
 *      Author: ballance
 */

#ifndef INCLUDED_bidi_message_queue_direct_outbound_smoke_test_H
#define INCLUDED_bidi_message_queue_direct_outbound_smoke_test_H
#include "svf.h"
#include "bidi_message_queue_direct_test_base.h"
#include "bidi_message_queue_memif_drv.h"

class bidi_message_queue_direct_outbound_smoke_test : public bidi_message_queue_direct_test_base {
	svf_test_ctor_decl(bidi_message_queue_direct_outbound_smoke_test)

	public:

		bidi_message_queue_direct_outbound_smoke_test(const char *name);

		virtual ~bidi_message_queue_direct_outbound_smoke_test();

		virtual void build();

		virtual void connect();

		virtual void start();

		void sw_thread();

		void bfm_thread();

	private:
		svf_thread							m_sw_thread;
		svf_thread							m_bfm_thread;
		bidi_message_queue_memif_drv		*m_bidi_drv;

};

#endif /* SVF_TEST_H_ */
