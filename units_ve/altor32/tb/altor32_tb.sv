/****************************************************************************
 * altor32_tb.sv
 ****************************************************************************/
`ifdef GLS
`timescale 1 ps/ 1 ps
`endif

/**
 * Module: altor32_tb
 * 
 * TODO: Add module documentation
 */
module altor32_tb(input clk);
	import svf_pkg::*;
	reg[15:0]			rst_cnt = 0;
	reg					rstn = 0;
	
	localparam INIT_FILE = "test_image.dat";
	
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
		$display("INIT_FILE=%0s", INIT_FILE);
	end
	/* verilator tracing_on */

	// TODO: instantiate DUT, BFMs
	
	reg intr_i = 0;
	reg nmi_i = 0;
	
	wb_if #(
		.WB_ADDR_WIDTH  (32 ), 
		.WB_DATA_WIDTH  (32 )
		) imem ();
	
	wb_if #(
		.WB_ADDR_WIDTH  (32 ), 
		.WB_DATA_WIDTH  (32 )
		) dmem ();
	
	altor32_w altor32_w (
		.clk     (clk			), 
		.rstn    (rstn			), 
		.intr_i  (intr_i		), 
		.nmi_i   (nmi_i			), 
		.imem    (imem.master	), 
		.dmem    (dmem.master	));
	
	wb_if #(
		.WB_ADDR_WIDTH  (32 ), 
		.WB_DATA_WIDTH  (32 )
		) ic2rom ();
	
	wb_if #(
		.WB_ADDR_WIDTH  (32 ), 
		.WB_DATA_WIDTH  (32 )
		) ic2ram ();

	wb_interconnect_2x2 #(
		.WB_ADDR_WIDTH      (32     ), 
		.WB_DATA_WIDTH      (32     ), 
		.SLAVE0_ADDR_BASE   ('h10000000  ), 
		.SLAVE0_ADDR_LIMIT  ('h1000ffff  ),
		.SLAVE1_ADDR_BASE   ('h12000000  ), 
		.SLAVE1_ADDR_LIMIT  ('h1200ffff  )
		) u_ic (
		.clk                (clk               ), 
		.rstn               (rstn              ), 
		.m0                 (imem.slave        ), 
		.m1                 (dmem.slave        ), 
		.s0                 (ic2rom.master     ),
		.s1                 (ic2ram.master     ));

	wb_rom #(
		.MEM_ADDR_BITS     (14    ), 
		.WB_ADDRESS_WIDTH  (32 ), 
		.WB_DATA_WIDTH     (32    ),
		.INIT_FILE         (INIT_FILE)
		) u_rom (
		.clk               (clk              ), 
		.rstn              (rstn             ), 
		.s                 (ic2rom.slave     ));
	
	wb_sram #(
		.MEM_ADDR_BITS     (14    ), 
		.WB_ADDRESS_WIDTH  (32 ), 
		.WB_DATA_WIDTH     (32    )
		) u_sram (
		.clk               (clk              ), 
		.rstn              (rstn             ), 
		.s                 (ic2ram.slave     ));
	
endmodule

