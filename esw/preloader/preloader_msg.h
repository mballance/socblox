
#ifndef INCLUDED_PRELOADER_MSG_H
#define INCLUDED_PRELOADER_MSG_H

#include <stdint.h>

typedef enum {
	PRELOADER_LOAD_MSG,
	PRELOADER_GO_MSG,
	PRELOADER_ACK_MSG
} preloader_msg_e;

typedef struct preloader_msg_s {
	uint32_t		msg_sz;
	uint32_t		msg_max;
	// first 4 bytes reserved for preloader_msg_e
	uint8_t			data[0];
} preloader_msg_t;

typedef struct preloader_load_msg_s {
	uint32_t			addr;
	uint32_t			sz;
	uint8_t				data[0];
} preloader_fill_msg;

typedef struct preloader_go_msg_s {
	uint32_t			addr;
	uint32_t			argc;
	uint32_t			argv_offs[0];
} preloader_go_msg;

#endif /* INCLUDED_PRELOADER_MSG_H */
