/*
 * memmove_test.cpp
 *
 *  Created on: Jul 25, 2014
 *      Author: ballance
 */

#include "uth.h"
#include "uth_coop_thread_mgr.h"
#include <string.h>
#include <stdlib.h>
#include <stdio.h>


/*
 */
void *__dso_handle = (void *)NULL;

extern "C" void irq_handler() { }

static uth_coop_thread_mgr *thread_mgr = 0;
extern "C" uth_thread_mgr *uth_get_thread_mgr()
{
	if (!thread_mgr) {
		thread_mgr = new uth_coop_thread_mgr();
		thread_mgr->init();
	}
	return thread_mgr;
}

int main(int argc, char **argv) {
	uint32_t err = 0;
	volatile unsigned int val = 15;
	char *buf = (char *)malloc(1024);

	sprintf(buf, "i: %d\n", 23);

	if (buf[4] != '3') {
		fprintf(stdout, "buf[4] = %c\n", buf[4]);
		fflush(stdout);
		err++;
	}

	fprintf(stdout, "Done: err=%d\n", err);
	fflush(stdout);

	while (1) {}
}


