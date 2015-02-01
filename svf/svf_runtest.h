/*
 * svf_runtest.h
 *
 *  Created on: Dec 25, 2013
 *      Author: ballance
 */

#ifndef SVF_RUNTEST_H_
#define SVF_RUNTEST_H_
class svf_test;

void svf_runtest(const char *testname=0);

void svf_runtest(svf_test *test);



#endif /* SVF_RUNTEST_H_ */
