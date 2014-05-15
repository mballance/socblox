/*
 * uex_core.c
 *
 *  Created on: May 5, 2014
 *      Author: ballance
 */

#include "uex.h"
#include "uex_hal_api.h"

void uex_main(void)
{
	uint32_t coreid = uex_hal_get_coreid();
	uex_hal_percore_init();

	if (coreid == 0) {
		uex_hal_global_init();
	}

	if (coreid == 0) {

	} else {

	}
}



