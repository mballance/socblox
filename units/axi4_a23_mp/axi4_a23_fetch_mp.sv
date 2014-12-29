/////////////////////////////////////////////////////////////////
//                                                              //
//  Fetch - Instantiates the fetch stage sub-modules of         //
//  the Amber 2 Core                                            //
//                                                              //
//  This file is part of the Amber project                      //
//  http://www.opencores.org/project,amber                      //
//                                                              //
//  Description                                                 //
//  Instantiates the Cache and Wishbone I/F                     //
//  Also contains a little bit of logic to decode memory        //
//  accesses to decide if they are cached or not                //
//                                                              //
//  Author(s):                                                  //
//      - Conor Santifort, csantifort.amber@gmail.com           //
//                                                              //
//////////////////////////////////////////////////////////////////
//                                                              //
// Copyright (C) 2010 Authors and OPENCORES.ORG                 //
//                                                              //
// This source file may be used and distributed without         //
// restriction provided that this copyright statement is not    //
// removed from the file and that any derivative work contains  //
// the original copyright notice and the associated disclaimer. //
//                                                              //
// This source file is free software; you can redistribute it   //
// and/or modify it under the terms of the GNU Lesser General   //
// Public License as published by the Free Software Foundation; //
// either version 2.1 of the License, or (at your option) any   //
// later version.                                               //
//                                                              //
// This source is distributed in the hope that it will be       //
// useful, but WITHOUT ANY WARRANTY; without even the implied   //
// warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR      //
// PURPOSE.  See the GNU Lesser General Public License for more //
// details.                                                     //
//                                                              //
// You should have received a copy of the GNU Lesser General    //
// Public License along with this source; if not, download it   //
// from http://www.opencores.org/lgpl.shtml                     //
//                                                              //
//////////////////////////////////////////////////////////////////


module axi4_a23_fetch_mp #(
		parameter int A23_CACHE_WAYS = 4
		) (
input                       i_clk,
input						i_rstn,

input       [31:0]          i_address,
input                       i_address_valid,
input       [31:0]          i_address_nxt,      // un-registered version of address to the cache rams
input       [31:0]          i_write_data,
input                       i_write_enable,
output       [31:0]         o_read_data,
output						o_read_data_valid,
input                       i_priviledged,
input                       i_exclusive,        // high for read part of swap access
input       [3:0]           i_byte_enable,
input                       i_data_access,      // high for data petch, low for instruction fetch
input                       i_cache_enable,     // cache enable
input                       i_cache_flush,      // cache flush
input       [31:0]          i_cacheable_area,   // each bit corresponds to 2MB address space
input                       i_system_rdy,
output                      o_fetch_stall,      // when this is asserted all registers 
                                                // in all 3 pipeline stages are held
                                                // at their current values
output						o_dabt,
                                                

axi4_if.master				master

);

wire                        wb_stall;
wire    [31:0]              cache_read_data;
wire                        sel_cache;
wire                        sel_wb;
wire						ack_wb;
wire                        cache_wb_req;
wire                        address_cachable;

`ifdef UNDEFINED
always @(posedge i_clk) begin
	if (i_address_valid && !o_fetch_stall) begin
		$display("FETCH: 'h%08h 'h%08h", i_address, o_read_data);
	end
end
`endif

// ======================================
// Memory Decode
// ======================================
// assign address_cachable  = /*in_cachable_mem( i_address ) &&*/ i_cacheable_area[i_address[25:21]];
// 10 - 1024
// 11 - 2048
// 11 - 4096
// 12 - 8192
// 13 - 16384
// 14 - 32768
// 16 - 64k
// 17 - 128k
// 18 - 256k
// 19 - 512k
// 20 - 1m
// 21 - 2m
// 22 - 4m
// 23 - 8m
// 24 - 16m
// 25 - 32m
// 26 - 64m
// 27 - 128m
assign address_cachable  = (!i_exclusive && i_cacheable_area[i_address[31:27]]);

// Don't start wishbone transfers when the cache is stalling the core
// The cache stalls the core during its initialization sequence
// assign sel_wb            = !sel_cache && i_address_valid && !(cache_stall);
assign sel_wb            = i_address_valid;

// Return read data either from the wishbone bus or the cache
assign o_read_data       = master.RDATA;

assign o_read_data_valid = (sel_wb && ack_wb);
	
// Stall the instruction decode and execute stages of the core
// when the fetch stage needs more than 1 cycle to return the requested
// read data
assign o_fetch_stall     = !i_system_rdy || wb_stall;

wire[31:0]						o_wb_adr;
wire[31:0]						i_wb_dat;

wire[31:0]						ARADDR;
wire[31:0]						RDATA;
wire							RVALID;

assign ARADDR = master.ARADDR;
assign RDATA = master.RDATA;
assign RVALID = master.RVALID;

wire                        core_read_request;
wire                        core_write_request;
wire                        read_ack, write_ack;

