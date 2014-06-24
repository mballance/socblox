/*
 * bidi_message_queue_direct_inout_smoke_test.h
 *
 *  Created on: Jun 19, 2014
 *      Author: ballance
 */

#ifndef INCLUDED_bidi_message_queue_direct_inout_smoke_test_H
#define INCLUDED_bidi_message_queue_direct_inout_smoke_test_H
#include "svf.h"
#include "bidi_message_queue_direct_test_base.h"
#include "bidi_message_queue_memif_drv.h"
#include <vector>
#include <stdint.h>

using namespace std;

class bidi_message_queue_direct_inout_smoke_test : public bidi_message_queue_direct_test_base {
	svf_test_ctor_decl(bidi_message_queue_direct_inout_smoke_test)

	public:

		bidi_message_queue_direct_inout_smoke_test(const char *name);

		virtual ~bidi_message_queue_direct_inout_smoke_test();

		virtual void build();

		virtual void connect();

		virtual void start();

		virtual void shutdown();

		void sw_outbound();

		void sw_inbound();

		void bfm_outbound();

		void bfm_inbound();

	private:
		svf_thread						m_sw_outbound_thread;
		svf_thread						m_sw_inbound_thread;
		svf_thread						m_bfm_outbound_thread;
		svf_thread						m_bfm_inbound_thread;
		bidi_message_queue_memif_drv	*m_bidi_drv;
		uint32_t						m_sw_inbound_msgs;
		uint32_t						m_sw_inbound_count;
		uint32_t						m_bfm_outbound_msgs;
		uint32_t						m_bfm_outbound_count;

};

#endif /* SVF_TEST_H_ */
