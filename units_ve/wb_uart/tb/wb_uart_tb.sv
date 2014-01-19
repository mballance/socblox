/****************************************************************************
 * wb_uart_tb.sv
 ****************************************************************************/

/**
 * Module: wb_uart_tb
 * 
 * TODO: Add module documentation
 */
module wb_uart_tb(input clk);
	import svf_pkg::*;
	reg[15:0]			rst_cnt = 0;
	reg					rstn = 0;
	
	always @(posedge clk) begin
		if (rst_cnt == 100) begin
			rstn <= 1;
		end else begin
			rst_cnt <= rst_cnt + 1;
		end
	end
	
	/* verilator tracing_off */
	initial begin
		string TB_ROOT;
		$sformat(TB_ROOT, "%m");
		set_config_string("*", "TB_ROOT", TB_ROOT);
	end
	/* verilator tracing_on */
	
	wb_if #(.WB_ADDR_WIDTH(32), .WB_DATA_WIDTH(32)) m02ic();
	wb_if #(.WB_ADDR_WIDTH(32), .WB_DATA_WIDTH(32)) ic2uart();
	uart_if uart2co();
	uart_if co2bfm();
	
	wb_svf_master_bfm #(
			.WB_ADDR_WIDTH  (32 ), 
			.WB_DATA_WIDTH  (32 )
			) m0 (
			.clk            (clk           ), 
			.rstn           (rstn          ), 
			.master         (m02ic.master  ));	
	
	wb_interconnect_1x1 #(
		.WB_ADDR_WIDTH      (32     ), 
		.WB_DATA_WIDTH      (32     ), 
		.SLAVE0_ADDR_BASE   ('h00000000  ), 
		.SLAVE0_ADDR_LIMIT  ('h00000fff  )
		) ic (
		.clk                (clk               ), 
		.rstn               (rstn              ), 
		.m0                 (m02ic.slave       ), 
		.s0                 (ic2uart.master    ));
	
	wb_uart #(
		.WB_DWIDTH   (32  ), 
		.WB_SWIDTH   (32  ), 
		.CLK_PERIOD  (100 ),
		.UART_BAUD   (230400)
		) u_uart (
		.i_clk       (clk          ), 
		.slave       (ic2uart.slave), 
		.o_uart_int  (o_uart_int   ), 
		.u           (uart2co.dte  ));

	uart_dte_crossover u_crossover (
		.u1  (uart2co.dce ), 
		.u2  (co2bfm.dce ));

	uart_bfm #(
		.CLK_PERIOD  (100 ),
		.UART_BAUD   (230400)
		) uart_bfm_0 (
		.i_clk       (clk      		), 
		.u           (co2bfm.dte   ));

	
endmodule

