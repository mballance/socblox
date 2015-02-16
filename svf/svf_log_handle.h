/*
 * svf_log_handle.h
 *
 *  Created on: Feb 10, 2015
 *      Author: ballance
 */

#ifndef SVF_LOG_HANDLE_H_
#define SVF_LOG_HANDLE_H_
#include "svf_log_if.h"
#include "svf_string.h"

class svf_log_server;
class svf_log_handle : public svf_log_if {

	public:
		bool							m_enabled;

	public:
		svf_log_handle(const char *name, svf_log_server *log_srv, uint32_t id);

		virtual ~svf_log_handle();

		void msg(svf_log_msg_if *msg);

		svf_log_msg_if *alloc_msg();

		inline svf_log_server *get_server() const {
			return m_log_srv;
		}

	private:
		svf_string						m_name;
		svf_log_server					*m_log_srv;
		uint32_t						m_id;
};

#endif /* SVF_LOG_HANDLE_H_ */
