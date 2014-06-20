/*
 * bidi_message_queue_direct_bfm.h
 *
 *  Created on: Dec 22, 2013
 *      Author: ballance
 */

#ifndef INCLUDED_bidi_message_queue_direct_bfm_H
#define INCLUDED_bidi_message_queue_direct_bfm_H
#include "svf.h"
#include "bidi_message_queue_direct_bfm_dpi_mgr.h"
#include "bidi_message_queue_drv_if.h"

class bidi_message_queue_direct_bfm : public svf_component,
	public virtual bidi_message_queue_direct_bfm_host_if,
	public virtual bidi_message_queue_drv_if {

	svf_component_ctor_decl(bidi_message_queue_direct_bfm)

	public:
		svf_bidi_api_port<bidi_message_queue_direct_bfm_host_if, bidi_message_queue_direct_bfm_target_if>	bfm_port;

	public:

		bidi_message_queue_direct_bfm(const char *name, svf_component *parent);

		virtual ~bidi_message_queue_direct_bfm();

		virtual void start();

		virtual int32_t get_next_message_sz(bool block=true);

		virtual int32_t read_next_message(uint32_t *data);

		virtual int32_t write_message(uint32_t sz, uint32_t *data);

		// TODO: Virtual methods implementing the target interface

		// TODO: Virtual methods implementing the host interface

		virtual void inbound_avail_ack();
		virtual void outbound_avail_ack();

	private:

		int32_t						m_inbound_sz;
		uint32_t					m_queue_sz;

		svf_thread_mutex			m_inbound_mutex;
		svf_thread_mutex			m_outbound_mutex;

		svf_thread_mutex			m_inbound_avail_mutex;
		svf_thread_cond				m_inbound_avail_cond;

		svf_thread_mutex			m_outbound_avail_mutex;
		svf_thread_cond				m_outbound_avail_cond;

};

#endif /* INCLUDED_bidi_message_queue_direct_bfm_H */
