/*
 * wb_vga_lcd_env.cpp
 *
 *  Created on: Jan 11, 2014
 *      Author: ballance
 */

#include "wb_vga_lcd_env.h"

wb_vga_lcd_env::wb_vga_lcd_env(const char *name, svf_component *parent) : svf_component(name, parent) {


}

wb_vga_lcd_env::~wb_vga_lcd_env() {
	// TODO Auto-generated destructor stub
}

void wb_vga_lcd_env::build() {
	// TODO: instantiate BFMs
	bfm0 = wb_master_bfm::type_id.create("bfm0", this);
}

void wb_vga_lcd_env::connect() {
	// TODO: connect BFMs
}

svf_component_ctor_def(wb_vga_lcd_env)
