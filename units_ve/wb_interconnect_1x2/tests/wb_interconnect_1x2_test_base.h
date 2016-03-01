/*
 * wb_interconnect_1x2_test_base.h
 *
 *  Created on: Jan 11, 2014
 *      Author: ballance
 */

#ifndef wb_interconnect_1x2_TEST_BASE_H_
#define wb_interconnect_1x2_TEST_BASE_H_
#include "svf.h"
#include "wb_interconnect_1x2_env.h"

class wb_interconnect_1x2_test_base : public svf_test {
	svf_test_ctor_decl(wb_interconnect_1x2_test_base)

	public:
		wb_interconnect_1x2_test_base(const char *name);

		virtual ~wb_interconnect_1x2_test_base();

		virtual void build();

		virtual void connect();

		virtual void start();

		virtual void run();

		virtual void shutdown();

	protected:

		wb_interconnect_1x2_env				*m_env;
		svf_thread						m_runthread;
};

#endif /* wb_interconnect_1x2_TEST_BASE_H_ */
