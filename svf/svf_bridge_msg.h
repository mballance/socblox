
#ifndef INCLUDED_SVF_BRIDGE_MSG_H
#define INCLUDED_SVF_BRIDGE_MSG_H
#include <stdint.h>

class svf_bridge_msg {

	public:

		svf_bridge_msg();

		virtual ~svf_bridge_msg();

		inline svf_bridge_msg *get_next() const { return m_next; }

		inline void set_next(svf_bridge_msg *next) { m_next = next; }

	private:

		uint32_t				*m_data;
		uint32_t				m_size;
		uint32_t				m_max;

		svf_bridge_msg			*m_next;

};

#endif /* INCLUDED_SVF_BRIDGE_MSG_H */
