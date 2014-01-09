/*
 * svf_sc_api.cpp
 *
 *  Created on: Jan 8, 2014
 *      Author: ballance
 */

#include "svf.h"

extern "C" void svf_sc_set_config_string(const char *path, const char *key, const char *val);
void svf_sc_set_config_string(const char *path, const char *key, const char *val)
{
	svf_config_db &db = svf_config_db::get_default();

	db.set_string(path, key, val, false);
}

