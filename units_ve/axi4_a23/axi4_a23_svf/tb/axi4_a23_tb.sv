/****************************************************************************
 * axi4_a23_tb.sv
 ****************************************************************************/

/**
 * Module: axi4_a23_tb
 * 
 * TODO: Add module documentation
 */

module axi4_a23_tb(
		input				clk
		);
	import svf_pkg::*;

	reg 		rstn = 0;
	reg[15:0]	rstn_cnt = 0;

	/** 
	 * SV DPI method of launching a test 
	 */
`ifndef VERILATOR
	reg			clk_r = 0;

	initial begin
		forever begin
			#10ns;
			clk_r <= 1;
			#10ns;
			clk_r <= 0;
		end
	end
	
	assign clk = clk_r;
	
	initial begin
		svf_runtest();
	end
`endif

	/**
	 * Specify the root path of the testbench, since this can differ
	 * across harnesses
	 */
	 /* verilator tracing_off */
	initial begin
		automatic string path;
		
		$sformat(path, "%m");
		set_config_string("*", "TB_ROOT", path);
	end
	 /* verilator tracing_on */
	
	always @(posedge clk) begin
		if (rstn_cnt == 100) begin
			rstn = 1;
		end else begin
			rstn_cnt = rstn_cnt + 1;
		end
	end
	
	axi4_if #(
				.AXI4_ADDRESS_WIDTH(32),
				.AXI4_DATA_WIDTH(32),
				.AXI4_ID_WIDTH(4)
			) c2ic ();
	
	wire i_irq, i_firq;
	
	assign i_irq = 0;
	assign i_firq = 0;
	
	axi4_a23_core #(
		.A23_CACHE_WAYS  (4 )
		) core (
		.i_clk           (clk            ), 
		.i_rstn			 (rstn			 ),
		.i_irq           (i_irq          ), 
		.i_firq          (i_firq         ), 
		.master			 (c2ic.master	 )
		);
	
	axi4_if #(
				.AXI4_ADDRESS_WIDTH(32),
				.AXI4_DATA_WIDTH(32),
				.AXI4_ID_WIDTH(5)
			) ic2s0 ();
	
	axi4_interconnect_1x1 #(
		.AXI4_ADDRESS_WIDTH  (32 ), 
		.AXI4_DATA_WIDTH     (32    ), 
		.AXI4_ID_WIDTH       (4      ), 
		.SLAVE0_ADDR_BASE    (0   ), 
		.SLAVE0_ADDR_LIMIT   ('hffffffff  )
		) ic0 (
		.clk                 (clk                ), 
		.rstn                (rstn               ), 
		.m0                  (c2ic.slave         ), 
		.s0                  (ic2s0.master       ));
	
	
	axi4_sram #(
			.AXI_DATA_WIDTH(32),
			.MEM_ADDR_BITS(22)
		) s0(
			.ACLK(clk),
			.ARESETn(rstn),
			.s(ic2s0.slave)
			);
	
	bind a23_tracer a23_tracer_bfm u_tracer (
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

