/*
 * wb_interconnect_1x2_smoketest.h
 *
 *  Created on: Jun 19, 2014
 *      Author: ballance
 */

#ifndef INCLUDED_wb_interconnect_1x2_smoketest_H
#define INCLUDED_wb_interconnect_1x2_smoketest_H
#include "svf.h"
#include "wb_interconnect_1x2_test_base.h"

class wb_interconnect_1x2_smoketest : public wb_interconnect_1x2_test_base {
	svf_test_ctor_decl(wb_interconnect_1x2_smoketest)

	public:

		wb_interconnect_1x2_smoketest(const char *name);

		virtual ~wb_interconnect_1x2_smoketest();

		virtual void build();

		virtual void connect();

		virtual void start();

		void run();

	private:

		svf_thread							m_run;

};

#endif /* SVF_TEST_H_ */
