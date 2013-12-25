/*
 * svm_runtest.cpp
 *
 *  Created on: Dec 25, 2013
 *      Author: ballance
 */
#include "svm_runtest.h"
#include "svm_factory.h"
#include "svm_cmdline.h"
#include "svm_test.h"
#include <stdio.h>

void svm_runtest(const char *testname)
{
	svm_factory *f = svm_factory::get_default();
	string testname_opt;

	if (!testname) {
		// Look up default
		svm_cmdline &cl = svm_cmdline::get_default();
		if (!cl.valueplusarg("SVM_TESTNAME=", testname_opt)) {
			// Fatal
			fprintf(stdout, "Failed to find SVM_TESTNAME option on command line\n");
			return;
		}
		testname = testname_opt.c_str();
	}

	svm_test *test = f->create_test(testname, "root");

	if (!test) {
		// Fatal
		fprintf(stdout, "Failed to create test %s\n", testname);
		return;
	}

	test->elaborate();
	test->run();
}



