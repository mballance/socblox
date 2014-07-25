/*
 * svf_runtest.cpp
 *
 *  Created on: Dec 25, 2013
 *      Author: ballance
 */
#include "svf_runtest.h"
#include "svf_factory.h"
#include "svf_cmdline.h"
#include "svf_test.h"
#include <stdio.h>

void svf_runtest(const char *testname)
{
	svf_factory *f = svf_factory::get_default();
	svf_string testname_opt;

	if (!testname || !testname[0]) {
		// Look up default
		svf_cmdline &cl = svf_cmdline::get_default();
		if (!cl.valueplusarg("SVF_TESTNAME=", testname_opt)) {
			// Fatal
			fprintf(stdout, "Failed to find SVF_TESTNAME option on command line\n");
			return;
		}
		testname = testname_opt.c_str();
	}

	svf_test *test = f->create_test(testname, "root");

	if (!test) {
		// Fatal
		fprintf(stdout, "Failed to create test %s\n", testname);
		return;
	}

	test->elaborate();
	test->run();
}



