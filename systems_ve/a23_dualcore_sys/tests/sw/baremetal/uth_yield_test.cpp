
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

void thread_main(void *ud) {
	while (true) {
		uth_thread_yield();
	}
}

int main(int argc, char **argv) {
	uth_thread_t main_thread;
	uth_thread_create(&main_thread, &thread_main, 0);

	while (true) {
		uth_thread_yield();
	}
}
