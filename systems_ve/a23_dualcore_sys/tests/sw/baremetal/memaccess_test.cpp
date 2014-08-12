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
	uint8_t *buf_8 = (uint8_t *)buf;
	uint16_t *buf_16 = (uint16_t *)buf;
	uint32_t *buf_32 = (uint32_t *)buf;
	/*
	uint64_t *buf_64 = (uint64_t *)buf;
	 */
	uint32_t err = 0;

	// First, test that we can read and write bytes
	for (uint32_t i=0; i<256; i++) {
		buf_8[i] = i;
	}
	for (uint32_t i=0; i<256; i++) {
		if (buf_8[i] != i) {
			fprintf(stdout, "Error: buf_8[%d] expect %d ; receive %d\n", i, i, (int)buf_8[i]);
			fflush(stdout);
			err++;
		}
	}

	// Next, test 16-bit access
	for (uint32_t i=0; i<256/2; i++) {
		buf_16[i] = i;
	}
	for (uint32_t i=0; i<256/2; i++) {
		if (buf_16[i] != i) {
			fprintf(stdout, "Error: buf_16[%d] expect %d ; receive %d\n", i, i, (int)buf_16[i]);
			fflush(stdout);
			err++;
		}
	}

	// Next, test 32-bit access
	for (uint32_t i=0; i<256/4; i++) {
		buf_32[i] = i;
	}
	for (uint32_t i=0; i<256/4; i++) {
		if (buf_32[i] != i) {
			fprintf(stdout, "Error: buf_32[%d] expect %d ; receive %d\n", i, i, (int)buf_32[i]);
			fflush(stdout);
			err++;
		}
	}

	// Test write as 8-bit, read as 32-bit
	for (uint32_t i=0; i<256; i++) {
		buf_8[i] = i;
	}

	for (uint32_t i=0; i<256; i+=4) {
		uint32_t idx = (i >> 2);
		uint32_t exp = (
				(i+3 << 24) |
				(i+2 << 16) |
				(i+1 << 8) |
				(i+0 << 0)
				);
		if (buf_32[idx] != exp) {
			fprintf(stdout, "Error: buf_32[%d] expect %d ; receive %d\n", idx, exp, (int)buf_32[idx]);
			fflush(stdout);
			err++;
		}
	}

	// Test write as 32-bit, read as 8-bit
	for (uint32_t i=0; i<256; i+=4) {
		uint32_t idx = (i >> 2);
		uint32_t exp = (
				(i+3 << 24) |
				(i+2 << 16) |
				(i+1 << 8) |
				(i+0 << 0)
				);
		buf_32[idx] = exp;
	}

	for (uint32_t i=0; i<256; i++) {
		uint32_t exp = i;
		if (buf_8[i] != exp) {
			fprintf(stdout, "Error: buf_8[%d] expect %d ; receive %d\n", i, exp, (int)buf_8[i]);
			fflush(stdout);
			err++;
		}
	}

	fprintf(stdout, "Done: err=%d\n", err);
	fflush(stdout);

	while (1) {}
}


