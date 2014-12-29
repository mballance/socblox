/****************************************************************************
 * a23_dualcore_sys_top_w.sv
 ****************************************************************************/
`include "axi4_if_macros.svh"

/**
 * Module: a23_dualcore_sys_top_w
 * 
 * TODO: Add module documentation
 */
module a23_dualcore_sys_top_w #(
		parameter int CLK_PERIOD = 10,
		parameter int UART_BAUD = 7372800
		) (
		input			clk_i,
		input			sw1,
		input			sw2,
		input			sw3,
		input			sw4,
		output			led0,
		output			led1,
		output			led2,
		output			led3,
		uart_if.dte				uart_dte,
//		axi4_if.monitor_master	c0mon
		);

	a23_dualcore_sys_top u_top (
		.clk_i(clk_i),
		.sw1(sw1),
		.sw2(sw2),
		.sw3(sw3),
		.sw4(sw4),
		.led0(led0),
		.led1(led1),
		.led2(led2),
		.led3(led3) //,
//		`AXI4_IF_PORTMAP(c0mon, c0mon)
		);

endmodule

