/****************************************************************************
 * axi4_intc.sv
 ****************************************************************************/

/**
 * Module: axi4_intc
 * 
 * TODO: Add module documentation
 * 
 * Requirements
 * - Route interrupts to various processing cores
 * - Facilitate inter-core communication via SW interrupts
 * - Provide processor ID to cores
 * 
 */
module axi4_intc_2_32 #(
		parameter int AXI4_DATA_WIDTH = 32,
		parameter int N_MASTERS=1,
		) (
		input					clk,
		input					rstn,
		axi4_if.slave			slave,
		input[31:0]				irq_i,
		output[1:0]				irq_o
		);
		


endmodule

