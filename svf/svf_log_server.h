/*
 * svf_log_server.h
 *
 *  Created on: Feb 10, 2015
 *      Author: ballance
 */

#ifndef SVF_LOG_SERVER_H_
#define SVF_LOG_SERVER_H_
#include "svf_object.h"
#include "svf_object_ctor.h"
#include "svf_log_if.h"
#include "svf_string_map.h"
#include "svf_msg_renderer_if.h"

class svf_log_handle;
class svf_log_server : public svf_object {
	svf_object_ctor_decl(svf_log_server);

	public:
		svf_log_server();

		virtual ~svf_log_server();

		virtual svf_log_msg_if *alloc_msg();

		void msg(svf_log_handle *hndl, svf_log_msg_if *msg);

		static svf_log_server *get_default();

		static void set_default(svf_log_server *dflt);

		svf_log_handle *get_log_handle(const char *name);

		inline svf_msg_renderer_if *get_msg_renderer() const {
			return m_msg_renderer;
		}

		void set_msg_renderer(svf_msg_renderer_if *r) {
			m_msg_renderer = r;
		}

	private:
		static svf_log_server			*m_default;

		svf_string_map<svf_log_handle>	m_log_handle_map;
		uint32_t						m_log_handle_id;

		svf_msg_renderer_if				*m_msg_renderer;



};

#endif /* SVF_LOG_SERVER_H_ */
