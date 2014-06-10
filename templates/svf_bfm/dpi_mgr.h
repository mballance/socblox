/*
 * ${name}_dpi_mgr.h
 *
 *  Created on: Dec 13, 2013
 *      Author: ballance
 */

#ifndef INCLUDED_${name}_DPI_MGR_H
#define INCLUDED_${name}_DPI_MGR_H
#include "svf.h"
#include "svf_dpi.h"
#include "${name}_if.h"
#include <map>
#include <string>

using namespace std;

class ${name}_dpi_mgr;

class ${name}_dpi_closure : public svf_dpi_closure<${name}_host_if, ${name}_target_if> {

	public:

		${name}_dpi_closure(const string &target);

		virtual ~${name}_dpi_closure() {}

		// TODO: Virtual methods for target API

};

class ${name}_dpi_mgr : public svf_dpi_mgr<${name}_dpi_closure> {

	public:

		${name}_dpi_mgr();

};



#endif /* INCLUDED_${name}_DPI_MGR_H */
