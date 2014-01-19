/****************************************************************************
 * uart_if.sv
 ****************************************************************************/

/**
 * Interface: uart_if
 * 
 * TODO: Add interface documentation
 */
interface uart_if;
	reg					cts;
	reg					txd;
	reg					rts;
	reg					rxd;
	
	
	modport dte(
			input			cts,
			output			txd,
			output			rts,
			input			rxd
			);
	
	modport dce(
			output			cts,
			input			txd,
			input			rts,
			output			rxd
			);

endinterface

