/****************************************************************************
 * generic_sram_byte_en_w.sv
 ****************************************************************************/

/**
 * Module: generic_sram_byte_en_w
 * 
 * TODO: Add module documentation
 */
module generic_rom_w #(
		parameter int			MEM_ADDR_BITS=10,
		parameter int			MEM_DATA_BITS=32,
		parameter 				INIT_FILE=""
		) (
			input							i_clk,
			generic_sram_line_en_if.sram	s
		);

	// VL doesn't like direct assignments from the modport
	// to the sram instance
	wire [MEM_DATA_BITS-1:0] read_data;
	wire [MEM_ADDR_BITS-1:0] address;
	
	assign address = s.addr;
	assign s.read_data = read_data;
	
    generic_rom #(
    	.DATA_WIDTH      (MEM_DATA_BITS  ), 
    	.ADDRESS_WIDTH   (MEM_ADDR_BITS  ),
    	.INIT_FILE       (INIT_FILE)
    	) u_rom (
    	.i_clk           (i_clk         ), 
    	.i_address       (address       ),
    	.o_read_data     (read_data		)
    	);

endmodule

