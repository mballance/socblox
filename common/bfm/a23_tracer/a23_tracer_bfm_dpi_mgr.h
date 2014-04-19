/*
 * a23_tracer_dpi_mgr.h
 *
 *  Created on: Dec 13, 2013
 *      Author: ballance
 */

#ifndef A23_TRACER_DPI_MGR_H_
#define A23_TRACER_DPI_MGR_H_
#include "svf.h"
#include "svf_dpi.h"
#include "a23_tracer_if.h"
#include "a23_tracer_bfm_if.h"
#include <map>
#include <string>

using namespace std;

class a23_tracer_dpi_mgr;

class a23_tracer_bfm_dpi_closure : public svf_dpi_closure<a23_tracer_bfm_host_if, a23_tracer_bfm_target_if> {

	public:

		a23_tracer_bfm_dpi_closure(const string &target);

		virtual ~a23_tracer_bfm_dpi_closure() {}
};

class a23_tracer_bfm_dpi_mgr : public svf_dpi_mgr<a23_tracer_bfm_dpi_closure> {

	public:

		a23_tracer_bfm_dpi_mgr();
};



#endif /* A23_TRACER_DPI_MGR_H_ */
