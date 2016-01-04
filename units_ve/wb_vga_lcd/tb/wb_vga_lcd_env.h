/*
 * wb_vga_lcd_env.h
 *
 *  Created on: Jan 11, 2014
 *      Author: ballance
 */

#ifndef wb_vga_lcd_ENV_H_
#define wb_vga_lcd_ENV_H_
#include "svf.h"
// TODO: Include BFM header files
#include "wb_master_bfm.h"

class wb_vga_lcd_env : public svf_component {
	svf_component_ctor_decl(wb_vga_lcd_env)

	public:
		wb_vga_lcd_env(const char *name, svf_component *parent);

		virtual ~wb_vga_lcd_env();

		virtual void build();

		virtual void connect();

	public:

		wb_master_bfm					*bfm0;

};

#endif /* wb_vga_lcd_ENV_H_ */
