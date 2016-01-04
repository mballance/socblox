/*
 * svf_test.cpp
 *
 *  Created on: Dec 8, 2013
 *      Author: ballance
 */

#include "svf_test.h"
#include <stdio.h>

svf_test::svf_test(const char *name) : svf_root(name) {
	// TODO Auto-generated constructor stub

}

svf_test::~svf_test() {
	// TODO Auto-generated destructor stub
}

void svf_test::pass() {
	fprintf(stdout, "PASS: %s\n", get_typename());
}

void svf_test::fail(const char *msg) {
	fprintf(stdout, "FAIL: %s %s\n", get_typename(), msg);
}

