/*
 * svf_log_handle.cpp
 *
 *  Created on: Feb 10, 2015
 *      Author: ballance
 */

#include "svf_log_handle.h"
#include "svf_log_msg.h"

svf_log_handle::svf_log_handle(const char *name, svf_log_server *log_srv, uint32_t id) :
	m_enabled(true), m_name(name), m_log_srv(log_srv), m_id(id) {
}

svf_log_handle::~svf_log_handle() {
	// TODO Auto-generated destructor stub
}

void svf_log_handle::msg(svf_log_msg_if *msg) {
	svf_log_msg *msg_l = static_cast<svf_log_msg *>(msg);

	delete msg_l;
}

svf_log_msg_if *svf_log_handle::alloc_msg() {
	return new svf_log_msg();
}

