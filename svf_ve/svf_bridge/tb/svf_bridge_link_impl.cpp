/*
 * svf_bridge_link_impl.cpp
 *
 *  Created on: Feb 17, 2015
 *      Author: ballance
 */

#include "svf_bridge_link_impl.h"
#include "svf_bridge_loopback.h"

svf_bridge_link_impl::svf_bridge_link_impl() {
	m_parent = 0;
	m_other = 0;
	m_recv = 0;
}

svf_bridge_link_impl::~svf_bridge_link_impl() {
	// TODO Auto-generated destructor stub
}

void svf_bridge_link_impl::init(svf_bridge_loopback *parent, svf_bridge_link_impl *other) {
	m_parent = parent;
	m_other = other;
}

int32_t svf_bridge_link_impl::get_next_message_sz(bool block) {
	if (!block && !m_recv) {
		return -1;
	}

	while (!m_recv) {
		m_recv_mutex.lock();
		m_recv_cond.wait(m_recv_mutex);
		m_recv_mutex.unlock();
	}

	return m_recv->size();
}

int32_t svf_bridge_link_impl::read_next_message(uint32_t *data) {
	svf_bridge_loopback_msg *msg = m_recv;
	m_recv = m_recv->next();
	msg->read(data);
	m_parent->free_msg(msg);

	return msg->size();
}

int32_t svf_bridge_link_impl::send_message(uint32_t sz, uint32_t *data) {
	svf_bridge_loopback_msg *msg = m_parent->alloc_msg();
	msg->init(sz, data);

	m_other->recv_msg(msg);
}

void svf_bridge_link_impl::recv_msg(svf_bridge_loopback_msg *msg) {
	if (!m_recv) {
		m_recv = msg;
		m_recv_mutex.lock();
		m_recv_cond.notify_all();
		m_recv_mutex.unlock();
	} else {
		svf_bridge_loopback_msg *tmp = m_recv;

		while (tmp->next()) {
			tmp = tmp->next();
		}

		tmp->set_next(msg);
		msg->set_next(0);
	}
}

