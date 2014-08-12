/*
 * svf_bridge.cpp
 *
 *  Created on: Mar 30, 2014
 *      Author: ballance
 */

#include "svf_bridge.h"

svf_bridge::svf_bridge(const char *name, svf_component *parent) :
	svf_component(name, parent) {
	// TODO Auto-generated constructor stub
	m_alloc_list = 0;
}

svf_bridge::~svf_bridge() {
	// TODO Auto-generated destructor stub
}

svf_bridge_msg *svf_bridge::alloc_msg()
{
	if (m_alloc_list) {
		svf_bridge_msg *ret = m_alloc_list;
		m_alloc_list = m_alloc_list->get_next();
		return ret;
	} else {
		return new svf_bridge_msg();
	}
}

void svf_bridge::free_msg(svf_bridge_msg *msg)
{
	msg->set_next(m_alloc_list);
	m_alloc_list = msg;
}

void svf_bridge::send_msg(svf_bridge_socket *sock, svf_bridge_msg *msg) {
	// TODO: specific implementation must be provided
}

void svf_bridge::register_socket(svf_bridge_socket *sock)
{
	uint32_t id = m_local_sockets.size()+1;
	sock->init(this, id);
	m_local_sockets.push_back(sock);

	// Look for matches in the previously-registered remote sockets
}

void svf_bridge::register_remote_socket(svf_bridge_socket *sock)
{
	m_remote_sockets.push_back(sock);

	// Look for matches in the previously-registered local sockets
}


