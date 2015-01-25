#include "uart_debug.h"
#include "designware_eth_drv.h"
#include "net_stack.h"
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char **argv) {

	printf("Hello World!\n");

	designware_eth_drv drv;
	net_stack net_s(&drv);

	printf("Malloc: %p\n", malloc(100));
	printf("Malloc: %p\n", malloc(100));
	printf("Malloc: %p\n", malloc(100));
	printf("Malloc: %p\n", malloc(100));

	drv.init((void *)0xFF702000);

	printf("Malloc: %p\n", malloc(100));
	printf("Malloc: %p\n", malloc(100));
	printf("Malloc: %p\n", malloc(100));
	printf("Malloc: %p\n", malloc(100));

	while (1) {
		net_packet *pkt = net_s.recv();
		printf("Packet:\n");
		net_s.release_pkt(pkt);

//		ul_netdrv_frame_t *frm = drv.recv();
//		printf("FRM: %d %p %p\n", frm->sz, frm, frm->data);
//		for (uint32_t i=0; i<frm->sz; i++) {
//			if (!((i+1)%8)) {
//				printf("\n");
//			}
//			printf("%02x ", frm->data[i]);
//		}
//		printf("\n");
//		drv.release_frame(frm);
	}

	while (1) {
		;
	}

	return 0;
}
