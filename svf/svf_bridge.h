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
#include "svf_bridge_link_if.h"
#include "svf_api_port.h"
#include "svf_thread.h"

class svf_bridge_socket;
class svf_bridge : public svf_component, public virtual svf_bridge_if {
	friend class svf_bridge_socket;

	public:

		svf_api_port<svf_bridge_link_if>	link_port;

	public:
		svf_bridge(const char *name, svf_component *parent);

		virtual ~svf_bridge();

		void start();

		void register_socket(svf_bridge_socket *sock);

	protected:
		// Managment channel messages
		typedef enum {
			MGMT_REGISTER_SOCKET=1
		} mgmt_channel_msg_e;

	// Methods used by sockets
	protected:
		svf_bridge_msg *alloc_msg();

		void free_msg(svf_bridge_msg *msg);

		void send_msg(svf_bridge_msg *msg);

	private:
		void recv_loop();

	private:

		svf_bridge_msg							*m_alloc_list;
		svf_ptr_vector<svf_bridge_socket>		m_local_sockets;
		svf_ptr_vector<svf_bridge_socket>		m_remote_sockets;
		svf_thread								m_recv_thread;


};

#endif /* SVF_BRIDGE_H_ */
