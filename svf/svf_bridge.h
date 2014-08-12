/*
 * svf_bridge.h
 *
 *  Created on: Mar 30, 2014
 *      Author: ballance
 */

#ifndef SVF_BRIDGE_H_
#define SVF_BRIDGE_H_
#include "svf_component.h"
#include "svf_bridge_if.h"
#include "svf_bridge_msg.h"
#include "svf_ptr_vector.h"

class svf_bridge : public svf_component, public virtual svf_bridge_if {
	public:
		svf_bridge(const char *name, svf_component *parent);

		virtual ~svf_bridge();

		svf_bridge_msg *alloc_msg();

		void free_msg(svf_bridge_msg *msg);

		void send_msg(svf_bridge_socket *sock, svf_bridge_msg *msg);

		void register_socket(svf_bridge_socket *sock);

		void register_remote_socket(svf_bridge_socket *sock);

	private:

		svf_bridge_msg							*m_alloc_list;
		svf_ptr_vector<svf_bridge_socket>		m_local_sockets;
		svf_ptr_vector<svf_bridge_socket>		m_remote_sockets;

};

#endif /* SVF_BRIDGE_H_ */
