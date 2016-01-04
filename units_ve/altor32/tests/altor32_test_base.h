/*
 * altor32_test_base.h
 *
 *  Created on: Jan 11, 2014
 *      Author: ballance
 */

#ifndef altor32_TEST_BASE_H_
#define altor32_TEST_BASE_H_
#include "svf.h"
#include "altor32_env.h"

class altor32_test_base : public svf_test {
	svf_test_ctor_decl(altor32_test_base)

	public:
		altor32_test_base(const char *name);

		virtual ~altor32_test_base();

		virtual void build();

		virtual void connect();

		virtual void start();

		virtual void run();

		virtual void shutdown();

	protected:

		altor32_env				*m_env;
		svf_thread						m_runthread;
};

#endif /* altor32_TEST_BASE_H_ */
