
#ifndef INCLUDED_SVF_BRIDGE_MSG_H
#define INCLUDED_SVF_BRIDGE_MSG_H
#include <stdint.h>

class svf_bridge;
class svf_bridge_msg {
	friend class svf_bridge;

	public:

		svf_bridge_msg();

		virtual ~svf_bridge_msg();

		inline svf_bridge_msg *get_next() const { return m_next; }

		inline void set_next(svf_bridge_msg *next) { m_next = next; }

		void write32(uint32_t data);

		void set_data(uint32_t off, uint32_t data);

		void ensure_space(uint32_t sz);

	private:

		uint32_t				*m_data;
		uint32_t				m_read_idx;
		uint32_t				m_size;
		uint32_t				m_max;

		svf_bridge_msg			*m_next;

};

#endif /* INCLUDED_SVF_BRIDGE_MSG_H */
