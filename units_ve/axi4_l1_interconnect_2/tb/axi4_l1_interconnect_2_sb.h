/*
 * axi4_l1_interconnect_2_sb.h
 *
 *  Created on: Jun 19, 2014
 *      Author: ballance
 */

#ifndef INCLUDED_axi4_l1_interconnect_2_sb_H
#define INCLUDED_axi4_l1_interconnect_2_sb_H
#include "svf.h"
#include "svf_component.h"
#include "axi4_monitor_bfm.h"

class axi4_l1_interconnect_2_sb : public svf_component {
	svf_component_ctor_decl(axi4_l1_interconnect_2_sb)



	public:

		axi4_l1_interconnect_2_sb(const char *name, svf_component *parent);

		virtual ~axi4_l1_interconnect_2_sb();

		virtual void build();

		virtual void connect();

		virtual void start();

	private:

};

#endif /* INCLUDED_axi4_l1_interconnect_2_sb_H */
