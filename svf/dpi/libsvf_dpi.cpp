/*
 * libsvf_dpi.cpp
 *
 *  Created on: Jan 7, 2014
 *      Author: ballance
 */

#include "svf_dpi_int.h"

extern "C" void svf_dpi_create_thread(void *ud, void **out_p);

static svf_dpi_api_t prv_svf_dpi_api = {
		&svf_dpi_create_thread, // create_thread
};

extern "C" int unsigned svf_dpi_init();
int unsigned svf_dpi_init()
{
	set_svf_dpi_api(&prv_svf_dpi_api);

	return 1;
}


