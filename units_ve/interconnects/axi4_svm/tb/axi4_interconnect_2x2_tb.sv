/****************************************************************************
 * axi4_interconnect_tb.sv
 ****************************************************************************/

/**
 * Module: axi4_interconnect_tb
 * 
 * TODO: Add module documentation
 */
 
module axi4_interconnect_2x2_tb 
		#(
		parameter int N_MASTERS=4
		)
		(
		input clk
		);
	reg rstn = 0;
	reg[15:0]		rstn_cnt = 0;
	
	always @(posedge clk) begin
		if (rstn_cnt == 100) begin
			rstn = 1;
		end else begin
			rstn_cnt = rstn_cnt + 1;
		end
	end

	localparam N_MASTERS_p = 2;
	
	axi4_if #(
			.AXI4_ADDRESS_WIDTH(32),
			.AXI4_DATA_WIDTH(32),
			.AXI4_ID_WIDTH(4)
		)
		m12ic(.ACLK(clk), .ARESETn(rstn))
		;
		
	axi4_if #(
			.AXI4_ADDRESS_WIDTH(32),
			.AXI4_DATA_WIDTH(32),
			.AXI4_ID_WIDTH(4)
		)
		m22ic(.ACLK(clk), .ARESETn(rstn))
		;
	
	axi4_svm_master_bfm #(
		.AXI4_ADDRESS_WIDTH     (32    ), 
		.AXI4_DATA_WIDTH        (32       ), 
		.AXI4_ID_WIDTH          (4         ), 
		.AXI4_MAX_BURST_LENGTH  (16 )
		) 
		bfm_1 (
			.clk                    (clk                   ), 
			.rstn                   (rstn                  ), 
			.master                 (m12ic.master          ));

	axi4_svm_master_bfm #(
		.AXI4_ADDRESS_WIDTH     (32    ), 
		.AXI4_DATA_WIDTH        (32    ), 
		.AXI4_ID_WIDTH          (4     ), 
		.AXI4_MAX_BURST_LENGTH  (16    ) 
		) 
		bfm_2 (
			.clk                    (clk                   ), 
			.rstn                   (rstn                  ), 
			.master                 (m22ic.master          ))
		;
		
	axi4_if #(
			.AXI4_ADDRESS_WIDTH(32),
			.AXI4_DATA_WIDTH(32),
			.AXI4_ID_WIDTH(5)
		)
		ic2s1(.ACLK(clk), .ARESETn(rstn));
	
	axi4_if #(
			.AXI4_ADDRESS_WIDTH(32),
			.AXI4_DATA_WIDTH(32),
			.AXI4_ID_WIDTH(5)
		)
		ic2s2(.ACLK(clk), .ARESETn(rstn))
		;
		
	axi4_interconnect_2x2 #(
		.AXI4_ADDRESS_WIDTH  	(32 	), 
		.AXI4_DATA_WIDTH     	(32    	), 
		.AXI4_ID_WIDTH       	(4      ),
		.SLAVE0_ADDR_BASE 		('h0000 ),
		.SLAVE0_ADDR_LIMIT		('h0fff	),
		.SLAVE1_ADDR_BASE 		('h1000 ),
		.SLAVE1_ADDR_LIMIT		('h1fff	)
		) u_ic (
		.clk                 (clk                ), 
		.rstn                (rstn               ), 
		.m0                  (m12ic.slave        ), 
		.m1                  (m22ic.slave        ), 
		.s0                  (ic2s1.master       ), 
		.s1                  (ic2s2.master       ));
	
	axi4_svm_sram #(
		.MEM_ADDR_BITS      (10     ), 
		.AXI_ADDRESS_WIDTH  (32 ), 
		.AXI_DATA_WIDTH     (32    ), 
		.AXI_ID_WIDTH       (5      )
		) 
		s1 (
			.ACLK           (clk            ), 
			.ARESETn        (rstn           ), 
			.s              (ic2s1.master   ));
		
	axi4_svm_sram #(
		.MEM_ADDR_BITS      (10     ), 
		.AXI_ADDRESS_WIDTH  (32 ), 
		.AXI_DATA_WIDTH     (32    ), 
		.AXI_ID_WIDTH       (5      )
		) 
		s2 (
			.ACLK           (clk            ), 
			.ARESETn        (rstn           ), 
			.s              (ic2s2.master   ))
		;
	
endmodule

