/*
 * svf_cmdline_sc.cpp
 *
 *  Created on: Dec 25, 2013
 *      Author: ballance
 */

#include "svf_cmdline.h"
#include "systemc.h"
#include "svf_argfile_parser.h"
#include <string>
#include <vector>
#ifndef _WIN32
#include <dlfcn.h>
#endif

using namespace std;

svf_ptr_vector<svf_string> svf_cmdline::args()
{
	int argc = sc_argc();
	const char *const *argv = sc_argv();

	svf_argfile_parser parser;

	parser.process(argc, argv);

	svf_ptr_vector<svf_string> ret;

	vector<string> tmp = parser.cmdline();

	for (uint32_t i=0; i<tmp.size(); i++) {
		ret.push_back(new svf_string(tmp.at(i).c_str()));
	}

	return ret;
}



