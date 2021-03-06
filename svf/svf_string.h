/*
 * svf_string.h
 *
 *  Created on: Jul 24, 2014
 *      Author: ballance
 */

#ifndef SVF_STRING_H_
#define SVF_STRING_H_
#include <stdint.h>

class svf_string {

	public:
		svf_string();

		svf_string(const char *str);

		virtual ~svf_string();

		void operator = (const char *str);

		inline void append(char c) {
			if (m_size+1 >= m_max) {
				ensure_space(m_size+1);
			}
			m_store[m_size++] = c;
			m_store[m_size+1] = 0;
		}

		void ensure_space(uint32_t sz);

		inline bool operator == (const char *other) const { return equals(other); }

		inline bool operator == (const svf_string &other) const { return equals(other); }

		bool equals(const char *other) const;

		bool equals(const svf_string &other) const;

		inline char at(uint32_t idx) const { return m_store[idx]; }

		inline const char *c_str() const { return m_store; }

		inline uint32_t size() const { return m_size; }

		inline void clear() {
			m_size = 0;
			if (m_store) {
				m_store[0] = 0;
			}
		}

	private:
		uint32_t			m_size;
		uint32_t			m_max;
		char				*m_store;
};

#endif /* SVF_STRING_H_ */
