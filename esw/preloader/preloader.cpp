/*
 * preloader.cpp
 *
 *  Created on: Feb 6, 2015
 *      Author: ballance
 */

#include "preloader.h"
#include <string.h>
#include <stdlib.h>
#include <stdio.h>

preloader::preloader() {

}

void preloader::run(preloader_msg_if *msg_if) {
	preloader_msg_t *msg = 0;

	while (true) {
		uint32_t msg_sz = msg_if->recv_next_msg_sz();

		if (!msg || msg_sz > msg->msg_max) {
			if (msg) {
				free(msg);
			}

			uint32_t new_sz = (((msg_sz-1)/4096)+1)*4096;
			msg = (preloader_msg_t *)malloc(sizeof(preloader_msg_t)+new_sz);
			msg->msg_max = new_sz;
		}

		uint32_t recv_sz = 0;
		msg->msg_sz = msg_sz;
		while (recv_sz < msg_sz) {
			int32_t sz = msg_if->recv_msg_data(&msg->data[recv_sz], (msg_sz-recv_sz));

			if (sz > 0) {
				recv_sz += sz;
			}
		}

		preloader_msg_e msg_e = (preloader_msg_e)msg->data[0];


		switch (msg_e) {
			case PRELOADER_LOAD_MSG: {
				fprintf(stderr, "PRELOADER_LOAD_MSG\n");
				preloader_load_msg_s *load_msg = (preloader_load_msg_s *)&msg->data[4];
				for (uint32_t i=0; i<load_msg->sz; i+=4) {
					*((uint32_t *)(load_msg->addr+i)) = *((uint32_t *)(load_msg->data+i));
				}
//				memcpy((uint8_t *)load_msg->addr, load_msg->data, load_msg->sz);

				// Send an ACK
				msg->data[0] = PRELOADER_ACK_MSG;

//				msg_if->send_msg(msg->data, 4);
				} break;

			case PRELOADER_GO_MSG: {
				fprintf(stderr, "PRELOADER_GO_MSG\n");
				typedef int (*main_func_t)(int argc, char **argv);
				main_func_t main_func;
				preloader_go_msg_s *go_msg = (preloader_go_msg_s *)&msg->data[4];

				main_func = (main_func_t)go_msg->addr;
				char **argv = new char *[go_msg->argc];

				for (uint32_t i=0; i<go_msg->argc; i++) {
					argv[i] = (char *)&msg->data[go_msg->argv_offs[i]];
				}

				msg->data[0] = PRELOADER_ACK_MSG;
				msg_if->send_msg(msg->data, 4);

				main_func(go_msg->argc, argv);
				} break;

			default:
				fprintf(stderr, "UNKNOWN\n");
				break;
		}
	}

	if (msg) {
		free(msg);
	}
}

preloader::~preloader() {
	// TODO Auto-generated destructor stub
}

