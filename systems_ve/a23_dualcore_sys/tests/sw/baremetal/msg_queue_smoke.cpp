
#include "bidi_message_queue_drv_uth.h"
#include "uth.h"
#include "uth_coop_thread_mgr.h"
#include <string.h>
#include <stdlib.h>
#include <stdio.h>

extern "C" void irq_handler() { }

#define debug(...) fprintf(stdout, __VA_ARGS__); fflush(stdout);

static uth_coop_thread_mgr *thread_mgr = 0;
extern "C" uth_thread_mgr *uth_get_thread_mgr()
{
	if (!thread_mgr) {
		thread_mgr = new uth_coop_thread_mgr();
		thread_mgr->init();
	}
	return thread_mgr;
}

void outbound_thread(void *ud) {
	uint32_t *msg = (uint32_t *)malloc(sizeof(uint32_t)*4096);
	uint32_t msg_sz = 16;
	bidi_message_queue_drv_base *drv = (bidi_message_queue_drv_base *)ud;

	debug("--> outbound_thread\n");
	for (uint32_t j=0; j<16; j++) {
		for (uint32_t i=0; i<msg_sz; i++) {
			msg[i] = (i+1);
		}

//		debug("--> outbound: write_message %d\n", j);
		drv->write_message(msg_sz, msg);
//		debug("<-- outbound: write_message %d\n", j);
	}

	debug("<-- outbound_thread\n");
}

void inbound_thread(void *ud) {
	uint32_t *msg = (uint32_t *)malloc(sizeof(uint32_t)*4096);
	uint32_t sz;
	bidi_message_queue_drv_base *drv = (bidi_message_queue_drv_base *)ud;

	debug("--> inbound_thread\n");

	for (uint32_t j=0; j<16; j++) {
		debug("--> inbound: get_next_message_sz %d\n", j);
		sz = drv->get_next_message_sz();
		debug("<-- inbound: get_next_message_sz %d %d\n", j, sz);

		debug("--> inbound: read_next_message %d\n", j);
		drv->read_next_message(msg);
		debug("<-- inbound: read_next_message %d\n", j);
	}

	debug("<-- inbound_thread\n");
}

int main(int argc, char **argv) {
	uint32_t msg[16];
	bidi_message_queue_drv_uth *drv = new bidi_message_queue_drv_uth(
			(uint32_t *)0xF1001000, 8);

	uth_thread_t outbound_th, inbound_th;
	uth_thread_create(&outbound_th, &outbound_thread, drv);
	uth_thread_create(&inbound_th, &inbound_thread, drv);

	while (1) {
		uth_thread_yield();
	}
	/*
	 */
}
