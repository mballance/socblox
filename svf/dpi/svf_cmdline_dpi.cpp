/*
 * svf_cmdline_sc.cpp
 *
 *  Created on: Dec 25, 2013
 *      Author: ballance
 */

#include "svf_cmdline.h"
#include "svf_argfile_parser.h"
#include <vector>
#include <string>
#ifndef _WIN32
#include <dlfcn.h>
#endif

using namespace std;

vector<string> svf_cmdline::args()
{
	vector<string> ret;
#ifdef UNDEFINED
	int argc = sc_argc();
	const char *const *argv = sc_argv();

	svf_argfile_parser parser;

	parser.process(argc, argv);


	return parser.cmdline();
#endif
	return ret;
}



