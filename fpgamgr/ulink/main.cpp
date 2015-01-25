#include "ulink_os_serial.h"
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

int main(int argc, char **argv) {
	uint8_t data[] = {1, 2, 3, 4, 5, 6};
	ulink_os_serial ul("/dev/ttyUSB0", 115200);
//	ulink_os_serial ul("/dev/ttyUSB0", 921600);


//	ulink_msg *msg = ul.alloc_msg();
//	ulink_msg *r_msg;
//
//	msg->append(data, sizeof(data));
//
//	for (uint32_t i=0; i<100; i++) {
//		fprintf(stdout, "--> send\n");
//		ul.send_msg(msg);
//		fprintf(stdout, "<-- send\n");
//		fprintf(stdout, "--> recv\n");
//		r_msg = ul.recv_msg();
//		fprintf(stdout, "<-- recv %d\n", r_msg->size());
//
//		ul.release_msg(r_msg);
//	}

	fprintf(stdout, "--> connect\n");
	ul.connect();
	fprintf(stdout, "<-- connect\n");

	fprintf(stdout, "--> configure\n");
	fprintf(stdout, "<-- configure\n");

	while (true) { sleep(1); }
}
