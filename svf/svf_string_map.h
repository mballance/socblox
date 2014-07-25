/*
 * svf_string_map.h
 *
 *  Created on: Jul 24, 2014
 *      Author: ballance
 */

#ifndef SVF_STRING_MAP_H_
#define SVF_STRING_MAP_H_
#include <stdint.h>
#include "svf_string.h"
#include "svf_ptr_vector.h"

class svf_string_map_base {
	public:
		svf_string_map_base();

		virtual ~svf_string_map_base();

	protected:

		void insert_int(const char *key, void *value);

		void *find_int(const char *key) const;

	private:
		svf_ptr_vector<svf_string>		m_keys;
		svf_ptr_vector<void>			m_values;
};

// Wrapper for generic map
template <class T> class svf_string_map : public svf_string_map_base {

	public:

		svf_string_map() {};

		virtual ~svf_string_map() {}

		inline void insert(const char *key, T *value) { insert_int(key, value); }

		inline T *find(const char *key) const { return static_cast<T *>(find_int(key)); }

};

#endif /* SVF_STRING_MAP_H_ */
