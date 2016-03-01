/*
 * wb_vga_lcd_sys_test_base.cpp
 *
 *  Created on: Jan 11, 2014
 *      Author: ballance
 */

#include "wb_vga_lcd_sys_test_base.h"
#include "svf_elf_loader.h"

wb_vga_lcd_sys_test_base::wb_vga_lcd_sys_test_base(const char *name) : svf_test(name) {
	// TODO Auto-generated constructor stub

}

wb_vga_lcd_sys_test_base::~wb_vga_lcd_sys_test_base() {
	// TODO Auto-generated destructor stub
}

void wb_vga_lcd_sys_test_base::build()
{
	m_env = wb_vga_lcd_sys_env::type_id.create("m_env", this);
}

void wb_vga_lcd_sys_test_base::connect()
{
	const char *TB_ROOT_c;

	if (!get_config_string("TB_ROOT", &TB_ROOT_c)) {
		fprintf(stdout, "FATAL");
	}

	string TB_ROOT(TB_ROOT_c);

	// TODO: connect BFMs
}

void wb_vga_lcd_sys_test_base::start()
{
	m_runthread.init(this, &wb_vga_lcd_sys_test_base::run);
	m_runthread.start();
}

void wb_vga_lcd_sys_test_base::run()
{
	svf_string target_exe;
	svf_string testname = "unknown";
	fprintf(stdout, "run thread\n");
	raise_objection();

	cmdline().valueplusarg("TESTNAME=", testname);
}

void wb_vga_lcd_sys_test_base::shutdown()
{

}

svf_test_ctor_def(wb_vga_lcd_sys_test_base)

