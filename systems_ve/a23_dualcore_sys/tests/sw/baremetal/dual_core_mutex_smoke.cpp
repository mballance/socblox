
#include "bidi_message_queue_drv_uth.h"
#include "uth.h"
#include "uth_coop_thread_mgr.h"
#include <string.h>
#include <stdlib.h>
#include <stdio.h>

extern "C" void irq_handler() { }

#define debug(...) fprintf(stdout, __VA_ARGS__); fflush(stdout);

extern "C" uth_thread_mgr *uth_get_thread_mgr()
{
	return 0;
}

int main(int argc, char **argv) {

	// Release core 1
	*((volatile uint32_t *)0xF100000C) = 1;


	while (1) {
		;
	}
	/*
	 */
}
