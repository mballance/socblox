#include "ulink_buffer.h"
#include <string.h>
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char **argv) {
	ulink_buffer buf(16);
	uint32_t sz;
	uint8_t tmp[256];
	uint8_t *msg = (uint8_t *)"Hello World"; // 11
	uint32_t len = strlen((const char *)msg);
	uint8_t *long_msg = (uint8_t *)"Hello World This is a long msg";
	uint32_t long_len = strlen((const char *)long_msg);

	// Write 22
	buf.write(msg, len);
	buf.write(msg, len);

	// Read 16
	sz = buf.read(tmp, 16);
	fprintf(stdout, "sz=%d\n", sz);
	tmp[sz] = 0;
	fprintf(stdout, "read: %s\n", tmp);

	// Read the remainder
	sz = buf.read(tmp, 16);
	fprintf(stdout, "sz=%d\n", sz);
	tmp[sz] = 0;
	fprintf(stdout, "read: %s\n", tmp);

	// Shouldn't be any more to read
	sz = buf.read(tmp, 16);
	fprintf(stdout, "sz=%d\n", sz);
	tmp[sz] = 0;
	fprintf(stdout, "read: %s\n", tmp);

	// Write a message longer than the buffer page
	sz = buf.write(long_msg, long_len);
	fprintf(stdout, "sz=%d\n", sz);
	sz = buf.read(tmp, sizeof(tmp));
	fprintf(stdout, "read_sz=%d\n", sz);
	tmp[sz] = 0;
	fprintf(stdout, "long msg: sz=%d %s\n", sz, tmp);

	for (uint32_t i=0; i<1000; i++) {
		uint32_t tmp_sz = (rand() % (long_len-1)) + 1;
		buf.write(long_msg, tmp_sz);
		sz = buf.read(tmp, sizeof(tmp));
		if (sz != tmp_sz) {
			fprintf(stdout, "Error\n");
		}
	}

	sz = buf.read(tmp, sizeof(tmp));
	fprintf(stdout, "Final size=%d\n", sz);

	return 0;
}

