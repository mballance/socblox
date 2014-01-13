/*
 * axi4_wb_bridge_test_base.h
 *
 *  Created on: Jan 11, 2014
 *      Author: ballance
 */

#ifndef WB_2X2_TEST_BASE_H_
#define WB_2X2_TEST_BASE_H_
#include "svf.h"
#include "axi4_wb_bridge_env.h"

class axi4_wb_bridge_test_base : public svf_test {
	svf_test_ctor_decl(axi4_wb_bridge_test_base)

	public:
		axi4_wb_bridge_test_base(const char *name);

		virtual ~axi4_wb_bridge_test_base();

		virtual void build();

		virtual void connect();

	protected:

		axi4_wb_bridge_env				*m_env;
};

#endif /* WB_2X2_TEST_BASE_H_ */
