/****************************************************************************
 * a23_dualcore_sys_tb.sv
 ****************************************************************************/
 
`ifdef GLS
`timescale 1 ps/ 1 ps
`endif

/**
 * Module: a23_dualcore_sys_tb
 * 
 * TODO: Add module documentation
 */
module a23_dualcore_sys_tb(input clk);
	import svf_pkg::*;
	reg[15:0]			rst_cnt = 0;
	reg					rstn = 0;
	
	localparam UART_BAUD = 7372800;
//	localparam UART_BAUD = 14745600;
	localparam CLK_PERIOD = 10;
	
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

	/*
	uart_if uart2co ();
	uart_if co2bfm ();
	
	 */
	
	timebase u_time();
	
	wire led0, led1, led2, led3;
	reg sw1, sw2, sw3, sw4;
	
	uart_if u_uart_if ();
	
	axi4_if #(
		.AXI4_ADDRESS_WIDTH  (32 ), 
		.AXI4_DATA_WIDTH     (32    ), 
		.AXI4_ID_WIDTH       (4      )
		) c0mon_if ();

`ifdef GLS
	a23_dualcore_sys_top_w #(
`else
	a23_dualcore_sys #(
`endif
			.CLK_PERIOD(CLK_PERIOD),
			.UART_BAUD(UART_BAUD)
			) u_a23_sys (
			.clk_i(clk),
			.sw1(sw1),
			.sw2(sw2),
			.sw3(sw3),
			.sw4(sw4),
			.led0(led0),
			.led1(led1),
			.led2(led2),
			.led3(led3),
			.uart_dte(u_uart_if.dte) // ,
//			.c0mon(c0mon_if.monitor_master)
			);
	
	wire[3:0] led = {led0, led1, led2, led3};
	reg[3:0] led_r = 0;
	
	always @(posedge clk) begin
		if (led_r != led) begin
			$display("LED: %0d", led);
			led_r <= led;
		end
	end
	
	

	/*
	uart_dte_crossover uartco (
		.u1  (uart2co.dce ), 
		.u2  (co2bfm.dce )
		);
		 */

	uart_bfm #(
			.CLK_PERIOD(CLK_PERIOD),
			.UART_BAUD(UART_BAUD)
			) u_uart_bfm (
		.i_clk       (clk      ), 
		.u           (u_uart_if.dce)
		);
		

`ifndef GLS
	bind a23_tracer a23_tracer_bfm u_tracer_bfm (
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

	bind axi4_monitor axi4_monitor_bfm #(
			.AXI4_ADDRESS_WIDTH(AXI4_ADDRESS_WIDTH),
			.AXI4_DATA_WIDTH(AXI4_DATA_WIDTH),
			.AXI4_ID_WIDTH(AXI4_ID_WIDTH)
			) u_monitor_bfm (
			.clk(clk),
			.rst_n(rst_n),
			.monitor(monitor)
			);
`else
	// Stub instances of modules that exist in non-GLS mode
	
	axi4_svf_rom #(
		.DATA_WIDTH     (8), 
		.ADDRESS_WIDTH  (1)
		) u_default_rom (
		.i_clk          (clk        ), 
		.i_address      (i_address  ), 
		.o_read_data    (o_data     ));
`endif	
	
endmodule

