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

// void *__dso_handle = (void *)0;

// extern "C" void irq_handler() { }

#define debug(...) fprintf(stdout, __VA_ARGS__); fflush(stdout);

svf_ptr_vector<svf_string>		prv_args;
svf_ptr_vector<svf_string> svf_cmdline::args() {
	return prv_args;
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

int main(int argc, char **argv) {
	for (uint32_t i=0; i<argc; i++) {
		prv_args.push_back(new svf_string(argv[i]));
	}

//	bidi_message_queue_drv_uth *msg_queue_drv =
//			new bidi_message_queue_drv_uth((uint32_t *)0xF1001000, 8);
//	uint32_t *msg = (uint32_t *)malloc(sizeof(uint32_t)*4096);
//
//	uint32_t sz = msg_queue_drv->get_next_message_sz();
//	printf("Message size: %d\n", sz);


//	svf_runtest("svf_basics_test");
	svf_runtest();

	printf("Done with test\n");

	while (true) { ; }
}



