/*
 * wb_vga_lcd_sys_env.h
 *
 *  Created on: Jan 11, 2014
 *      Author: ballance
 */

#ifndef wb_vga_lcd_sys_ENV_H_
#define wb_vga_lcd_sys_ENV_H_
#include "svf.h"
// TODO: Include BFM header files

class wb_vga_lcd_sys_env : public svf_component {
	svf_component_ctor_decl(wb_vga_lcd_sys_env)

	public:
		wb_vga_lcd_sys_env(const char *name, svf_component *parent);

		virtual ~wb_vga_lcd_sys_env();

		virtual void build();

		virtual void connect();

	public:

};

#endif /* wb_vga_lcd_sys_ENV_H_ */
