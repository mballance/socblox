#include "timer_drv.h"

static int foo = 0;

int main(int argc, char **) {
	volatile uint32_t *led = (uint32_t *)0x80000000;
	/*
	timer_drv t_drv;

	t_drv.init((uint32_t *)0xF0000000);

	t_drv.set_load(0, 0x100);
	t_drv.set_periodic(0, true);
	t_drv.set_enable(0, true);

	while (1) {
		foo++;
	}
	 */

	while (1) {
		foo++;
		*led = foo;
	}

}
