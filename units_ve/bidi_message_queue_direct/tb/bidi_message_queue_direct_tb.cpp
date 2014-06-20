/*
 * bidi_message_queue_direct_tb.cpp
 *
 *  Created on: Jan 10, 2014
 *      Author: ballance
 */

#include <stdio.h>
#include "svf.h"
#include "svf_sc_tb.h"
#include "Vbidi_message_queue_direct_tb.h"

int sc_main(int argc, char **argv)
{
	return svf_sc_tb<Vbidi_message_queue_direct_tb>::sc_main(argc, argv);
}
