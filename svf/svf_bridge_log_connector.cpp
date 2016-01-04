/*
 * svf_bridge_log_connector.cpp
 *
 *  Created on: Feb 21, 2015
 *      Author: ballance
 */

#include "svf_bridge_log_connector.h"
#include "svf_bridge_log_renderer.h"
#include <string.h>
#include <stdio.h>

svf_bridge_log_connector::svf_bridge_log_connector(svf_log_server *svr) :
	svf_bridge_socket("LOG", "DEFAULT") {
	m_svr = svr;
}

svf_bridge_log_connector::~svf_bridge_log_connector() {
	// TODO Auto-generated destructor stub
}

bool svf_bridge_log_connector::msg_received(svf_bridge_msg *msg) {

	svf_bridge_log_renderer::msg_t msg_code =
			(svf_bridge_log_renderer::msg_t)msg->read32();

	switch (msg_code) {
		case svf_bridge_log_renderer::MSG_REGISTER_MSG_FORMAT: {
			uint32_t id = msg->read32();
			if (id >= m_msg_formats.size()) {
				m_msg_formats.set_size(id+1);
			}
			svf_string fmt;
			msg->read_str(fmt);
			char *fmt_s = new char[fmt.size()+1];
			strcpy(fmt_s, fmt.c_str());

			svf_msg_def_base *def = new svf_msg_def_base(id, fmt_s);

			m_msg_formats.set(id, def);
		} break;

		case svf_bridge_log_renderer::MSG_LOG_MSG: {
			uint32_t id = msg->read32();
			uint32_t n_params = msg->read32();
			svf_string str;

			svf_msg_renderer_if *r = m_svr->get_msg_renderer();
			svf_log_msg_if *m = r->alloc_msg();

			svf_msg_def_base *fmt = m_msg_formats.at(id);
			m->init(fmt, n_params);

			for (uint32_t i=0; i<n_params; i++) {
				svf_log_msg_if::param_t ptype = (svf_log_msg_if::param_t)msg->read32();
				switch (ptype) {
					case svf_log_msg_if::u32:
						m->param(msg->read32());
						break;
					case svf_log_msg_if::cchar: {
						msg->read_str(str);
						m->param(str.c_str());
						} break;
					case svf_log_msg_if::cvoid: {
						uint32_t low, high;
						low = msg->read32();
						high = msg->read32();
						uint64_t val = high;
						val <<= 32;
						val |= low;
						m->param(reinterpret_cast<void *>(val));
						} break;
				}
			}

			r->msg(m);
		} break;

		case svf_bridge_log_renderer::MSG_STR_LOG_MSG: {
			svf_string str;
			msg->read_str(str);
			fprintf(stdout, "STR: %s\n", str.c_str());
			} break;

		default: {
			fprintf(stdout, "Error: Unknwon message-renderer code: %d\n", msg_code);
		} break;
	}

	return false;
}
