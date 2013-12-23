/****************************************************************************
 * axi4_amber23_svm_tb.sv
 ****************************************************************************/

/**
 * Module: axi4_amber23_svm_tb
 * 
 * TODO: Add module documentation
 */

module axi4_amber23_svm_tb(
		input				clk
		);
	reg 		rstn = 0;
	reg[15:0]	rstn_cnt = 0;
	
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
			) c2ic (
				.ACLK(clk),
				.ARESETn(rstn)
			);
	
	wire i_irq, i_firq;
	reg i_system_rdy = 1;
	
	axi4_a23_core #(
		.A23_CACHE_WAYS  (4 )
		) core (
		.i_clk           (clk            ), 
		.i_rstn			 (rstn			 ),
		.i_irq           (i_irq          ), 
		.i_firq          (i_firq         ), 
		.i_system_rdy    (i_system_rdy   ), 
		.master			 (c2ic.master	 )
		);
	
	axi4_if #(
				.AXI4_ADDRESS_WIDTH(32),
				.AXI4_DATA_WIDTH(32),
				.AXI4_ID_WIDTH(4)
			) ic2s0 (
				.ACLK(clk),
				.ARESETn(rstn)
			);
	
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
	
	
	axi4_svm_sram #(.AXI_DATA_WIDTH(32)) s0(
			.ACLK(clk),
			.ARESETn(rstn),
			.s(ic2s0.slave)
			);
	

	bind a23_tracer axi4_amber23_svm_tracer u_svm_tracer (
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
		.i_pc_wen                 (i_pc_wen                ));
	
endmodule

