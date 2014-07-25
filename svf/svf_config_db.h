/*
 * svf_config_db.h
 *
 *  Created on: Jan 8, 2014
 *      Author: ballance
 */

#ifndef SVF_CONFIG_DB_H_
#define SVF_CONFIG_DB_H_
#include "svf_ptr_vector.h"
#include <stdint.h>

using namespace std;

class svf_config_db_entry;
class svf_config_db {

	public:
		svf_config_db();

		svf_config_db(const svf_config_db &db);

		virtual ~svf_config_db();

		void set_string(const char *path, const char *key, const char *val, bool exp=false);

		bool get_string(const char *path, const char *key, const char **val);

		static svf_config_db &get_default();

	private:
		svf_config_db_entry *find(uint32_t type, const char *path, const char *key);

	private:
		static svf_config_db				*m_default;
		svf_ptr_vector<svf_config_db_entry>	m_entries;

};

#endif /* SVF_CONFIG_DB_H_ */
