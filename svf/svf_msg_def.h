/*
 * svf_msg_def.h
 *
 *  Created on: May 4, 2014
 *      Author: ballance
 */

#ifndef SVF_MSG_DEF_H_
#define SVF_MSG_DEF_H_
class svf_msg_def_base;
#include "svf_log_msg_if.h"
#include "svf_log_if.h"
#include "svf_log_handle.h"
#include "svf_log_server.h"
#include "svf_msg_renderer_if.h"

class svf_msg_def_base {

	public:
		svf_msg_def_base(uint32_t id, const char *fmt) : m_id(id), m_fmt(fmt) {
		}

		inline const char *fmt() const { return m_fmt; }
		inline uint32_t id() const { return m_id; }

	protected:
		uint32_t				m_id;
		const char				*m_fmt;

	protected:
		static int					m_msg_id_i;
		static svf_msg_def_base		*m_last_msg;

};

template <typename ...Ts> class svf_msg_def : public svf_msg_def_base {

	public:
		svf_msg_def(const char *fmt) : svf_msg_def_base(m_msg_id_i++, fmt), m_next_msg(m_last_msg) {
			m_last_msg = this;
		}

		void msg(Ts... args) {
			svf_log_server *svr = svf_log_server::get_default();
			svf_log_handle *log = svr->get_log_handle(0);
			msg(log, args...);
		}

		void msg(svf_log_handle *log, Ts... args) {
			if (log->m_enabled) {
				svf_log_server *svr = log->get_server();
				svf_msg_renderer_if *r = svr->get_msg_renderer();
				if (r) {
				svf_log_msg_if *msg = r->alloc_msg();
				msg->init(this, sizeof...(args));
				pass(msg->param(args)...);
				r->msg(msg);
				}
			}
		}

	private:

		// Dummy method to force expansion of parameter list
		void pass(int args...) { }

	private:
		svf_msg_def_base		*m_next_msg;
};

//int svf_msg_def_base::m_msg_id_i = 0;
//svf_msg_def_base *svf_msg_def_base::m_last_msg = 0;

#endif /* SVF_MSG_DEF_H_ */
