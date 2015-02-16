/*
 * svf_bridge_link_if.h
 *
 *  Created on: Feb 10, 2015
 *      Author: ballance
 */

#ifndef SVF_BRIDGE_LINK_IF_H_
#define SVF_BRIDGE_LINK_IF_H_
#include <stdint.h>

class svf_bridge_link_if {

	public:

		virtual ~svf_bridge_link_if() { }

		virtual int32_t get_next_message_sz(bool block=true) = 0;

		virtual int32_t read_next_message(uint32_t *data) = 0;

		virtual int32_t send_message(uint32_t sz, uint32_t *data) = 0;

};



#endif /* SVF_BRIDGE_LINK_IF_H_ */
