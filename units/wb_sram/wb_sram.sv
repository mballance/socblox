/****************************************************************************
 * wb_sram.sv
 ****************************************************************************/

/**
 * Module: wb_sram
 * 
 * TODO: Add module documentation
 */
module wb_sram #(
		parameter int			MEM_ADDR_BITS=10,
		parameter int			WB_ADDRESS_WIDTH=32,
		parameter int			WB_DATA_WIDTH=32
		) (
			input				clk,
			input				rstn,
			wb_if.slave			s
		);

	// synopsys translate_off
	initial begin
		$display("WB_SRAM path %m");
	end
	// synopsys translate_on
	
	generic_sram_byte_en_if #(
			.NUM_ADDR_BITS		(MEM_ADDR_BITS),
			.NUM_DATA_BITS		(WB_DATA_WIDTH)
		) u_sram_if();

	wb_generic_byte_en_sram_bridge u_bridge (
		.clk     (clk    ), 
		.rstn    (rstn   ), 
		.wb_s    (s   ), 
		.sram_m  (u_sram_if.sram_client ));

	generic_sram_byte_en_w #(
		.MEM_ADDR_BITS  (MEM_ADDR_BITS ), 
		.MEM_DATA_BITS  (WB_DATA_WIDTH )
		) u_sram (
		.i_clk          (clk         	  ), 
		.s              (u_sram_if.sram   ));
endmodule


