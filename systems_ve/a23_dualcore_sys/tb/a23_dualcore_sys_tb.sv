/****************************************************************************
 * a23_dualcore_sys_tb.sv
 ****************************************************************************/

/**
 * Module: a23_dualcore_sys_tb
 * 
 * TODO: Add module documentation
 */
module a23_dualcore_sys_tb(input clk);
	import svf_pkg::*;
	reg[15:0]			rst_cnt = 0;
	reg					rstn = 0;
	
`ifndef VERILATOR
	reg clk_r = 0;
	assign clk = clk_r;
	
	initial begin
		forever begin
			#10ns;
			clk_r <= 1;
			#10ns;
			clk_r <= 0;
		end
	end
	initial begin
		svf_runtest();
	end
`endif
	
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
		$display("TB_ROOT=%m");
		$sformat(TB_ROOT, "%m");
		set_config_string("*", "TB_ROOT", TB_ROOT);
	end
	/* verilator tracing_on */

	uart_if uart2co ();
	uart_if co2bfm ();

	a23_dualcore_sys u_a23_sys (
		.brdclk		(clk  ), 
		.brdrstn	(rstn ), 
		.u			(uart2co.dte)
		);
	
	uart_dte_crossover uartco (
		.u1  (uart2co.dce ), 
		.u2  (co2bfm.dce )
		);

	uart_bfm u_uart_bfm (
		.i_clk       (clk      ), 
		.u           (co2bfm.dte)
		);
	
	bind a23_tracer axi4_a23_svf_tracer u_svf_tracer (
			.i_clk                    (i_clk                   ), 
			.i_fetch_stall            (i_fetch_stall           ), 
			.i_instruction            (i_instruction           ), 
			.i_instruction_valid      (i_instruction_valid     ), 
			.i_instruction_undefined  (i_instruction_undefined ), 
			.i_instruction_execute    (i_instruction_execute   ), 
			.i_interrupt              (i_interrupt             ), 
			.i_interrupt_state        (i_interrupt_state       ), 
			.i_instruction_address    (i_instruction_address   ), 
			.i_pc_sel                 (i_pc_sel                ), 
			.i_pc_wen                 (i_pc_wen                ), 
			.i_write_enable           (i_write_enable          ), 
			.fetch_stall              (fetch_stall             ), 
			.i_data_access            (i_data_access           ), 
			.pc_nxt                   (pc_nxt                  ), 
			.i_address                (i_address               ), 
			.i_write_data             (i_write_data            ), 
			.i_byte_enable            (i_byte_enable           ), 
			.i_read_data              (i_read_data             ),
			.i_r0_r15_user            (i_r0_r15_user           )
			);	
	
	
endmodule

