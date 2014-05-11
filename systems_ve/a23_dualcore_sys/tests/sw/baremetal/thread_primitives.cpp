
#include "uex_thread_primitives.h"
#include <stdint.h>
#include <stdlib.h>

uint8_t					stack1[256], stack2[256];
uex_thread_t			thread1_h, thread2_h;
uex_thread_t			thread_m;

extern "C" void thread1(void *p) {
	while (1) {
		uex_thread_swap(&thread1_h, &thread2_h);
	}
}

extern "C" void thread2(void *p) {
	while (1) {
		uex_thread_swap(&thread2_h, &thread_m);
	}
}

extern "C" void irq_handler()
{
}

int main(int argc, char **) {
	uint8_t *stack;

	uex_thread_init(&thread1_h, &stack1[252], &thread1, (void *)1);
	uex_thread_init(&thread2_h, &stack2[252], &thread2, (void *)2);

	while (1) {
		uex_thread_swap(&thread_m, &thread1_h);
	}
}
