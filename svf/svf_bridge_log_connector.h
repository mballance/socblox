/*
 * svf_bridge_log_connector.h
 *
 *  Created on: Feb 21, 2015
 *      Author: ballance
 */

#ifndef SVF_BRIDGE_LOG_CONNECTOR_H_
#define SVF_BRIDGE_LOG_CONNECTOR_H_

#include "svf_bridge_socket.h"
#include "svf_log_server.h"
#include "svf_ptr_vector.h"

class svf_bridge_log_connector: public svf_bridge_socket {
	public:
		svf_bridge_log_connector(svf_log_server *svr);

		virtual ~svf_bridge_log_connector();

	protected:

		virtual bool msg_received(svf_bridge_msg *msg);

	private:
		svf_log_server						*m_svr;
		svf_ptr_vector<svf_msg_def_base>	m_msg_formats;

};

#endif /* SVF_BRIDGE_LOG_CONNECTOR_H_ */
