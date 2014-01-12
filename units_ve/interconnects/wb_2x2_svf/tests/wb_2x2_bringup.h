/*
 * wb_2x2_bringup.h
 *
 *  Created on: Jan 11, 2014
 *      Author: ballance
 */

#ifndef WB_2X2_BRINGUP_H_
#define WB_2X2_BRINGUP_H_
#include "wb_2x2_test_base.h"

class wb_2x2_bringup : public wb_2x2_test_base {
	svf_test_ctor_decl(wb_2x2_bringup)

	public:
		wb_2x2_bringup(const char *name);

		virtual ~wb_2x2_bringup();

		virtual void start();

		void run();

	private:
		svf_thread				m_run_thread;
};

#endif /* WB_2X2_BRINGUP_H_ */
