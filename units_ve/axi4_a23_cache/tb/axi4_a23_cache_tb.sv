/****************************************************************************
 * axi4_a23_cache_tb.sv
 ****************************************************************************/

/**
 * Module: axi4_a23_cache_tb
 * 
 * TODO: Add module documentation
 */
module axi4_a23_cache_tb(input clk);
	import svf_pkg::*;
	reg[15:0]			rst_cnt = 0;
	reg					rstn = 0;
	
`ifndef VERILATOR
	reg clk_r = 0;
	assign clk = clk_r;
	
	initial begin
		forever begin
			#5;
			clk_r <= 1;
			#5;
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

	// TODO: instantiate DUT, BFMs

	localparam CACHE_LINES = 256;
	localparam CACHE_WORDS_PER_LINE = 4;
	localparam WAYS = 4;
	
	
	axi4_a23_cache #(
		.CACHE_LINES           (CACHE_LINES          ), 
		.CACHE_WORDS_PER_LINE  (CACHE_WORDS_PER_LINE ), 
		.WAYS                  (WAYS                 )
		) u_cache (
		.i_clk                 (clk                  ), 
		.i_rstn                (rstn                 ), 
	
		// 		
		.i_select              (i_select             ), 
		.i_exclusive           (i_exclusive          ), 
		.i_write_data          (i_write_data         ), 
		.i_write_enable        (i_write_enable       ), 
		.i_address             (i_address            ), 
		.i_address_nxt         (i_address_nxt        ), 
		.i_byte_enable         (i_byte_enable        ), 
		.i_cache_enable        (i_cache_enable       ), 
		.i_cache_flush         (i_cache_flush        ), 
		.o_read_data           (o_read_data          ), 
		.i_core_stall          (i_core_stall         ), 
		.o_stall               (o_stall              ), 
		
		// Bus side used to 
		.o_wb_req              (o_wb_req             ), 
		.i_wb_address          (i_wb_address         ), 
		.i_wb_read_data        (i_wb_read_data       ), 
		.i_read_data_valid     (i_read_data_valid    ), 
		.i_wb_stall            (i_wb_stall           ));
	
	
endmodule

