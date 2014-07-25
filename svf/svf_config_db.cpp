/*
 * svf_config_db.cpp
 *
 *  Created on: Jan 8, 2014
 *      Author: ballance
 */

#include "svf_config_db.h"
#include "svf_string.h"
#include <stdio.h>

typedef enum {
	MatchFull,
	MatchPrefix,
	MatchSuffix
} svf_config_db_match_t;

typedef enum {
	ConfigTypeString
} svf_config_db_entry_t;

class svf_config_db_entry {

	public:

		svf_config_db_entry(
				svf_config_db_entry_t	type,
				const svf_string		&path,
				const svf_string 		&key,
				bool  					exp);

		virtual ~svf_config_db_entry() {}

		bool matches(svf_config_db_entry_t type, const svf_string &path, const svf_string &key);

		virtual svf_config_db_entry *clone() = 0;

	protected:
		svf_config_db_entry_t		m_type;
		svf_string					m_path;
//		svf_config_db_match_t		m_match_type;
		svf_string					m_key;
		bool						m_export;

};

svf_config_db_entry::svf_config_db_entry(
		svf_config_db_entry_t	type,
		const svf_string		&path,
		const svf_string		&key,
		bool					exp) : m_type(type), m_path(path), m_key(key), m_export(exp) {
}

bool svf_config_db_entry::matches(
		svf_config_db_entry_t		type,
		const svf_string 			&path,
		const svf_string 			&key)
{
	bool match = false;
	fprintf(stdout, "m_type=%d type=%d m_key=%s key=%s\n", m_type, type, m_key.c_str(), key.c_str());
	if (m_type == type) {
		if (m_key == key) {
			/*
		size_t pos = m_path.find_first_of('*');

		if (pos == string::npos) {
			// full match
			match = (path == m_path);
		} else if (pos == 0) {
			// suffix match
			if (path.length() >= m_path.length()-1) {
				match = (path.compare())
			}
//		if (fullString.length() >= ending.length()) {
//		        return (0 == fullString.compare (fullString.length() - ending.length(), ending.length(), ending));
//		    } else {
//		        return false;
//		    }
		} else {
			// prefix match
			if (path.length() >= m_path.length()-1) {
				match = (path.compare(pos+1, (m_path.length()-pos-1), m_path));
			}
		}
			 */
			match = true;
		}
	}

	return match;
}

class svf_string_config_db_entry : public svf_config_db_entry {

	public:

		svf_string_config_db_entry(
				const svf_string 	&path,
				const svf_string 	&key,
				const svf_string 	&val,
				bool			exp);

		const svf_string &get_value() const;

		virtual svf_config_db_entry *clone();

	private:
		svf_string				m_val;

};

svf_string_config_db_entry::svf_string_config_db_entry(
		const svf_string			&path,
		const svf_string			&key,
		const svf_string			&val,
		bool						exp) :
	svf_config_db_entry(ConfigTypeString, path, key, exp), m_val(val)
{
}

const svf_string &svf_string_config_db_entry::get_value() const
{
	return m_val;
}

svf_config_db_entry *svf_string_config_db_entry::clone() {
	svf_string_config_db_entry *ret = new svf_string_config_db_entry(m_path, m_key, m_val, m_export);

	return ret;
}

svf_config_db::svf_config_db() {
	// TODO Auto-generated constructor stub

}

svf_config_db::svf_config_db(const svf_config_db &db) {

	for (uint32_t i=0; i<db.m_entries.size(); i++) {
		svf_config_db_entry *ent = db.m_entries.at(i);
		ent = ent->clone();
		m_entries.push_back(ent);
	}
}

svf_config_db::~svf_config_db() {
	// TODO Auto-generated destructor stub
}

void svf_config_db::set_string(const char *path, const char *key, const char *val, bool exp)
{
	m_entries.push_back(new svf_string_config_db_entry(path, key, val, exp));
}

bool svf_config_db::get_string(const char *path, const char *key, const char **val)
{
	*val = 0;

	fprintf(stdout, "-- get_string()\n");

	svf_config_db_entry *ent = find(ConfigTypeString, path, key);

	if (ent) {
		*val = static_cast<svf_string_config_db_entry *>(ent)->get_value().c_str();
		return true;
	} else {
		return false;
	}
}

svf_config_db_entry *svf_config_db::find(uint32_t type, const char *path, const char *key)
{
	svf_config_db_entry_t type_t = (svf_config_db_entry_t)type;
	svf_string path_s = path;
	svf_string key_s = key;

	for (uint32_t i=0; i<m_entries.size(); i++) {
		fprintf(stdout, "Entry: %p\n", m_entries.at(i));
		if (m_entries.at(i)->matches(type_t, path_s, key_s)) {
			return m_entries.at(i);
		}
	}

	return 0;
}

svf_config_db &svf_config_db::get_default()
{
	if (!m_default) {
		m_default = new svf_config_db();
	}

	return *m_default;
}

svf_config_db *svf_config_db::m_default = 0;
