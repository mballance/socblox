/*
 * svf_bridge_socket.h
 *
 *  Created on: Jul 27, 2014
 *      Author: ballance
 */

#ifndef SVF_BRIDGE_SOCKET_H_
#define SVF_BRIDGE_SOCKET_H_
#include "svf_bridge_if.h"


class svf_bridge_socket {

	public:
		svf_bridge_socket(
				const char				*sock_type,
				const char				*sock_name
				);

		virtual ~svf_bridge_socket();

		virtual void init(svf_bridge_if *bridge_if, uint32_t socket_id);

		inline bool is_connected() const { return m_is_connected; }

		void wait_connected();

		svf_bridge_msg *alloc_msg();

		void send_msg(svf_bridge_msg *msg);

		svf_bridge_msg *recv_msg(bool block=true);

		void free_msg(svf_bridge_msg *msg);

		// Methods for the bridge to call
	public:
		virtual void notify_connected(svf_bridge_socket *other);

		inline uint32_t get_socket_id() const { return m_socket_id; }

		virtual bool msg_received(svf_bridge_msg *msg);

		inline svf_bridge_socket *get_other() const { return m_other; }

	private:
		uint32_t					m_socket_id;
		svf_bridge_if				*m_bridge_if;
		bool						m_is_connected;
		svf_thread_mutex			m_connected_mutex;
		svf_thread_cond				m_connected_cond;
		svf_string					m_sock_type;
		svf_string					m_sock_name;

		svf_bridge_socket			*m_other;

		svf_bridge_msg				*m_recv_queue;
		svf_thread_mutex			m_recv_mutex;
		svf_thread_cond				m_recv_cond;
};

#endif /* SVF_BRIDGE_SOCKET_H_ */
