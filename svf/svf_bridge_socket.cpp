/*
 * svf_bridge_socket.cpp
 *
 *  Created on: Jul 27, 2014
 *      Author: ballance
 */

#include "svf_bridge_socket.h"

svf_bridge_socket::svf_bridge_socket(
		const char			*sock_type,
		const char			*sock_name) : m_sock_type(sock_type), m_sock_name(sock_name) {
	m_is_connected = false;
	m_bridge_if = 0;
	m_other = 0;
}

svf_bridge_socket::~svf_bridge_socket() {
	// TODO Auto-generated destructor stub
}

void svf_bridge_socket::init(svf_bridge_if *bridge_if, uint32_t socket_id) {
	m_bridge_if = bridge_if;
	m_socket_id = socket_id;
}

void svf_bridge_socket::wait_connected()
{
	m_connected_mutex.lock();
	while (!is_connected()) {
		m_connected_cond.wait(m_connected_mutex);
	}
	m_connected_mutex.unlock();
}

svf_bridge_msg *svf_bridge_socket::alloc_msg()
{
	return m_bridge_if->alloc_msg();
}

void svf_bridge_socket::send_msg(svf_bridge_msg *msg)
{
	m_bridge_if->send_msg(this, msg);
}

svf_bridge_msg *svf_bridge_socket::recv_msg(bool block)
{
	svf_bridge_msg *ret = 0;

	m_recv_mutex.lock();
	while (!m_recv_queue && block) {
		m_recv_cond.wait(m_recv_mutex);
	}
	ret = m_recv_queue;
	if (m_recv_queue) {
		m_recv_queue = m_recv_queue->get_next();
		ret->set_next(0);
	}
	m_recv_mutex.unlock();

	return ret;
}

void svf_bridge_socket::free_msg(svf_bridge_msg *msg)
{
	m_bridge_if->free_msg(msg);
}

void svf_bridge_socket::notify_connected(svf_bridge_socket *other)
{
	m_other = other;
	m_connected_mutex.lock();
	m_is_connected = true;
	m_connected_cond.notify_all();
	m_connected_mutex.unlock();
}

bool svf_bridge_socket::msg_received(svf_bridge_msg *msg)
{
	m_recv_mutex.lock();
	msg->set_next(0);
	if (!m_recv_queue) {
		m_recv_queue = msg;
	} else {
		// Spin to the end of the queue
		svf_bridge_msg *tmp = m_recv_queue;
		while (tmp->get_next()) {
			tmp = tmp->get_next();
		}
		tmp->set_next(msg);
	}
	m_recv_cond.notify();
	m_recv_mutex.unlock();

	return false;
}
