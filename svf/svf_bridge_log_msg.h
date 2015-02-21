/*
 * svf_bridge_log_msg.h
 *
 *  Created on: Feb 19, 2015
 *      Author: ballance
 */

#ifndef SVF_BRIDGE_LOG_MSG_H_
#define SVF_BRIDGE_LOG_MSG_H_

#include "svf_bridge_msg.h"
#include "svf_log_msg_if.h"

class svf_bridge_log_renderer;
class svf_bridge_log_msg: public virtual svf_log_msg_if {

	public:
		svf_bridge_log_msg(svf_bridge_log_renderer *renderer);

		virtual ~svf_bridge_log_msg();

		virtual void init(svf_bridge_msg *msg);

		virtual void init(svf_msg_def_base *msg, uint32_t n_params);

		// svf_log_msg_if implementation
		virtual int param(uint32_t p);

		virtual int param(int32_t p);

		virtual int param(const char *p);

		virtual int param(const void *p);

		inline svf_bridge_log_msg *next() const { return m_next; }
		inline void set_next(svf_bridge_log_msg *next) { m_next = next; }

		inline svf_bridge_msg *msg() const { return m_msg; }

	private:
		svf_bridge_msg						*m_msg;
		svf_bridge_log_renderer				*m_renderer;
		svf_bridge_log_msg					*m_next;

};

#endif /* SVF_BRIDGE_LOG_MSG_H_ */
