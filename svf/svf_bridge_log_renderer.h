/*
 * svf_bridge_log_renderer.h
 *
 *  Created on: Feb 19, 2015
 *      Author: ballance
 */

#ifndef SVF_BRIDGE_LOG_RENDERER_H_
#define SVF_BRIDGE_LOG_RENDERER_H_

#include "svf_bridge_socket.h"
#include "svf_msg_renderer_if.h"
#include "svf_msg_def.h"
#include "svf_bridge_log_msg.h"

class svf_bridge_log_renderer: public svf_bridge_socket,
		public virtual svf_msg_renderer_if {

	public:
		typedef enum {
			MSG_REGISTER_MSG_FORMAT,
			MSG_LOG_MSG,
			MSG_STR_LOG_MSG
		} msg_t;

	public:
		svf_bridge_log_renderer();

		virtual ~svf_bridge_log_renderer();

		virtual svf_log_msg_if *alloc_msg();

		virtual void msg(svf_log_msg_if *msg);

		void register_msg_format(svf_msg_def_base *msg_fmt);


	private:
		svf_bridge_log_msg				*m_msg_alloc;
		uint32_t 						*m_msg_fmt_registered;
		uint32_t						m_msg_fmt_registered_sz;

};

#endif /* SVF_BRIDGE_LOG_RENDERER_H_ */
