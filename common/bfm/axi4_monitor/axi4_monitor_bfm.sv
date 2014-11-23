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

	// TODO: Implement 'target' tasks
	/*
    task axi4_monitor_bfm_write8(
    	longint unsigned	offset,
    	int unsigned 		data);
    	//
    endtask
    export "DPI-C" task axi4_monitor_bfm_write8;
    	 */

	// TODO: Implement 'host' tasks
	// import "DPI-C" task axi4_monitor_bfm_foo();
	
	import "DPI-C" context task axi4_monitor_bfm_ar(
			int unsigned 			araddr,
			int unsigned			arid,
			int unsigned			arlen,
			int unsigned			arsize,
			int unsigned			arburst,
			int unsigned			arlock,
			int unsigned			arcache,
			int unsigned			arprot,
			int unsigned			arqos,
			int unsigned			arregion);
	
	import "DPI-C" context task axi4_monitor_bfm_rdata(
			longint unsigned			rdata,
			int unsigned				rid,
			int unsigned				rresp,
			int unsigned				rlast);
	
	import "DPI-C" context task axi4_monitor_bfm_aw(
			int unsigned 			awaddr,
			int unsigned			awid,
			int unsigned			awlen,
			int unsigned			awsize,
			int unsigned			awburst,
			int unsigned			awlock,
			int unsigned			awcache,
			int unsigned			awprot,
			int unsigned			awqos,
			int unsigned			awregion);
	
	import "DPI-C" context task axi4_monitor_bfm_wdata(
			longint unsigned			wdata,
			longint unsigned			wstrb,
			int unsigned				wlast);
	
	import "DPI-C" context task axi4_monitor_bfm_wresp(
			int unsigned				bid,
			int unsigned				bresp);
	

	always @(posedge clk) begin
		if (rst_n == 0) begin
		end else begin
			if (monitor.ARVALID && monitor.ARREADY) begin
				axi4_monitor_bfm_ar(
					monitor.ARADDR,
					monitor.ARID, 
					monitor.ARLEN, 
					monitor.ARSIZE, 
					monitor.ARBURST, 
					monitor.ARLOCK, 
					monitor.ARCACHE, 
					monitor.ARPROT, 
					monitor.ARQOS, 
					monitor.ARREGION);
			end
			
			if (monitor.RVALID && monitor.RREADY) begin
				axi4_monitor_bfm_rdata(
						monitor.RDATA, 
						monitor.RID, 
						monitor.RRESP, 
						monitor.RLAST);
			end
			
			if (monitor.AWVALID && monitor.AWREADY) begin
//				$display("%m: AW '%08h", monitor.AWADDR);
				axi4_monitor_bfm_aw(
					monitor.AWADDR, 
					monitor.AWID, 
					monitor.AWLEN, 
					monitor.AWSIZE, 
					monitor.AWBURST, 
					monitor.AWLOCK, 
					monitor.AWCACHE, 
					monitor.AWPROT, 
					monitor.AWQOS, 
					monitor.AWREGION);
			end
			
			if (monitor.WVALID && monitor.WREADY) begin
				axi4_monitor_bfm_wdata(
						monitor.WDATA, 
						monitor.WSTRB, 
						monitor.WLAST);
			end
			
			if (monitor.BVALID && monitor.BREADY) begin
				axi4_monitor_bfm_wresp(monitor.BID, monitor.BRESP);
			end
		end
	end	
	
    import "DPI-C" context task axi4_monitor_bfm_register();
    initial begin
    	axi4_monitor_bfm_register();
    end

endmodule

