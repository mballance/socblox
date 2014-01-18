/****************************************************************************
 * axi4_wb_bridge_tb.sv
 ****************************************************************************/

/**
 * Module: axi4_wb_bridge_tb
 * 
 * TODO: Add module documentation
 */
module axi4_wb_bridge_tb(input clk);
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
	
	axi4_if #(.AXI4_ADDRESS_WIDTH(32), .AXI4_DATA_WIDTH(32), .AXI4_ID_WIDTH(4)) m02ic();
	axi4_if #(.AXI4_ADDRESS_WIDTH(32), .AXI4_DATA_WIDTH(32), .AXI4_ID_WIDTH(4)) m12ic();
	axi4_if #(.AXI4_ADDRESS_WIDTH(32), .AXI4_DATA_WIDTH(32), .AXI4_ID_WIDTH(6)) ic2s0();
	axi4_if #(.AXI4_ADDRESS_WIDTH(32), .AXI4_DATA_WIDTH(32), .AXI4_ID_WIDTH(6)) ic2s1();
	
	axi4_svf_master_bfm #(
		.AXI4_ADDRESS_WIDTH     (32    ), 
		.AXI4_DATA_WIDTH        (32       ), 
		.AXI4_ID_WIDTH          (4         )
		) m0 (
		.clk                    (clk                   ), 
		.rstn                   (rstn                  ), 
		.master                 (m02ic.master          ));
	
	axi4_svf_master_bfm #(
		.AXI4_ADDRESS_WIDTH     (32    ), 
		.AXI4_DATA_WIDTH        (32       ), 
		.AXI4_ID_WIDTH          (4         )
		) m1 (
		.clk                    (clk                   ), 
		.rstn                   (rstn                  ), 
		.master                 (m12ic.master          ));

	axi4_interconnect_2x2 #(
		.AXI4_ADDRESS_WIDTH  (32 ), 
		.AXI4_DATA_WIDTH     (32    ), 
		.AXI4_ID_WIDTH       (4      ), 
		.SLAVE0_ADDR_BASE    ('h00000000 ), 
		.SLAVE0_ADDR_LIMIT   ('h00000fff ), 
		.SLAVE1_ADDR_BASE    ('h00001000 ), 
		.SLAVE1_ADDR_LIMIT   ('h00002fff )
		) axi4_ic (
		.clk                 (clk                ), 
		.rstn                (rstn               ), 
		.m0                  (m02ic.slave        ), 
		.m1                  (m12ic.slave        ), 
		.s0                  (ic2s0.master       ), 
		.s1                  (ic2s1.master       ));
	
	axi4_svf_sram #(
		.MEM_ADDR_BITS      (10     ), 
		.AXI_ADDRESS_WIDTH  (32 	), 
		.AXI_DATA_WIDTH     (32 	), 
		.AXI_ID_WIDTH       (6 		)
		) mem0 (
		.ACLK               (clk            ), 
		.ARESETn            (rstn           ), 
		.s                  (ic2s0.slave    ));
	
	wb_if #(.WB_ADDR_WIDTH(32), .WB_DATA_WIDTH(32)) br2ic;
	
	axi4_wb_bridge #(
		.AXI4_ADDRESS_WIDTH  (32   ), 
		.AXI4_DATA_WIDTH     (32   ), 
		.AXI4_ID_WIDTH       (6    ),
		.WB_ADDRESS_WIDTH    (32   ), 
		.WB_DATA_WIDTH       (32   )
		) axi_wb_br0 (
		.axi_clk             (clk            ), 
		.rstn                (rstn               ), 
		.axi_i               (ic2s1.slave        ), 
		.wb_o                (br2ic.master       ));
	
	
	wb_if #(.WB_ADDR_WIDTH(32), .WB_DATA_WIDTH(32)) m22ic;
	
	wb_svf_master_bfm #(
		.WB_ADDR_WIDTH  (32 ), 
		.WB_DATA_WIDTH  (32 )
		) m2 (
		.clk            (clk           ), 
		.rstn           (rstn          ), 
		.master         (m22ic.master  ));
	
	wb_if #(.WB_ADDR_WIDTH(32), .WB_DATA_WIDTH(32)) wic2s0;
	wb_if #(.WB_ADDR_WIDTH(32), .WB_DATA_WIDTH(32)) wic2s1;
	
	wb_interconnect_2x2 #(
		.WB_ADDR_WIDTH      (32     ), 
		.WB_DATA_WIDTH      (32     ), 
		.SLAVE0_ADDR_BASE   ('h00001000  ), 
		.SLAVE0_ADDR_LIMIT  ('h00001fff  ), 
		.SLAVE1_ADDR_BASE   ('h00002000  ), 
		.SLAVE1_ADDR_LIMIT  ('h00002fff  )
		) wb_ic (
		.clk                (clk               ), 
		.rstn               (rstn              ), 
		.m0                 (br2ic.slave       ), 
		.m1                 (m22ic.slave	   ), 
		.s0                 (wic2s0.master      ), 
		.s1                 (wic2s1.master      ));
	
	wb_sram_bfm #(
		.MEM_ADDR_BITS  (10 ), 
		.ADDR_WIDTH     (32    ), 
		.DATA_WIDTH     (32    )
		) mem1 (
		.clk            (clk           ), 
		.rstn           (rstn          ), 
		.slave          (wic2s0.slave   ));
	
	wb_sram_bfm #(
		.MEM_ADDR_BITS  (10 ), 
		.ADDR_WIDTH     (32    ), 
		.DATA_WIDTH     (32    )
		) mem2 (
		.clk            (clk           ), 
		.rstn           (rstn          ), 
		.slave          (wic2s1.slave   ));

endmodule

