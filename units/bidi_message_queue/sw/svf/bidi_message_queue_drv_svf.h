/*
 * bidi_message_queue_drv_svf.h
 *
 *  Created on: Feb 16, 2015
 *      Author: ballance
 */

#ifndef BIDI_MESSAGE_QUEUE_DRV_SVF_H_
#define BIDI_MESSAGE_QUEUE_DRV_SVF_H_
#include "svf.h"
#include "bidi_message_queue_ptr_drv.h"

class bidi_message_queue_drv_svf: public svf_component, public bidi_message_queue_ptr_drv,
	public virtual svf_bridge_link_if {

	svf_component_ctor_decl(bidi_message_queue_drv_svf)

	public:
		svf_api_export<svf_bridge_link_if>					link_port;

	public:
		bidi_message_queue_drv_svf(
				const char			*name,
				svf_component		*parent);

		virtual ~bidi_message_queue_drv_svf();

		// Wait for inbound data to be available
		virtual void wait_inbound();

		// Wait for space in the outbound queue to be available
		virtual void wait_outbound();

		virtual int32_t get_next_message_sz(bool block=true);

		virtual int32_t read_next_message(uint32_t *data);

		virtual int32_t send_message(uint32_t sz, uint32_t *data);

//		virtual void inbound_lock();
//		virtual void inbound_unlock();
//
//		virtual void outbound_lock();
//		virtual void outbound_unlock();

	private:
		svf_thread_mutex					m_inbound_mutex;
		svf_thread_mutex					m_outbound_mutex;

};

#endif /* BIDI_MESSAGE_QUEUE_DRV_SVF_H_ */
