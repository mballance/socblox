/*
 * axi4_l1_interconnect_2_startup.h
 *
 *  Created on: Jun 19, 2014
 *      Author: ballance
 */

#ifndef INCLUDED_axi4_l1_interconnect_2_startup_H
#define INCLUDED_axi4_l1_interconnect_2_startup_H
#include "svf.h"
#include "axi4_l1_interconnect_2_test_base.h"

class axi4_l1_interconnect_2_startup : public axi4_l1_interconnect_2_test_base {
	svf_test_ctor_decl(axi4_l1_interconnect_2_startup)

	public:

		axi4_l1_interconnect_2_startup(const char *name);

		virtual ~axi4_l1_interconnect_2_startup();

		virtual void build();

		virtual void connect();

		virtual void start();

		void main();

	private:
		svf_thread					m_thread;

};

#endif /* SVF_TEST_H_ */
