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

extern "C" void _exit(int code)
{
	while (1) {}
}

extern "C" int _kill(pid_t pid, int sig) {
	return 0;
}

extern "C" pid_t _getpid()
{
	return 0;
}

extern "C" size_t _write(int fd, char *data, size_t cnt)
{
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
	return cnt;
}

extern "C" int _close(int fd)
{
	return 0;
}

extern "C" size_t _lseek(int fd, int pos, int whence)
{
	return 0;
}

extern "C" int _read(int fd, char *data, size_t cnt)
{
	return 0;
}

extern "C" int _open(const char *file, int flags)
{
	return 0;
}

extern "C" int _isatty(int fd)
{
	return 0;
}

extern "C" int _fstat(int fd, struct stat *pstat)
{
	return 0;
}


