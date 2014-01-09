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
#ifndef __USE_GNU
#define __USE_GNU
#endif
#include <dlfcn.h>
#endif

using namespace std;

typedef uint32_t (*acc_fetch_argc_f)();
typedef char **(*acc_fetch_argv_f)();

vector<string> svf_cmdline::args()
{
	acc_fetch_argc_f acc_fetch_argc_p = 0;
	acc_fetch_argv_f acc_fetch_argv_p = 0;
	svf_argfile_parser parser;

#ifndef _WIN32
	acc_fetch_argc_p = (acc_fetch_argc_f)dlsym(RTLD_DEFAULT, "acc_fetch_argc");
	acc_fetch_argv_p = (acc_fetch_argv_f)dlsym(RTLD_DEFAULT, "acc_fetch_argv");
#endif

	if (acc_fetch_argc_p && acc_fetch_argv_p) {
		uint32_t argc = acc_fetch_argc_p();
		char **argv = acc_fetch_argv_p();
		parser.process(argc, argv);
	}


	return parser.cmdline();
}



