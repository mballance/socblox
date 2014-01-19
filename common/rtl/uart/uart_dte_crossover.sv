/****************************************************************************
 * uart_dte_crossover.sv
 ****************************************************************************/

/**
 * Module: uart_dte_crossover
 * 
 * TODO: Add module documentation
 */
module uart_dte_crossover(
		uart_if.dce			u1,
		uart_if.dce			u2
		);
	
	assign u1.cts = u2.rts;
	assign u2.cts = u1.rts;
	assign u1.rxd = u2.txd;
	assign u2.rxd = u1.txd;

endmodule

