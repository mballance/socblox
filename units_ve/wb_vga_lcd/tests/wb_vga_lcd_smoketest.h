/*
 * wb_vga_lcd_smoketest.h
 *
 *  Created on: Jun 19, 2014
 *      Author: ballance
 */

#ifndef INCLUDED_wb_vga_lcd_smoketest_H
#define INCLUDED_wb_vga_lcd_smoketest_H
#include "svf.h"
#include "wb_vga_lcd_test_base.h"

class wb_vga_lcd_smoketest : public wb_vga_lcd_test_base {
	svf_test_ctor_decl(wb_vga_lcd_smoketest)

	public:

		wb_vga_lcd_smoketest(const char *name);

		virtual ~wb_vga_lcd_smoketest();

		virtual void build();

		virtual void connect();

		virtual void start();

	private:

		virtual void run();

		svf_thread				m_run_thread;

};

#endif /* SVF_TEST_H_ */
