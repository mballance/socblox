
#include "uart_debug.h"
#include <stdio.h>

void debug_init() {
//	uart.init(ALT_16550_DEVICE_SOCFPGA_UART0, 115200);

}

void debug(const char *fmt, ...) {
	va_list ap;
	va_start(ap, fmt);

	vfprintf(stdout, fmt, ap);

	va_end(ap);
}
