/*
 * svf_bridge_log_renderer.cpp
 *
 *  Created on: Feb 19, 2015
 *      Author: ballance
 */

#include "svf_bridge_log_renderer.h"

#include <stdio.h>
#include <string.h>

#include "svf_bridge_socket.h"
#include "svf_log_msg_if.h"
#include "svf_msg_def.h"

svf_bridge_log_renderer::svf_bridge_log_renderer() :
	svf_bridge_socket("LOG", "DEFAULT") {

	m_msg_alloc = 0;
	m_msg_fmt_registered = 0;
	m_msg_fmt_registered_sz = 0;
}

svf_bridge_log_renderer::~svf_bridge_log_renderer() {
	// TODO Auto-generated destructor stub
}

svf_log_msg_if *svf_bridge_log_renderer::alloc_msg() {
	svf_bridge_log_msg *ret;
	if (m_msg_alloc) {
		svf_bridge_log_msg *ret = m_msg_alloc;
		m_msg_alloc = ret->next();
		ret->set_next(0);
	} else {
		ret = new svf_bridge_log_msg(this);
	}

	ret->init(svf_bridge_socket::alloc_msg());

	return ret;
}

void svf_bridge_log_renderer::msg(svf_log_msg_if *msg) {
	svf_bridge_log_msg *log_msg = reinterpret_cast<svf_bridge_log_msg *>(msg);
	svf_bridge_socket::send_msg(log_msg->msg());

	log_msg->set_next(m_msg_alloc);
	m_msg_alloc = log_msg;
}

void svf_bridge_log_renderer::register_msg_format(svf_msg_def_base *msg_fmt) {
	uint32_t id = msg_fmt->id();
	uint32_t idx = id/32;
	uint32_t off = id % 32;
	bool registered = true;

	if (idx >= m_msg_fmt_registered_sz) {
		uint32_t *tmp = m_msg_fmt_registered;
		uint32_t new_sz = ((idx/16)+1)*16;
		m_msg_fmt_registered = new uint32_t[new_sz];
		if (m_msg_fmt_registered_sz > 0) {
			memcpy(m_msg_fmt_registered, tmp, m_msg_fmt_registered_sz*sizeof(uint32_t));
		}
		memset(&m_msg_fmt_registered[m_msg_fmt_registered_sz], 0,
				(new_sz-m_msg_fmt_registered_sz)*sizeof(uint32_t));
		if (tmp) {
			delete [] tmp;
		}
		m_msg_fmt_registered_sz = new_sz;
	}

	if ((m_msg_fmt_registered[idx] & (1 << off)) == 0) {
		// This message hasn't been registered yet. Send a message to register it
//		fprintf(stdout, "Registering message format %d\n", id);
		svf_bridge_msg *msg = svf_bridge_socket::alloc_msg();
		msg->write32(MSG_REGISTER_MSG_FORMAT); // register_msg_def
		msg->write32(msg_fmt->id());
		msg->write_str(msg_fmt->fmt());
		send_msg(msg);
		m_msg_fmt_registered[idx] |= (1 << off);
	}
}

