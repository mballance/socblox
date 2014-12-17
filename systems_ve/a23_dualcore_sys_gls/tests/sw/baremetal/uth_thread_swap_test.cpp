
#include "bidi_message_queue_drv_uth.h"
#include "uth.h"
#include "uth_coop_thread_mgr.h"
#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>

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

void thread(void *ud) {
	uint32_t *td = (uint32_t *)ud;
	*td = 0;
}

//static char buf[256];

int main(int argc, char **argv) {
	uint32_t n_threads = 4;
	uint32_t *thread_data = (uint32_t *)malloc(sizeof(uint32_t)*n_threads);
	uth_thread_t *threads = (uth_thread_t *)malloc(sizeof(uth_thread_t)*n_threads);

	fprintf(stdout, "Hello World\n");
	fflush(stdout);

	for (uint32_t i=0; i<n_threads; i++) {
		thread_data[i] = (i+1);
	}

	for (uint32_t i=0; i<n_threads; i++) {
		uth_thread_create(&threads[i], &thread, &thread_data[i]);
	}

	while (true) {
		bool all_zero = true;

		for (uint32_t i=0; i<n_threads; i++) {
			if (thread_data[i] != 0) {
				all_zero = false;
				break;
			}
		}

		if (all_zero) {
			fprintf(stdout, "all_zero\n");
			fflush(stdout);
			break;
		}

		uth_thread_yield();
	}

	while (true) {}
}
