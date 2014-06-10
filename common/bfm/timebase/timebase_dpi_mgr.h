/*
 * timebase_dpi_mgr.h
 *
 *  Created on: Dec 13, 2013
 *      Author: ballance
 */

#ifndef INCLUDED_timebase_DPI_MGR_H
#define INCLUDED_timebase_DPI_MGR_H
#include "svf.h"
#include "svf_dpi.h"
#include "timebase_if.h"
#include <map>
#include <string>

using namespace std;

class timebase_dpi_mgr;

class timebase_dpi_closure : public svf_dpi_closure<timebase_host_if, timebase_target_if> {

	public:

		timebase_dpi_closure(const string &target);

		virtual ~timebase_dpi_closure() {}

		// TODO: Virtual methods for target API
		virtual void gettime(uint64_t *);

};

class timebase_dpi_mgr : public svf_dpi_mgr<timebase_dpi_closure> {

	public:

		timebase_dpi_mgr();

};



#endif /* INCLUDED_timebase_DPI_MGR_H */
