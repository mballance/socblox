/*
 * svf_basics.cpp
 *
 *  Created on: Jan 31, 2015
 *      Author: ballance
 */

#include "uth.h"
#include "uth_coop_thread_mgr.h"
#include "svf_basics_test.h"
#include <stdio.h>
#include "svf_cmdline.h"
#include "bidi_message_queue_drv_uth.h"
#include <stdlib.h>

void *__dso_handle = (void *)0;

extern "C" void irq_handler() { }

#define debug(...) fprintf(stdout, __VA_ARGS__); fflush(stdout);

svf_ptr_vector<svf_string> svf_cmdline::args()
{
	svf_ptr_vector<svf_string> args;

	return args;
}

static uth_coop_thread_mgr *thread_mgr[2] = {0, 0};
extern "C" uth_thread_mgr *uth_get_thread_mgr()
{
	uint32_t core = *((volatile uint32_t *)0xF1000004);
	if (!thread_mgr[core]) {
		thread_mgr[core] = new uth_coop_thread_mgr();
		thread_mgr[core]->init();
	}
	return thread_mgr[core];
}

extern "C" void low_level_init()
{
	// Enable cache for code/data
	// 31:27
	// Page 0 - 0x00000000-0x07FFFFFFF
	// Page 4 - 0x20000000-0x27FFFFFFF
	asm(
//			"mov	r0, #0x00000011\n"
			"mov	r0, #0x00000000\n"
			"mcr	15, 0, r0, cr3, cr0, 0\n"
			"mov	r0, #1\n"
//			"mov	r0, #0\n"
			"mcr	15, 0, r0, cr2, cr0, 0\n"); // Enable cache

}

int main(int argc, char **argv) {
	printf("Hello World!\n");

	bidi_message_queue_drv_uth *msg_queue_drv =
			new bidi_message_queue_drv_uth((uint32_t *)0xF1001000, 8);
	uint32_t *msg = (uint32_t *)malloc(sizeof(uint32_t)*4096);

	uint32_t sz = msg_queue_drv->get_next_message_sz();
	printf("Message size: %d\n", sz);

	svf_runtest("svf_basics_test");

	printf("Done with test\n");

	while (true) { ; }
}



