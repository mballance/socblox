/****************************************************************************
 * axi4_monitor_bfm.sv
 ****************************************************************************/

/**
 * Module: axi4_monitor_bfm
 * 
 * TODO: Add module documentation
 */
module axi4_monitor_bfm #(
			parameter int		AXI4_ADDRESS_WIDTH=32,
			parameter int		AXI4_DATA_WIDTH=32,
			parameter int		AXI4_ID_WIDTH=32
			) (
			input				clk,
			input				rst_n,
			axi4_if.monitor		monitor
			);	

	always @(posedge clk) begin
		if (rst_n == 0) begin
		end else begin
			if (monitor.ARVALID && monitor.ARREADY) begin
				$display("%m AR: ARADDR='h%08h", monitor.ARADDR);
			end
			
			if (monitor.RVALID && monitor.RREADY) begin
				$display("%m R: RDATA='h%08h", monitor.RDATA);
			end
			
			if (monitor.AWVALID && monitor.AWREADY) begin
				$display("%m AW: AWADDR='h%08h", monitor.AWADDR);
			end
			
			if (monitor.WVALID && monitor.WREADY) begin
				$display("%m W: WDATA='h%08h", monitor.WDATA);
			end
		end
	end	
	


endmodule

