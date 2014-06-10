/*
 * bidi_message_queue_bfm.h
 *
 *  Created on: Dec 22, 2013
 *      Author: ballance
 */

#ifndef INCLUDED_bidi_message_queue_bfm_H
#define INCLUDED_bidi_message_queue_bfm_H
#include "svf.h"
#include "bidi_message_queue_bfm_dpi_mgr.h"

class bidi_message_queue_bfm : public svf_component {

	svf_component_ctor_decl(bidi_message_queue_bfm)

	public:
		svf_bidi_api_port<bidi_message_queue_bfm_host_if, bidi_message_queue_bfm_target_if>	bfm_port;

	public:

		bidi_message_queue_bfm(const char *name, svf_component *parent);

		virtual ~bidi_message_queue_bfm();

		void write32(uint32_t data);

		uint32_t read32();

		// TODO: Virtual methods implementing the target interface

		// TODO: Virtual methods implementing the host interface
		virtual void write_ack();
		virtual void read_ack(uint32_t data);

	private:
		svf_thread_mutex					m_outbound_mutex;
		svf_thread_cond						m_outbound_cond;
		svf_thread_mutex					m_inbound_mutex;
		svf_thread_cond						m_inbound_cond;

		uint32_t							m_read_data;


};

#endif /* INCLUDED_bidi_message_queue_bfm_H */
