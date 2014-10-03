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

		void msg(svf_log_if *log, Ts... args) {
			svf_log_msg_if *msg = log->alloc_msg();
			msg->init(this, sizeof...(args));
//			msg->param(args)...;
			pass(msg->param(args)...);
			log->msg(msg);
		}

	private:

//		template <typename ...Ts> void pass(Ts... args) { }
//		void pass(Ts... args) { }
		// Dummy method to force expansion of parameter list
		void pass(int args...) { }

	private:
		svf_msg_def_base		*m_next_msg;
};

int svf_msg_def_base::m_msg_id_i = 0;
svf_msg_def_base *svf_msg_def_base::m_last_msg = 0;

#endif /* SVF_MSG_DEF_H_ */
