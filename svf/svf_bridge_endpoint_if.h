/*
 * svf_bridge_endpoint_if.h
 *
 *  Created on: Mar 30, 2014
 *      Author: ballance
 */

#ifndef SVF_BRIDGE_ENDPOINT_IF_H_
#define SVF_BRIDGE_ENDPOINT_IF_H_
#include <stdint.h>

class svf_bridge_if;
class svf_bridge_endpoint_if {

	public:

		virtual ~svf_bridge_endpoint_if() {}

		virtual void init_endpoint(svf_bridge_if *bridge_if, uint32_t id) = 0;

		/**
		 * Called by the bridge to deliver a message
		 * to the endpoint. Returns 'true' if the endpoint
		 * is finished with the message. Returns 'false' if
		 * the endpoint wishes to hold on to the message.
		 */
		virtual bool recv_msg(svf_bridge_msg *msg) = 0;

};



#endif /* SVF_BRIDGE_ENDPOINT_IF_H_ */
