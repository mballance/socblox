/*
 * fpgamgr.cpp
 *
 *  Created on: Jan 2, 2015
 *      Author: ballance
 */
// #include <stdint.h>
#include "hwlib.h"
#include "alt_16550_uart.h"
#include "alt_interrupt.h"
#include <stdlib.h>
#include <string.h>
#include <stdio.h>

// char msg[] = "Hello World!\r\n";
char *msg = 0;
uint32_t idx = 0;
uint32_t msg_sz;

static void int_callback(uint32_t icciar, void *handle_v)
{
	ALT_16550_HANDLE_t *handle = (ALT_16550_HANDLE_t *)handle_v;
	ALT_16550_INT_STATUS_t int_status;
	char tmp[256];

	alt_16550_int_status_get(handle, &int_status);

	switch (int_status) {
		case ALT_16550_INT_STATUS_RX_DATA:
		case ALT_16550_INT_STATUS_RX_TIMEOUT: {
			uint32_t fifo_level_rx;
			alt_16550_fifo_level_get_rx(handle, &fifo_level_rx);
			alt_16550_fifo_read(handle, tmp, fifo_level_rx);
			} break;

		case ALT_16550_INT_STATUS_TX_IDLE: {
			uint32_t fifo_level_tx;
			uint32_t fifo_size_tx;

			alt_16550_fifo_size_get_tx(handle, &fifo_size_tx);
			alt_16550_fifo_level_get_tx(handle, &fifo_level_tx);

			for (uint32_t i=0; i<(fifo_size_tx-fifo_level_tx); i++) {
				alt_16550_fifo_write(handle, &msg[idx], 1);
				idx = ((idx+1) % msg_sz);
			}

			} break;

		case ALT_16550_INT_STATUS_LINE:
			break;

	}

}

int main(int argc, char **argv)
{
	char tmp[] = "Hello World 0x00000000!\r\n";
	ALT_16550_HANDLE_t handle;
	ALT_STATUS_CODE status;
	ALT_INT_INTERRUPT_t uart_int_id = ALT_INT_INTERRUPT_UART0;
	uint32_t int_target = 0;

	msg = (char *)malloc(sizeof(tmp));
	sprintf(msg, "Hello World 0x%08x!\r\n", (uint32_t)msg);
//	memcpy(msg, tmp, sizeof(tmp));
	msg_sz = sizeof(tmp)-1;


    alt_int_global_init();
    alt_int_cpu_init();
    alt_int_cpu_enable();
    alt_int_global_enable();


	handle.device = ALT_16550_DEVICE_SOCFPGA_UART0;
	handle.location = 0;
	handle.clock_freq = 0;

    status = alt_16550_init(
    		handle.device,
    		handle.location,
    		handle.clock_freq,
    		&handle);

    status = alt_16550_line_config_set(&handle, ALT_16550_DATABITS_8,
                                               ALT_16550_PARITY_DISABLE,
                                               ALT_16550_STOPBITS_1);

    status = alt_16550_baudrate_set(&handle, ALT_16550_BAUDRATE_115200);

    alt_16550_fifo_enable(&handle);
    alt_16550_fifo_trigger_set_rx(&handle, ALT_16550_FIFO_TRIGGER_RX_HALF_FULL);
    alt_16550_fifo_trigger_set_tx(&handle, ALT_16550_FIFO_TRIGGER_TX_QUARTER_FULL);

    alt_16550_int_enable_rx(&handle);
//    alt_16550_int_enable_line(&handle);

    alt_int_isr_register(uart_int_id, int_callback, &handle);

    if (uart_int_id >= 32) {
    	if (int_target == 0) {
    		int_target = (1 << alt_int_util_cpu_count())-1;
    	}
    	alt_int_dist_target_set(uart_int_id, int_target);
    }

    alt_int_dist_enable(uart_int_id);

    status = alt_16550_enable(&handle);

	alt_16550_fifo_write(&handle, &msg[idx++], 1);
	alt_16550_int_enable_tx(&handle);

	while (true) {
		;
	}

//    while (true) {
//    	for (uint32_t i=0; i<sizeof(msg); i++) {
//    		uint32_t level;
//
//    		do {
//    			alt_16550_fifo_level_get_tx(&handle, &level);
//    		} while (level > 0);
//    		// Wait for there to be room
//
//   			status = alt_16550_fifo_write(&handle, &msg[i], 1);
//    	}
//    }

	return 0;
}



