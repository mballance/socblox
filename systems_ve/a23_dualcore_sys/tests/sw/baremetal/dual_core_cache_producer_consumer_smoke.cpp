
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

	uth_mutex_init(&m_req);
	uth_mutex_init(&m_ack);

	if (core == 0) {
		// Release core 1
		*((volatile uint32_t *)0xF100000C) = 1;

		while (true) {
			// Send a value to core1
//			uth_mutex_lock(&m_req);
			while (!uth_thread_int_mutex_trylock(&m_req)) { }
			v_req = true;
			c_val++;
//			uth_mutex_unlock(&m_req);
			uth_thread_int_mutex_unlock(&m_req);

			// Wait for acknowledgment
			while (true) {
//				uth_mutex_lock(&m_ack);
				while (!uth_thread_int_mutex_trylock(&m_ack)) { }
				if (v_ack) {
					v_ack = false;
//					uth_mutex_unlock(&m_ack);
					uth_thread_int_mutex_unlock(&m_ack);
					break;
				}
//				uth_mutex_unlock(&m_ack);
				uth_thread_int_mutex_unlock(&m_ack);
			}
		}
	} else {
		// Write out something interesting
		uint32_t cnt, last = 0;
		while (true) {
			while (true) {
				while (!uth_thread_int_mutex_trylock(&m_req)) { }
//				uth_mutex_lock(&m_req);
				if (v_req) {
					cnt = c_val;
					v_req = false;
//					uth_mutex_unlock(&m_req);
					uth_thread_int_mutex_unlock(&m_req);
					break;
				}
//				uth_mutex_unlock(&m_req);
				uth_thread_int_mutex_unlock(&m_req);
			}
#ifdef FAST

			if (last != (cnt >> 12)) {
				last = (cnt >> 12);
#else
			if (last != cnt) {
				last = cnt;
#endif
				*((volatile uint32_t *)0x80000000) = last;
			}

			// Notify that we've received the value
//			uth_mutex_lock(&m_ack);
			while (!uth_thread_int_mutex_trylock(&m_ack)) { }
			v_ack = true;
//			uth_mutex_unlock(&m_ack);
			uth_thread_int_mutex_unlock(&m_ack);
		}

		// Reset the board
		*((volatile uint32_t *)0x8000000C) = 1;
	}
}
