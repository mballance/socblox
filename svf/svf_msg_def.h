/*
 * svf_msg_def.h
 *
 *  Created on: May 4, 2014
 *      Author: ballance
 */

#ifndef SVF_MSG_DEF_H_
#define SVF_MSG_DEF_H_
#include "svf_log_msg_if.h"
#include "svf_log_if.h"

class svf_msg_def_base {
	protected:
		static int					m_msg_id_i;
		static svf_msg_def_base		*m_last_msg;
};

template <typename ...Ts> class svf_msg_def : public svf_msg_def_base {

	public:
		svf_msg_def(const char *fmt) : m_id(m_msg_id_i++), m_fmt(fmt), m_next_msg(m_last_msg) {
			m_last_msg = this;
		}

		void msg(svf_log_if *log, Ts... args) {
			svf_log_msg_if *msg = log->alloc_msg();
			msg->init(this, sizeof...(args));
			pass(msg->param(args)...);
			log->msg(msg);
		}

	private:

		template <typename ...Ts> void pass(Ts... args) { }

	private:
		uint32_t				m_id;
		const char				*m_fmt;
		svf_msg_def_base		*m_next_msg;
};

#endif /* SVF_MSG_DEF_H_ */
