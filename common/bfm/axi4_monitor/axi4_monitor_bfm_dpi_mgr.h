/*
 * axi4_monitor_bfm_dpi_mgr.h
 *
 *  Created on: Dec 13, 2013
 *      Author: ballance
 */

#ifndef INCLUDED_axi4_monitor_bfm_DPI_MGR_H
#define INCLUDED_axi4_monitor_bfm_DPI_MGR_H
#include "svf.h"
#include "svf_dpi.h"
#include "axi4_monitor_bfm_if.h"
#include <map>
#include <string>

using namespace std;

class axi4_monitor_bfm_dpi_mgr;

class axi4_monitor_bfm_dpi_closure : public svf_dpi_closure<axi4_monitor_bfm_host_if, axi4_monitor_bfm_target_if> {

	public:

		axi4_monitor_bfm_dpi_closure(const string &target);

		virtual ~axi4_monitor_bfm_dpi_closure() {}

		// TODO: Virtual methods for target API

};

class axi4_monitor_bfm_dpi_mgr : public svf_dpi_mgr<axi4_monitor_bfm_dpi_closure> {

	public:

		axi4_monitor_bfm_dpi_mgr();

};



#endif /* INCLUDED_axi4_monitor_bfm_DPI_MGR_H */
