/*
 * svf_dpi_int.cpp
 *
 *  Created on: Jan 7, 2014
 *      Author: ballance
 */

#include "svf_dpi_int.h"

svf_dpi_api_t		*svf_dpi_api = 0;

void set_svf_dpi_api(svf_dpi_api_t *api) {
	svf_dpi_api = api;
}

svf_dpi_api_t *get_svf_dpi_api() {
	return svf_dpi_api;
}


