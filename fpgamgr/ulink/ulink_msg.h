/*
 * ulink_msg.h
 *
 *  Created on: Jan 5, 2015
 *      Author: ballance
 */

#ifndef ULINK_MSG_H_
#define ULINK_MSG_H_
#include <stdint.h>

class ulink_msg {
	public:
		ulink_msg();
		virtual ~ulink_msg();

		inline uint32_t size() const { return m_size; }
		uint8_t *data() const { return m_data; }

		inline bool checksum_err() const { return m_checksum_err; }
		inline void set_checksum_err(bool err) { m_checksum_err = err; }

		void set_size(uint32_t sz) { m_size = sz; }

		void ensure_size(uint32_t sz);

		void ensure_avail(uint32_t sz);

		void append(uint8_t *buf, uint32_t sz);

		void write8(uint8_t b);

		void write32(uint32_t v);

		uint8_t read8();

		uint32_t read32();

		void seek(uint32_t pos) { m_read_idx = pos; }


		inline ulink_msg *next() const { return m_next; }
		inline void set_next(ulink_msg *nxt) { m_next = nxt; }

	private:
		bool				m_checksum_err;
		ulink_msg			*m_next;
		uint32_t			m_size;
		uint32_t			m_max_size;
		uint8_t				*m_data;
		uint32_t			m_read_idx;
};

#endif /* ULINK_MSG_H_ */
