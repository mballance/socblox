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
	uint8_t *buf = (uint8_t *)malloc(1024);
	uint32_t err = 0;
	uint32_t len = 256;

	for (uint32_t src_i=0; src_i<4; src_i++) {
		for (uint32_t i=0; i<len; i++) {
			buf[i+src_i] = i;
		}
		for (uint32_t dst_i=0; dst_i<4; dst_i++) {
//			memmove(&buf[src_i], &buf[512+dst_i], len);
			memmove(&buf[512+dst_i], &buf[src_i], len);

			for (uint32_t i=0; i<len; i++) {
				if (buf[i+src_i] != i) {
					fprintf(stdout, "Error: src_i=%d dst_i=%d bad src data %d\n", src_i, dst_i, i);
					fflush(stdout);
					err++;
				}
				if (buf[512+dst_i+i] != i) {
					fprintf(stdout, "Error: src_i=%d dst_i=%d bad dst data %d\n", src_i, dst_i, i);
					fflush(stdout);
					err++;
				}
				if (buf[i+src_i] != buf[512+dst_i+i]) {
					fprintf(stdout, "Error: src_i=%d dst_i=%d i=%d\n", src_i, dst_i, i);
					fflush(stdout);
					err++;
				}
			}
		}
	}

	fprintf(stdout, "Done: err=%d\n", err);
	fflush(stdout);

	while (1) {}
}


