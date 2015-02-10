/********************************************************************
 * a23_preloader.cpp
 *
 * Implements the a23 dualcore version of the preloader
 ********************************************************************/
#include "preloader.h"
#include "bidi_message_queue_ptr_drv.h"
#include <stdio.h>
#include <stdlib.h>

extern "C" void low_level_init() {
	// Enable cache for code/data
	// 31:27
	// Page 0 - 0x00000000-0x07FFFFFFF
	// Page 4 - 0x20000000-0x27FFFFFFF
	asm(
			"mov	r0, #0x00000011\n"
//			"mov	r0, #0x00000000\n"
			"mcr	15, 0, r0, cr3, cr0, 0\n"
			"mov	r0, #1\n"
//			"mov	r0, #0\n"
			"mcr	15, 0, r0, cr2, cr0, 0\n"); // Enable cache

}

static bidi_message_queue_ptr_drv *msg_drv_p;

class bidi_message_queue_msg_if : public preloader_msg_if {
	public:

		int32_t recv_next_msg_sz() {
			int32_t sz = msg_drv_p->get_next_message_sz();
			return (4*sz);
		}

		int32_t recv_msg_data(uint8_t *data, uint32_t sz) {
			msg_drv_p->read_next_message((uint32_t *)data);
			return sz;
		}

		int32_t send_msg(uint8_t *data, uint32_t sz) {
			msg_drv_p->write_message(sz/4, (uint32_t *)data);
			return sz;
		}
};

int main(int argc, char **argv) {
	fprintf(stderr, "Hello from main\n");

	bidi_message_queue_ptr_drv msg_drv = bidi_message_queue_ptr_drv((uint32_t *)0xF1001000, 10);
	msg_drv_p = &msg_drv;
	bidi_message_queue_msg_if msg_if;

	preloader prl;

	prl.run(&msg_if);

	return 0;
}
