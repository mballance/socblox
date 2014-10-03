/*
 * axi4_a23_cache_test_base.h
 *
 *  Created on: Jan 11, 2014
 *      Author: ballance
 */

#ifndef axi4_a23_cache_TEST_BASE_H_
#define axi4_a23_cache_TEST_BASE_H_
#include "svf.h"
#include "axi4_a23_cache_env.h"

class axi4_a23_cache_test_base : public svf_test {
	svf_test_ctor_decl(axi4_a23_cache_test_base)

	public:
		axi4_a23_cache_test_base(const char *name);

		virtual ~axi4_a23_cache_test_base();

		virtual void build();

		virtual void connect();

		virtual void start();

		virtual void run();

		virtual void shutdown();

	protected:

		axi4_a23_cache_env				*m_env;
		svf_thread						m_runthread;
};

#endif /* axi4_a23_cache_TEST_BASE_H_ */
