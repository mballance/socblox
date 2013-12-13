/****************************************************************************
 * svm_axi4_master_bfm.sv
 ****************************************************************************/

/**
 * Module: svm_axi4_master_bfm
 * 
 * TODO: Add module documentation
 */
module svm_axi4_master_bfm #(
			parameter int AXI4_ADDRESS_WIDTH=32,
			parameter int AXI4_DATA_WIDTH=128,
			parameter int AXI4_ID_WIDTH=4,
			parameter int AXI4_MAX_BURST_LENGTH=16
		) (
			input			clk,
			input			rstn,
			axi4_if.master	master
		);
	bit[AXI4_DATA_WIDTH-1:0]			data_buf[AXI4_MAX_BURST_LENGTH];
	reg[(AXI4_ADDRESS_WIDTH-1):0]		AWADDR_r;
	reg[(AXI4_ID_WIDTH-1):0]			AWID_r;
	reg[7:0]							AWLEN_r;
	reg[2:0]							AWSIZE_r;
	reg[1:0]							AWBURST_r;
	reg[3:0]							AWCACHE_r;
	reg[2:0]							AWPROT_r;
	reg[3:0]							AWQOS_r;
	reg[3:0]							AWREGION_r;
	reg									AWVALID_r;
	reg									aw_req;
	
	assign master.AWADDR = AWADDR_r;
	assign master.AWID = AWID_r;
	assign master.AWLEN = AWLEN_r;
	assign master.AWSIZE = AWSIZE_r;
	assign master.AWBURST = AWBURST_r;
	assign master.AWCACHE = AWCACHE_r;
	assign master.AWPROT = AWPROT_r;
	assign master.AWQOS = AWQOS_r;
	assign master.AWREGION = AWREGION_r;


	// AW state machine
	reg[2:0]				aw_state;
	always @(posedge clk) begin
		if (rstn != 1) begin
			aw_state <= 0;
		end else begin
			case (aw_state)
				0: begin
					if (aw_req) begin
						AWVALID_r <= 1;
						aw_state <= 1;
						aw_req = 0;
					end
				end
				
				1: begin
					if (master.AWVALID && master.AWREADY) begin
						AWVALID_r <= 0;
						aw_state <= 0;
						svm_axi4_master_bfm_aw_ready();
					end
				end
			endcase
		end
	end
	
	task svm_axi4_master_bfm_aw_valid(
		longint unsigned				AWADDR,
		int unsigned					AWID,
		byte unsigned					AWLEN,
		byte unsigned					AWSIZE,
		byte unsigned					AWBURST,
		byte unsigned					AWCACHE,
		byte unsigned					AWPROT,
		byte unsigned					AWQOS,
		byte unsigned					AWREGION);
		AWADDR_r = AWADDR;
		AWID_r = AWID;
		AWLEN_r = AWLEN;
		AWSIZE_r = AWSIZE;
		AWBURST_r = AWBURST;
		AWCACHE_r = AWCACHE;
		AWPROT_r = AWPROT;
		AWQOS_r = AWQOS;
		AWREGION_r = AWREGION;
	endtask
	export "DPI-C" task svm_axi4_master_bfm_aw_valid;

	import "DPI-C" task svm_axi4_master_bfm_aw_ready();

endmodule

