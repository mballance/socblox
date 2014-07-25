/*
 * svf_string_map.cpp
 *
 *  Created on: Jul 24, 2014
 *      Author: ballance
 */

#include "svf_string_map.h"

svf_string_map_base::svf_string_map_base() {
}

svf_string_map_base::~svf_string_map_base() {
	// TODO Auto-generated destructor stub
}

void svf_string_map_base::insert_int(const char *key, void *value)
{
	m_keys.push_back(new svf_string(key));
	m_values.push_back(value);
}

void *svf_string_map_base::find_int(const char *key) const
{
	void *ret = 0;

	for (uint32_t i=0; i<m_keys.size(); i++) {
		if (m_keys.at(i)->equals(key)) {
			ret = m_values.at(i);
			break;
		}
	}

	return ret;
}

