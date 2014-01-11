/*
 * wb_2x2_test_base.h
 *
 *  Created on: Jan 11, 2014
 *      Author: ballance
 */

#ifndef WB_2X2_TEST_BASE_H_
#define WB_2X2_TEST_BASE_H_
#include "svf.h"

class wb_2x2_test_base : public svf_test {
	svf_test_ctor_decl(wb_2x2_test_base)

	public:
		wb_2x2_test_base(const char *name);

		virtual ~wb_2x2_test_base();
};

#endif /* WB_2X2_TEST_BASE_H_ */
