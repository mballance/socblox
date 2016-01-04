/*
 * wb_vga_lcd_smoketest.cpp
 *
 *  Created on: Jun 19, 2014
 *      Author: ballance
 */

#include "wb_vga_lcd_smoketest.h"

wb_vga_lcd_smoketest::wb_vga_lcd_smoketest(const char *name) : wb_vga_lcd_test_base(name) {
	// TODO Auto-generated constructor stub

}

wb_vga_lcd_smoketest::~wb_vga_lcd_smoketest() {
	// TODO Auto-generated destructor stub
}

void wb_vga_lcd_smoketest::build() {
	wb_vga_lcd_test_base::build();
}

void wb_vga_lcd_smoketest::connect() {
	wb_vga_lcd_test_base::connect();
}

void wb_vga_lcd_smoketest::start() {
	m_run_thread.init(this, &wb_vga_lcd_smoketest::run);
	m_run_thread.start();
}

void wb_vga_lcd_smoketest::run() {
	int thsync, thgdel, thgate, thlen;
	int tvsync, tvgdel, tvgate, tvlen;
	raise_objection();

	thsync = 6;
	thgdel = 20;
	thgate = 319;
	thlen = 390;

	tvsync = 1;
	tvgdel = 8;
	tvgate = 239;
	tvlen = 280;

	m_env->bfm0->write32(VBARA, 0x00000000);
	m_env->bfm0->write32(VBARB, 0x123456);
	m_env->bfm0->write32(HTIM,
			(thsync << 24) +
			(thgdel << 16) +
			(thgate));
	m_env->bfm0->write32(VTIM,
			(tvsync << 24) +
			(tvgdel << 16) +
			(tvgate));
	m_env->bfm0->write32(HVLEN,
			(thlen << 16) +
			(tvlen));

	// Turn VGA off
	m_env->bfm0->write32(CTRL,
			(0 << 15) + // bpol
			(0 << 14) + // cpol
			(0 << 13) + // vpol
			(0 << 12) + // hpol
			(0 << 11) + // PC
			(2 << 9) + // CD
			(1 << 7) + // VBL
			(0 << 6) + // CBSWE
			(0 << 5) + // VBSWE
			(0 << 4) + // CBSIE
			(0 << 3) + // VBSIE
			(0 << 2) + // HIE
			(0 << 1) + // VIE
			(1) // Video Enable
			);



//	drop_objection();
}

svf_test_ctor_def(wb_vga_lcd_smoketest)

