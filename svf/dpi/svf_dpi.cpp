/*
 * svf_dpi.cpp
 *
 *  Created on: Jan 7, 2014
 *      Author: ballance
 */
#include "svf_runtest.h"

extern "C" int svf_dpi_run_test(const char *name);

int svf_dpi_run_test(const char *name)
{
	if (name == 0 || *name == 0) {
		name == 0;
	}

	svf_runtest(name);

	return 0;
}


