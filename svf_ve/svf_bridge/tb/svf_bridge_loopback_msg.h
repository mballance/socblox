/*
 * svf_bridge_loopback_msg.h
 *
 *  Created on: Feb 17, 2015
 *      Author: ballance
 */

#ifndef SVF_BRIDGE_LOOPBACK_MSG_H_
#define SVF_BRIDGE_LOOPBACK_MSG_H_
#include <stdint.h>

class svf_bridge_loopback_msg {

	public:
		svf_bridge_loopback_msg();

		virtual ~svf_bridge_loopback_msg();

		void init(uint32_t sz, uint32_t *data);

		void read(uint32_t *data);

		inline uint32_t size() const { return m_msg_sz; }

		inline svf_bridge_loopback_msg *next() const { return m_next; }
		inline void set_next(svf_bridge_loopback_msg *next) { m_next = next; }

	private:
		uint32_t					m_msg_sz;
		uint32_t					m_msg_max;
		uint32_t					*m_data;

		svf_bridge_loopback_msg		*m_next;

};

#endif /* SVF_BRIDGE_LOOPBACK_MSG_H_ */
