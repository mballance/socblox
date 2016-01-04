/*
 * wb_vga_lcd_test_base.h
 *
 *  Created on: Jan 11, 2014
 *      Author: ballance
 */

#ifndef wb_vga_lcd_TEST_BASE_H_
#define wb_vga_lcd_TEST_BASE_H_
#include "svf.h"
#include "wb_vga_lcd_env.h"

class wb_vga_lcd_test_base : public svf_test {
	svf_test_ctor_decl(wb_vga_lcd_test_base)

	public:
		static const uint32_t CTRL = 0x00000000;
		static const uint32_t STAT = 0x00000004;
		static const uint32_t HTIM = 0x00000008;
		static const uint32_t VTIM = 0x0000000C;
		static const uint32_t HVLEN = 0x00000010;
		static const uint32_t VBARA = 0x00000014;
		static const uint32_t VBARB = 0x00000018;

	public:
		wb_vga_lcd_test_base(const char *name);

		virtual ~wb_vga_lcd_test_base();

		virtual void build();

		virtual void connect();

		virtual void start();

		virtual void run();

		virtual void shutdown();

	protected:

		wb_vga_lcd_env				*m_env;
		svf_thread						m_runthread;
};

#endif /* wb_vga_lcd_TEST_BASE_H_ */
