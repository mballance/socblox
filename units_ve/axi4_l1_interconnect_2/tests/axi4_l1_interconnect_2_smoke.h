/*
 * axi4_l1_interconnect_2_smoke.h
 *
 *  Created on: Jun 19, 2014
 *      Author: ballance
 */

#ifndef INCLUDED_axi4_l1_interconnect_2_smoke_H
#define INCLUDED_axi4_l1_interconnect_2_smoke_H
#include "svf.h"
#include "axi4_l1_interconnect_2_test_base.h"

class axi4_l1_interconnect_2_smoke : public axi4_l1_interconnect_2_test_base {
	svf_test_ctor_decl(axi4_l1_interconnect_2_smoke)

	public:

		axi4_l1_interconnect_2_smoke(const char *name);

		virtual ~axi4_l1_interconnect_2_smoke();

		virtual void build();

		virtual void connect();

		virtual void start();

		void main_m0();

		void main_m1();

		virtual void shutdown();

	private:

		svf_thread					m_main_m0;
		svf_thread					m_main_m1;

};

#endif /* SVF_TEST_H_ */
