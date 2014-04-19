#include "timer_drv.h"
#include "intc_drv.h"
#include <stdint.h>

static int foo = 0;
static uint8_t tmp[8];

int main(int argc, char **) {
	/*
	for (int i=0; i<8; i++) {
		tmp[i] = (i+1);
	}

	for (int i=0; i<8; i++) {
		foo = tmp[i];
	}

	while (1) {
	}
	 */

	timer_drv t_drv;
	intc_drv i_drv;

	t_drv.init((uint32_t *)0xF0000000);
	i_drv.init((uint32_t *)0xF0001000);

	t_drv.set_load(0, 0x100);
	t_drv.set_periodic(0, true);
	t_drv.set_enable(0, true);

	while (1) {
		foo++;
		*((uint32_t *)0x80000000) = foo;
	}
}
