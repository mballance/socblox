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

		inline bool operator == (const char *other) const { return equals(other); }

		inline bool operator == (const svf_string &other) const { return equals(other); }

		bool equals(const char *other) const;

		bool equals(const svf_string &other) const;

		inline char at(uint32_t idx) const { return m_store[idx]; }

		inline const char *c_str() const { return m_store; }

		inline uint32_t size() const { return m_size; }


	private:
		uint32_t			m_size;
		uint32_t			m_max;
		char				*m_store;
};

#endif /* SVF_STRING_H_ */
