
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

static uth_mutex_t			m;

volatile uint32_t c1=0, c2=0;

int main(int argc, char **argv) {
	uint32_t core = *((volatile uint32_t *)0xF1000004);

	uth_get_thread_mgr();

	if (core == 0) {
		uth_mutex_init(&m);

		// Release core 1
		*((volatile uint32_t *)0xF100000C) = 1;
	}

	// Now, try to acquire locks
	while (true) {
		uth_mutex_lock(&m);

		for (uint32_t i=0; i<16; i++) {
			if (core == 0) {
				c1++;
			} else {
				c2++;
			}
		}

		uth_mutex_unlock(&m);
	}

}
