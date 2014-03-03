
#include "wb_uart_driver.h"
#include "a23_unicore_registers.h"

class c1 {
	public: int			i1;

	public:

		c1() {
			i1 = 25;
		}

};

static c1		c1_inst;
static c1		c2_inst;
static c1		c3_inst;
static c1		c4_inst;
static int		cnt = 0;

int main(int argc, char **argv) {
	volatile int *cnt_p = &cnt;
	volatile uint32_t *ptr = (uint32_t *)A23_UNICORE_UART_BASE;
	wb_uart_driver *uart_drv = new wb_uart_driver();

//	(*ptr) = 0xFFAAEE55;
//	(*ptr) = (uint32_t)uart_drv;

	uart_drv->init((void *)A23_UNICORE_UART_BASE);

	uart_drv->write("Hello\n", 6);

//	(*ptr) = 0xFFAAEE55;

	while (1) {
//		(*ptr) = 0x55AAEEFF;
		(*cnt_p)++;
	}
}
