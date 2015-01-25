
#ifndef INCLUDED_UART_DEBUG_H
#define INCLUDED_UART_DEBUG_H
#include <stdarg.h>


void debug_init();

void debug(const char *fmt, ...);


#endif /* INCLUDED_UART_DEBUG_H */