wire                        cache_read_request;
wire                        cache_write_request;

assign cache_read_request = 0;
assign cache_write_request = 0;

assign o_dabt = (i_exclusive)?(
			(write_ack && master.BRESP != 2'b01) ||
			(read_ack && master.RRESP != 2'b01)
		):(
			(write_ack && master.BRESP != 2'b00) ||
			(read_ack && master.RRESP != 2'b00)
		);
		
// Tie off signals
assign master.AWID = 0;
// TODO:
assign master.AWBURST = 0;
assign master.AWCACHE = (address_cachable)?2:0;
assign master.AWPROT = 0;
assign master.AWQOS = 4'b0000;
assign master.AWREGION = 0;

assign master.ARID = 0;
assign master.ARQOS = 4'b0000;
assign master.ARCACHE = (address_cachable)?2:0;
assign master.ARPROT = 0;
assign master.ARREGION = 0;

assign master.ARLOCK = i_exclusive;
assign master.AWLOCK = i_exclusive;


	reg[2:0]				read_state = 0;

		// Read logic
	always @(posedge i_clk) begin
		if (i_rstn == 0) begin
			read_state <= 0;
		end else begin
		case (read_state)
			0: begin
				if (core_read_request) begin
					read_state <= 1;
				end
			end
	
			// Core read
			1: begin
				if (master.ARVALID && master.ARREADY) begin
					read_state <= 2;
				end
			end
			
			2: begin
				if (master.RVALID && master.RREADY && master.RLAST) begin
					read_state <= 0;
				end
			end
			
			// Cache read
			3: begin
				if (master.ARVALID && master.ARREADY) begin
					read_state <= 4;
				end
			end

			4: begin
				if (master.RVALID && master.RREADY && master.RLAST) begin
					read_state <= 0;
				end
			end
		endcase
		end
	end
	
	reg[3:0]				write_state = 0;
	
	// Write logic
	always @(posedge i_clk) begin
		if (i_rstn == 0) begin
			write_state <= 0;
		end else begin
			case (write_state)
				0: begin
					if (core_write_request) begin
						write_state <= 1;
					end
				end
			
				1: begin
					// address phase complete
					if (master.AWVALID && master.AWREADY) begin
						write_state <= 2;
					end
				end

				// Data transfer phase
				2: begin
					if (master.WREADY && master.WVALID) begin
						// If last
						write_state <= 3;
					end
				end
		
				// Wait for BRESP
				3: begin
					if (master.BREADY && master.BVALID) begin
						write_state <= 0;
					end
				end
		
				// Cache write-back
				4: begin
					// address phase complete
					if (master.AWVALID && master.AWREADY) begin
						write_state <= 5;
					end
				end
			
				5: begin
					if (master.WREADY && master.WVALID) begin
						// If last
						write_state <= 6;
					end
				end
			
				6: begin
					if (master.BREADY && master.BVALID) begin
						write_state <= 0;
					end
				end
			endcase
		end
	end	
	
	assign wb_stall = 
		( core_read_request  && !read_ack )			|| 
		( core_write_request && !write_ack)
	;
	
	assign read_ack = (read_state == 2 && master.RVALID && master.RREADY);
	assign write_ack = (write_state == 3 && master.BREADY && master.BVALID);
//	assign o_stall_cache = 0;
	
	assign ack_wb =
		( core_read_request && read_ack) ||
		( core_write_request && write_ack);
	

	assign master.ARVALID = (read_state == 1 || read_state == 3);
	assign master.ARADDR = (master.ARVALID)?i_address:32'h0;
	assign master.ARLEN = (read_state == 3)?8'd3:0;
	assign master.ARBURST = (read_state == 3)?2'b10:2'b01;
	assign master.ARSIZE = 3'd2;
	assign master.RREADY = (read_state == 2 || read_state ==4);
	
	assign master.AWVALID = (write_state == 1 || write_state == 4);
	assign master.AWADDR = (master.AWVALID)?i_address:{32{1'b0}};
	assign master.AWLEN = 0;
	assign master.AWSIZE = 2;
	
	assign master.WVALID = (write_state == 2 || write_state == 5)?1'b1:1'b0;
	assign master.WDATA = (write_state == 2 || write_state == 5)?i_write_data:{32{1'b0}};
	assign master.WLAST = (write_state == 2 || write_state == 5)?1'b1:1'b0;
	assign master.WSTRB = (write_state == 2 || write_state == 5)?i_byte_enable:4'b0;

	assign master.BREADY = (write_state == 3 || write_state == 6);
	
	assign core_read_request    = sel_wb && !i_write_enable;
	assign core_write_request   = sel_wb &&  i_write_enable;
	

//	assign cache_read_request   = i_cache_req && !i_write_enable;
//	assign cache_write_request  = i_cache_req &&  i_write_enable;
	

endmodule

