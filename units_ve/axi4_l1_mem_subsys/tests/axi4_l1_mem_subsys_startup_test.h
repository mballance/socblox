/*
 * axi4_l1_mem_subsys_startup_test.h
 *
 *  Created on: Jun 19, 2014
 *      Author: ballance
 */

#ifndef INCLUDED_axi4_l1_mem_subsys_startup_test_H
#define INCLUDED_axi4_l1_mem_subsys_startup_test_H
#include "svf.h"
#include "axi4_l1_mem_subsys_test_base.h"

class axi4_l1_mem_subsys_startup_test : public axi4_l1_mem_subsys_test_base {
	svf_test_ctor_decl(axi4_l1_mem_subsys_startup_test)

	public:

		axi4_l1_mem_subsys_startup_test(const char *name);

		virtual ~axi4_l1_mem_subsys_startup_test();

		virtual void build();

		virtual void connect();

		virtual void start();

		void m0_thread();

	private:

		svf_thread					m_m0_thread;

};

#endif /* SVF_TEST_H_ */
