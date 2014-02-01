/****************************************************************************
 * a23_dualcore_subsys.sv
 ****************************************************************************/

/**
 * Module: a23_dualcore_subsys
 * 
 * TODO: Add module documentation
 * 
 * ID width of master is 5
 */
module a23_dualcore_subsys (
		input				clk,
		input				rstn,
		axi4_if.master		master);
//		input				irq[31:0] */);
	
	reg [15:0]			cnt = 0, cnt2 = 0;
	reg i_system_rdy = 1;
	reg i_irq = 0;
	reg i_firq = 0;
	
	always @(posedge clk) begin
		cnt <= cnt + 1;
	end
	
	assign cnt_zero = (cnt == 0);
	assign cnt2_zero = (cnt2 == 0);
	
	axi4_if #(
			.AXI4_ADDRESS_WIDTH(32),
			.AXI4_DATA_WIDTH(32),
			.AXI4_ID_WIDTH(4)
			) a23_0_2ic();
	
	axi4_if #(
			.AXI4_ADDRESS_WIDTH(32),
			.AXI4_DATA_WIDTH(32),
			.AXI4_ID_WIDTH(4)
			) a23_1_2ic();
	
	axi4_if #(
			.AXI4_ADDRESS_WIDTH(32),
			.AXI4_DATA_WIDTH(32),
			.AXI4_ID_WIDTH(5)
			) ic2s0();
	
	axi4_a23_core #(
		.A23_CACHE_WAYS  (4)
		) u_a23_0 (
		.i_clk           (clk				), 
		.i_rstn          (rstn				), 
		.i_irq           (i_irq          ), 
		.i_firq          (i_firq         ), 
		.i_system_rdy    (i_system_rdy   ), 
		.master          (a23_0_2ic.master ));
	
	always @(posedge clk) begin
		if (a23_0_2ic.AWVALID) begin
			cnt2 <= cnt2 + 1;
		end
	end
	
	axi4_a23_core #(
		.A23_CACHE_WAYS  (4)
		) u_a23_1 (
		.i_clk           (clk              ), 
		.i_rstn          (rstn             ), 
		.i_irq           (i_irq            ), 
		.i_firq          (i_firq           ), 
		.i_system_rdy    (i_system_rdy     ), 
		.master          (a23_1_2ic.master ));

	axi4_interconnect_2x1_pt #(
		.AXI4_ADDRESS_WIDTH  (32 ), 
		.AXI4_DATA_WIDTH     (32    ), 
		.AXI4_ID_WIDTH       (4      ), 
		.SLAVE0_ADDR_BASE    ('hf0000000   ), 
		.SLAVE0_ADDR_LIMIT   ('hf0000fff   )
		) axi4_interconnect_2x1_pt (
		.clk                 (clk                	), 
		.rstn                (rstn               	), 
		.m0                  (a23_0_2ic.slave    	), 
		.m1                  (a23_1_2ic.slave    	), 
		.s0                  (ic2s0.master       	), 
		.sdflt               (master				));

	axi4_sram #(
		.MEM_ADDR_BITS      (4     ), 
		.AXI_ADDRESS_WIDTH  (32 ), 
		.AXI_DATA_WIDTH     (32    ), 
		.AXI_ID_WIDTH       (5      )
		) sram0 (
		.ACLK               (clk            ), 
		.ARESETn            (rstn           ), 
		.s                  (ic2s0.slave    ));

endmodule

