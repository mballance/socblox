/*
 * svf_bridge_link_impl.h
 *
 *  Created on: Feb 17, 2015
 *      Author: ballance
 */

#ifndef SVF_BRIDGE_LINK_IMPL_H_
#define SVF_BRIDGE_LINK_IMPL_H_

#include "svf.h"
#include "svf_bridge_link_if.h"
#include "svf_bridge_loopback_msg.h"

class svf_bridge_loopback;
class svf_bridge_link_impl: public svf_bridge_link_if {

	public:
		svf_bridge_link_impl();

		virtual ~svf_bridge_link_impl();

		void init(svf_bridge_loopback *parent, svf_bridge_link_impl *other);

		virtual int32_t get_next_message_sz(bool block=true);

		virtual int32_t read_next_message(uint32_t *data);

		virtual int32_t send_message(uint32_t sz, uint32_t *data);

		void recv_msg(svf_bridge_loopback_msg *msg);

	private:
		svf_bridge_loopback					*m_parent;
		svf_bridge_link_impl				*m_other;

		svf_bridge_loopback_msg				*m_recv;
		svf_thread_cond						m_recv_cond;
		svf_thread_mutex					m_recv_mutex;

};

#endif /* SVF_BRIDGE_LINK_IMPL_H_ */
