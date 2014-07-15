
#include "bidi_message_queue_drv_uth.h"
#include "uth.h"
#include "uth_coop_thread_mgr.h"
#include <string.h>
#include <stdlib.h>

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

void outbound_thread(void *ud) {
	uint32_t msg[16];
	bidi_message_queue_drv_base *drv = (bidi_message_queue_drv_base *)ud;

	for (uint32_t j=0; j<16; j++) {
		for (uint32_t i=0; i<16; i++) {
			msg[i] = (i+1);
		}

		drv->write_message(16, msg);
	}
}

void inbound_thread(void *ud) {
	uint32_t msg[16];
	uint32_t sz;
	bidi_message_queue_drv_base *drv = (bidi_message_queue_drv_base *)ud;

	/*
	for (uint32_t j=0; j<16; j++) {
		sz = drv->get_next_message_sz();

		drv->read_next_message(msg);
	}
	 */
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
