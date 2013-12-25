/*
 * svm_cmdline_sc.cpp
 *
 *  Created on: Dec 25, 2013
 *      Author: ballance
 */

#include "svm_cmdline.h"
#include "systemc.h"

int svm_cmdline::argc()
{
	return sc_argc();
}

const char * const*svm_cmdline::argv()
{
	return sc_argv();
}



