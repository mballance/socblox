/*
 * axi4_interconnect_tb.h
 *
 *  Created on: Dec 10, 2013
 *      Author: ballance
 */

#ifndef AXI4_INTERCONNECT_TB_H_
#define AXI4_INTERCONNECT_TB_H_

#include "svf_component.h"

class axi4_interconnect_tb: public svf_component {
	svf_component_ctor_decl(axi4_interconnect_tb);

	public:
		axi4_interconnect_tb(const char *name, svf_component *parent);
		virtual ~axi4_interconnect_tb();
};

#endif /* AXI4_INTERCONNECT_TB_H_ */
