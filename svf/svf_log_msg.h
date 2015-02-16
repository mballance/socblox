/*
 * svf_log_msg.h
 *
 *  Created on: Feb 11, 2015
 *      Author: ballance
 */

#ifndef SVF_LOG_MSG_H_
#define SVF_LOG_MSG_H_
#include "svf_log_msg_if.h"
#include "svf_msg_def.h"

class svf_log_msg;
class svf_log_msg_it {

	public:

		svf_log_msg_it(const svf_log_msg *msg);

		inline bool next(svf_log_msg_if::param_t &t, svf_log_msg_if::param_u &v);


	private:
		const svf_log_msg	*m_msg;
		int32_t				m_idx;
};

class svf_log_msg : public svf_log_msg_if {
	friend class svf_log_msg_it;

	public:

		svf_log_msg();

		virtual ~svf_log_msg();

		virtual void init(svf_msg_def_base *msg, uint32_t n_params);

		virtual int param(uint32_t p);

		virtual int param(int32_t p);

		virtual int param(const char *p);

		virtual int param(const void *p);

	public:

		inline svf_log_msg_it iterator() const {
			return svf_log_msg_it(this);
		}

		inline const char *fmt() const { return m_msg_def->fmt(); }

		inline svf_log_msg *next() const { return m_next; }
		inline void set_next(svf_log_msg *n) { m_next = n; }

	private:


	private:
		char						*m_msg;
		svf_msg_def_base			*m_msg_def;

		uint32_t					m_params_idx;
		uint32_t					m_n_params;
		uint32_t					m_max_params;
		param_t						*m_params_t;
		param_u						*m_params_u;

		svf_log_msg					*m_next;
};

bool svf_log_msg_it::next(svf_log_msg_if::param_t &t, svf_log_msg_if::param_u &v) {
	if (m_idx >= 0) {
		t = m_msg->m_params_t[m_idx];
		v = m_msg->m_params_u[m_idx];
		m_idx--;
		return true;
	} else {
		return false;
	}
}

#endif /* SVF_LOG_MSG_H_ */
