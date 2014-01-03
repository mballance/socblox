/****************************************************************************
 * axi4_amber23_svf_mem_if.sv
 ****************************************************************************/

/**
 * Module: axi4_amber23_svf_mem_if
 * 
 * TODO: Add module documentation
 */
module axi4_amber23_svf_mem_if(
		input				ACLK,
		input				ARESETn,
		axi4_if.slave		s);
	
	initial begin
		bit[31:0] data;
		$display("--> write");
		axi4_amber23_svf_mem_write32(0, 'h00000002);
		$display("<-- write");
		axi4_amber23_svf_mem_read32(0, data);
		$display("--> read 'h%08h", data);
	end

	task axi4_amber23_svf_mem_write32(
		int unsigned 		offset,
		int unsigned 		data);
		ram[offset] = data;
	endtask
	export "DPI-C" task axi4_amber23_svf_mem_write32;
	
	task axi4_amber23_svf_mem_read32(
		int unsigned 		offset,
		output int unsigned data);
		data = ram[offset];
	endtask
	export "DPI-C" task axi4_amber23_svf_mem_read32;

endmodule

