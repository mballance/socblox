/*
 * uth_coop_scheduler_test_thread_swap.cpp
 *
 *  Created on: Jun 19, 2014
 *      Author: ballance
 */

#include "uth_coop_scheduler_test_thread_swap.h"
#include <memory.h>

uth_coop_scheduler_test_thread_swap::uth_coop_scheduler_test_thread_swap(const char *name) : uth_coop_scheduler_test_base(name) {
	// TODO Auto-generated constructor stub

}

uth_coop_scheduler_test_thread_swap::~uth_coop_scheduler_test_thread_swap() {
	// TODO Auto-generated destructor stub
}

void uth_coop_scheduler_test_thread_swap::build() {
	uth_coop_scheduler_test_base::build();
}

void uth_coop_scheduler_test_thread_swap::connect() {
	uth_coop_scheduler_test_base::connect();
}

void uth_coop_scheduler_test_thread_swap::start() {
	uth_coop_scheduler_test_base::start();

	uint32_t n_threads = 4;
	thread_activated = new uint32_t[n_threads];
	memset(thread_activated, 0, sizeof(uint32_t)*n_threads);

	threads = new uth_thread_t[n_threads];

	for (uint32_t i=0; i<n_threads; i++) {
		thread_activated[i] = (i+1);
	}

	for (uint32_t i=0; i<n_threads; i++) {
		fprintf(stdout, "--> start thread %d\n", (i+1));
		uth_thread_create(&threads[i], &uth_coop_scheduler_test_thread_swap::thread, &thread_activated[i]);
		fprintf(stdout, "<-- start thread %d\n", (i+1));
	}

	while (true) {
		bool all_zero = true;
		for (uint32_t i=0; i<n_threads; i++) {
			if (thread_activated[i] != 0) {
				all_zero = false;
				break;
			}
		}

		if (all_zero) {
			fprintf(stdout, "All Threads have run\n");
			break;
		}
		fprintf(stdout, "--> yield\n");
		uth_thread_yield();
		fprintf(stdout, "<-- yield\n");
	}
}

void uth_coop_scheduler_test_thread_swap::thread(void *ud)
{
	uint32_t *ptr = (uint32_t *)ud;
	fprintf(stdout, "--> thread %d\n", *ptr);
	fprintf(stdout, "<-- thread %d\n", *ptr);
	*ptr = 0;
}

svf_test_ctor_def(uth_coop_scheduler_test_thread_swap)

