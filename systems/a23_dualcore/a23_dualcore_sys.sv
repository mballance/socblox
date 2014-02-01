/****************************************************************************
 * a23_dualcore_sys.sv
 ****************************************************************************/
 
`ifndef BOOT_ROM_FILE
`define BOOT_ROM_FILE ""
`endif
 

/**
 * Module: a23_dualcore_sys
 * 
 * TODO: Add module documentation
 */
module a23_dualcore_sys(
		input			brdclk,
		input			brdrstn
`ifndef FPGA		
		,
		uart_if.dte		u
`endif
		);
	
	localparam MASTER_ID_WIDTH = 5;
	localparam SLAVE_ID_WIDTH = 6;
	
	wire clk, rstn;
	
	assign clk = brdclk;
	assign rstn = brdrstn;
	
	axi4_if #(
		.AXI4_ADDRESS_WIDTH  (32 ), 
		.AXI4_DATA_WIDTH     (32 ), 
		.AXI4_ID_WIDTH       (MASTER_ID_WIDTH)
		) core2ic (
		.ACLK                (clk		), 
		.ARESETn             (rstn		));
	
	axi4_if #(
		.AXI4_ADDRESS_WIDTH  (32 ), 
		.AXI4_DATA_WIDTH     (32    ), 
		.AXI4_ID_WIDTH       (SLAVE_ID_WIDTH    )
		) ic2rom (
		.ACLK                (clk               ), 
		.ARESETn             (rstn            ));
	
	axi4_if #(
		.AXI4_ADDRESS_WIDTH  (32 ), 
		.AXI4_DATA_WIDTH     (32    ), 
		.AXI4_ID_WIDTH       (SLAVE_ID_WIDTH    )
		) ic2ram (
		.ACLK                (clk               ), 
		.ARESETn             (rstn            ));
	
	axi4_if #(
		.AXI4_ADDRESS_WIDTH  (32 ), 
		.AXI4_DATA_WIDTH     (32    ), 
		.AXI4_ID_WIDTH       (SLAVE_ID_WIDTH    )
		) ic2uart (
		.ACLK                (clk               ), 
		.ARESETn             (rstn            ));
	
	a23_dualcore_subsys a23_subsys_0 (
		.clk        (clk       ),
		.rstn       (rstn      ),
		.master		(core2ic.master));

	axi4_interconnect_1x3 #(
		.AXI4_ADDRESS_WIDTH  (32 ), 
		.AXI4_DATA_WIDTH     (32    ), 
		.AXI4_ID_WIDTH       (MASTER_ID_WIDTH),
		.SLAVE0_ADDR_BASE    ('h00000000  ), 
		.SLAVE0_ADDR_LIMIT   ('h00000fff  ),
		.SLAVE1_ADDR_BASE    ('h20000000  ),
		.SLAVE1_ADDR_LIMIT   ('h20003fff  ),
		.SLAVE2_ADDR_BASE    ('hf0001000  ),
		.SLAVE2_ADDR_LIMIT   ('hf0001fff  )
		) axi4_interconnect_1x1 (
		.clk                 (clk                ), 
		.rstn                (rstn               ), 
		.m0                  (core2ic.slave      ), 
		.s0                  (ic2rom.master      ),
		.s1                  (ic2ram.master		),
		.s2                  (ic2uart.master	));
	
	axi4_rom #(
		.MEM_ADDR_BITS      (10     ), 
		.AXI_ADDRESS_WIDTH  (32 ), 
		.AXI_DATA_WIDTH     (32    ), 
		.AXI_ID_WIDTH       (SLAVE_ID_WIDTH), 
		.INIT_FILE          (`BOOT_ROM_FILE)
		) boot_rom (
		.ACLK               (clk            ), 
		.ARESETn            (rstn           ), 
		.s                  (ic2rom.slave   ));
	
	axi4_sram #(
		.MEM_ADDR_BITS      (12     ), 
		.AXI_ADDRESS_WIDTH  (32 ), 
		.AXI_DATA_WIDTH     (32    ), 
		.AXI_ID_WIDTH       (SLAVE_ID_WIDTH )
		) ram (
		.ACLK               (clk            ), 
		.ARESETn            (rstn           ), 
		.s                  (ic2ram.slave   ));

`ifndef FPGA
	wb_if #(
		.WB_ADDR_WIDTH  (32 ), 
		.WB_DATA_WIDTH  (32 )
		) br2wbic ();
	
	wb_if #(
		.WB_ADDR_WIDTH  (32 ), 
		.WB_DATA_WIDTH  (32 )
		) wbic2uart ();
	
	axi4_wb_bridge #(
		.AXI4_ADDRESS_WIDTH  (32 ), 
		.AXI4_DATA_WIDTH     (32    ), 
		.AXI4_ID_WIDTH       (SLAVE_ID_WIDTH), 
		.WB_ADDRESS_WIDTH    (32   ), 
		.WB_DATA_WIDTH       (32      )
		) ic2wb (
		.axi_clk             (clk                ), 
		.rstn                (rstn               ), 
		.axi_i               (ic2uart.slave      ), 
		.wb_o                (br2wbic.master     ));

	wb_interconnect_1x1 #(
		.WB_ADDR_WIDTH      (32     ), 
		.WB_DATA_WIDTH      (32     ), 
		.SLAVE0_ADDR_BASE   ('hf0001000  ), 
		.SLAVE0_ADDR_LIMIT  ('hf0001fff  )
		) wbic (
		.clk                (clk               ), 
		.rstn               (rstn              ), 
		.m0                 (br2wbic.slave     ), 
		.s0                 (wbic2uart.master  ));

	wire o_uart_int;
	
	wb_uart #(
		.WB_DWIDTH   (32  ), 
		.WB_SWIDTH   (32  ), 
		.CLK_PERIOD  (100 ), 
		.UART_BAUD   (100  )
		) u_uart (
		.i_clk       (clk            ), 
		.slave       (wbic2uart.slave), 
		.o_uart_int  (o_uart_int     ), 
		.u           (u)
		);
`else
	// FPGA bridges to UART within HPS
`endif

endmodule

