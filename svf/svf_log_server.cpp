/*
 * svf_log_server.cpp
 *
 *  Created on: Feb 10, 2015
 *      Author: ballance
 */

#include "svf_log_server.h"
#include "svf_log_handle.h"
#include "svf_log_msg.h"

svf_log_server::svf_log_server() {
	// TODO Auto-generated constructor stub
	m_msg_renderer = 0;

}

svf_log_server::~svf_log_server() {
	// TODO Auto-generated destructor stub
}

svf_log_msg_if *svf_log_server::alloc_msg() {
	return new svf_log_msg();
}

svf_log_server *svf_log_server::get_default() {
	if (!m_default) {
		m_default = svf_log_server::type_id.create();
	}

	return m_default;
}

void svf_log_server::set_default(svf_log_server *dflt) {
//	if (m_default) {
//		delete m_default;
//	}
	m_default = dflt;
}

svf_log_handle *svf_log_server::get_log_handle(const char *name) {
	if (!name) {
		name = "";
	}

	svf_log_handle *hndl = m_log_handle_map.find(name);

	if (!hndl) {
		hndl = new svf_log_handle(name, this, m_log_handle_id);
		m_log_handle_map.insert(name, hndl);
	}

	return hndl;
}

svf_log_server *svf_log_server::m_default = 0;

svf_object_ctor_def(svf_log_server)
