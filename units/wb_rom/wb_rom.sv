/****************************************************************************
 * wb_rom.sv
 ****************************************************************************/

/**
 * Module: wb_rom
 * 
 * TODO: Add module documentation
 */
module wb_rom #(
		parameter int			MEM_ADDR_BITS=10,
		parameter int			WB_ADDRESS_WIDTH=32,
		parameter int			WB_DATA_WIDTH=32,
		parameter 				INIT_FILE=""
		) (
			input				clk,
			input				rstn,
			wb_if.slave			s
		);
	
	generic_sram_line_en_if #(
		.NUM_ADDR_BITS  (MEM_ADDR_BITS ), 
		.NUM_DATA_BITS  (WB_DATA_WIDTH )
		) u_mem_if (
		);
	
	wb_generic_line_en_sram_bridge #(
			.ADDRESS_WIDTH(MEM_ADDR_BITS),
			.DATA_WIDTH(WB_DATA_WIDTH)
		) u_bridge (
		.clk     (clk					), 
		.rstn    (rstn					), 
		.wb_s    (s      				), 
		.sram_m  (u_mem_if.sram_client	));

	generic_rom_w #(
		.MEM_ADDR_BITS  (MEM_ADDR_BITS ), 
		.MEM_DATA_BITS  (WB_DATA_WIDTH ), 
		.INIT_FILE      (INIT_FILE     )
		) u_rom (
		.i_clk          (clk       		), 
		.s              (u_mem_if.sram  ));

endmodule


