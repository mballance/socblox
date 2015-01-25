/*
 * io_stubs.cpp
 *
 *  Created on: Jul 15, 2014
 *      Author: ballance
 */

#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include <stdint.h>

typedef uint8_t u8;
typedef uint16_t u16;
typedef uint32_t u32;

#define UART_LSR_DR     0x01            /* Data ready */
#define UART_LSR_OE     0x02            /* Overrun */
#define UART_LSR_PE     0x04            /* Parity error */
#define UART_LSR_FE     0x08            /* Framing error */
#define UART_LSR_BI     0x10            /* Break */
#define UART_LSR_THRE   0x20            /* Xmit holding register empty */
#define UART_LSR_TEMT   0x40            /* Xmitter empty */
#define UART_LSR_ERR    0x80            /* Error */

#define __arch_getb(a)                  (*(volatile unsigned char *)(a))
#define __arch_getw(a)                  (*(volatile unsigned short *)(a))
#define __arch_getl(a)                  (*(volatile unsigned int *)(a))

#define __arch_putb(v,a)                (*(volatile unsigned char *)(a) = (v))
#define __arch_putw(v,a)                (*(volatile unsigned short *)(a) = (v))
#define __arch_putl(v,a)                (*(volatile unsigned int *)(a) = (v))


#define dmb()           __asm__ __volatile__ ("" : : : "memory")
#define __iormb()       dmb()
#define __iowmb()       dmb()

#define writeb(v,c)     ({ u8  __v = v; __iowmb(); __arch_putb(__v,c); __v; })
#define writew(v,c)     ({ u16 __v = v; __iowmb(); __arch_putw(__v,c); __v; })
#define writel(v,c)     ({ u32 __v = v; __iowmb(); __arch_putl(__v,c); __v; })

#define readb(c)        ({ u8  __v = __arch_getb(c); __iormb(); __v; })
#define readw(c)        ({ u16 __v = __arch_getw(c); __iormb(); __v; })
#define readl(c)        ({ u32 __v = __arch_getl(c); __iormb(); __v; })

typedef struct uart_s {
	uint32_t	rbr;
	uint32_t	ier;
	uint32_t	iir;
//	uint32_t	fcr;
	uint32_t	lcr;
	uint32_t	mcr;
	uint32_t	lsr;
	uint32_t	msr;
	uint32_t	spr;
} uart_t;

extern unsigned char __heap_start;
static void *_prv_heap = 0;

void *_sbrk(size_t incr) {
        char *prev_heap;

        if (_prv_heap == 0) {
                _prv_heap = (unsigned char *)&__heap_start;
        }
        prev_heap = _prv_heap;
        _prv_heap += incr;

        return prev_heap;
}

void _exit(int code)
{
	while (1) {}
}

int _kill(pid_t pid, int sig) {
	return 0;
}

pid_t _getpid(void)
{
	return 0;
}

size_t _write(int fd, char *data, size_t cnt)
{

	if (fd == 1 || fd == 2) {
		int i,j;
		volatile uart_t *u = (uart_t *)0xFFC02000;

		for (j=0; j<cnt; j++) {
			while (!(u->lsr & (UART_LSR_THRE|UART_LSR_TEMT))) { ; }

			if (data[j] == '\n') {
				u->rbr = '\r';
				while (!(u->lsr & (UART_LSR_THRE|UART_LSR_TEMT))) { ; }
			}

			u->rbr = data[j];
		}
	}

#ifdef UNDEFINED
	uint32_t i;
	volatile uint32_t *DR = (uint32_t *)(0xF0000000+(2*0x1000));
	volatile uint32_t *FR = (uint32_t *)(0xF0000000+(2*0x1000)+24);

	for (uint32_t i=0; i<cnt; i++) {
		// Spin, waiting for the Tx fifo to have space
		while ((*FR & 0x20) != 0) {
			;
		}

		// Write to UART
		*DR = data[i];
	}
#endif
	return cnt;
}

int _close(int fd)
{
	return 0;
}

size_t _lseek(int fd, int pos, int whence)
{
	return 0;
}

int _read(int fd, char *data, size_t cnt)
{
	return 0;
}

int _open(const char *file, int flags)
{
	return 0;
}

int _isatty(int fd)
{
	return 0;
}

struct stat;
int _fstat(int fd, struct stat *pstat)
{
	return 0;
}

//void *_sbrk(size_t incr) {
//	return 0;
//  char *prev_heap;
//
//  if (heap == 0) {
//    heap = (unsigned char *)&__heap_start;
//  }
//  prev_heap = heap;
//  heap += incr;
//
//  return prev_heap;
//}

