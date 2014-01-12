/*
 * wb_2x2_multimaster.h
 *
 *  Created on: Jan 11, 2014
 *      Author: ballance
 */

#ifndef WB_2X2_MULTIMASTER_H_
#define WB_2X2_MULTIMASTER_H_
#include "wb_2x2_test_base.h"

class wb_2x2_multimaster : public wb_2x2_test_base {
	svf_test_ctor_decl(wb_2x2_multimaster)

	public:
		wb_2x2_multimaster(const char *name);

		virtual ~wb_2x2_multimaster();

		virtual void start();

		void run_m0();

		void run_m1();

	private:
		string					m0_message;
		string					m1_message;
		svf_thread				m0_thread;
		svf_thread				m1_thread;
};

#endif /* WB_2X2_MULTIMASTER_H_ */
