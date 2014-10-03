/*
 * axi4_a23_cache_tb.cpp
 *
 *  Created on: Jan 10, 2014
 *      Author: ballance
 */

#include <stdio.h>
#include "svf.h"
#include "svf_sc_tb.h"
#include "Vaxi4_a23_cache_tb.h"

int sc_main(int argc, char **argv)
{
	return svf_sc_tb<Vaxi4_a23_cache_tb>::sc_main(argc, argv);
}
