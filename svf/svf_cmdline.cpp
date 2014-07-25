/*
 * svf_cmdline.cpp
 *
 *  Created on: Dec 25, 2013
 *      Author: ballance
 */

#include "svf_cmdline.h"
#include "svf_string.h"
#include <string.h>

svf_cmdline::svf_cmdline() {
	svf_ptr_vector<svf_string> argv = args();

	for (uint32_t i=0; i<argv.size(); i++) {
		m_args.push_back(argv.at(i));
	}
}

svf_cmdline::~svf_cmdline() {
	// TODO Auto-generated destructor stub
}

bool svf_cmdline::valueplusarg(const char *pattern, svf_string &value)
{
	bool ret = false;

	for (uint32_t i=0; i<m_args.size(); i++) {
		const svf_string *arg = m_args.at(i);

		if (arg->at(0) == '+') {
			if (!strncmp(&arg->c_str()[1], pattern, strlen(pattern))) {
				value = &arg->c_str()[1+strlen(pattern)];
				ret = true;
			}
		}
	}

	return ret;
}

svf_cmdline &svf_cmdline::get_default()
{
	if (!m_default) {
		m_default = new svf_cmdline();
	}

	return *m_default;
}

svf_cmdline *svf_cmdline::m_default = 0;

