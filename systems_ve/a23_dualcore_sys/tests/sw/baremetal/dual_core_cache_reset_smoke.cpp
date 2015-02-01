
#include "bidi_message_queue_drv_uth.h"
#include "uth.h"
#include "uth_coop_thread_mgr.h"
#include <string.h>
#include <stdlib.h>
#include <stdio.h>

extern "C" void irq_handler() { }

#define debug(...) fprintf(stdout, __VA_ARGS__); fflush(stdout);

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
			"mov	r0, #0x00000011\n"
//			"mov	r0, #0x00000000\n"
			"mcr	15, 0, r0, cr3, cr0, 0\n"
			"mov	r0, #1\n"
//			"mov	r0, #0\n"
			"mcr	15, 0, r0, cr2, cr0, 0\n"); // Enable cache

}

static uth_mutex_t			m_req;
static uth_cond_t			c_req;
static volatile bool		v_req = false;
static uth_mutex_t			m_ack;
static uth_cond_t			c_ack;
static volatile bool		v_ack = false;

volatile uint32_t c_val=0;

#define FAST

int main(int argc, char **argv) {
	uint32_t core = *((volatile uint32_t *)0xF1000004);
	uth_thread_t producer_t, consumer_t, stub_t;

//		while (true) {
//			*((volatile uint32_t *)0x80000000) = (c_val >> 9);
//			c_val++;
//		}

	for (int i=0; i<4; i++) {
		printf("Hello World!\n");
	}


	if (core == 0) {
		// Release core 1
		*((volatile uint32_t *)0xF100000C) = 1;

		while (true) {}
	} else {
		// Write out something interesting
		uint32_t cnt = 0, last = 0;
		while (true) {
//		for (uint32_t i=0; i<4; i++) {
#ifdef FAST
			if (last != (cnt >> 12)) {
				last = (cnt >> 12);
#else
			if (last != cnt) {
				last = cnt;
#endif
				*((volatile uint32_t *)0x80000000) = last;
			}
			cnt++;
		}

		// Reset the board
		*((volatile uint32_t *)0x8000000C) = 1;
	}
}
