/*
 * svm_cmdline_sc.cpp
 *
 *  Created on: Dec 25, 2013
 *      Author: ballance
 */

#include "svm_cmdline.h"
#include "systemc.h"
#include "svm_argfile_parser.h"
#include <vector>
#include <string>

using namespace std;

vector<string> svm_cmdline::args()
{
	int argc = sc_argc();
	const char *const *argv = sc_argv();

	svm_argfile_parser parser;

	parser.process(argc, argv);


	return parser.cmdline();
}



