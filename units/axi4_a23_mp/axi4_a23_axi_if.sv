//////////////////////////////////////////////////////////////////
//                                                              //
//  AXI4 master interface for the Amber core                	//
//                                                              //
//  This file is part of the Amber project                      //
//  http://www.opencores.org/project,amber                      //
//                                                              //
//  Description                                                 //
//  Turns memory access requests from the execute stage and     //
//  cache into wishbone bus cycles. For 4-word read requests    //
//  from the cache and swap accesses ( read followed by write   //
//  to the same address) from the execute stage,                //
//  a block transfer is done. All other requests result in      //
//  single word transfers.                                      //
//                                                              //
//  Write accesses can be done in a single clock cycle on       //
//  the wishbone bus, is the destination allows it. The         //
//  next transfer will begin immediately on the                 //
//  next cycle on the bus. This looks like a block transfer     //
//  and does hold ownership of the wishbone bus, preventing     //
//  the other master ( the ethernet MAC) from gaining           //
//  ownership between those two cycles. But otherwise it would  //
//  be necessary to insert a wait cycle after every write,      //
//  slowing down the performance of the core by around 5 to     //
//  10%.                                                        //
//                                                              //
//  Author(s):                                                  //
//      - Conor Santifort, csantifort.amber@gmail.com           //
//      - Matthew Ballance, matt.ballance@gmail.com				//
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


module axi4_a23_axi_if
(
input                       i_clk,
input						i_rstn,

// Core Accesses to Wishbone bus
input                       i_select,
output						o_ack,
output						o_dabt,
input       [31:0]          i_write_data,
input                       i_write_enable,
input       [3:0]           i_byte_enable,    // valid for writes only
input                       i_data_access,
input                       i_exclusive,      // high for read part of swap access
input       [31:0]          i_address,
output                      o_stall,

// Cache Accesses to Wishbone bus
input                       i_cache_req,

// Indicates that data is not ready for the cache
output						o_stall_cache,

axi4_if.master				master
);

	
wire                        core_read_request;
wire                        core_write_request;
wire                        cache_read_request;
wire                        cache_write_request;
/* reg                         servicing_cache = 'd0; */
/* reg                         exclusive_access = 'd0; */
wire                        read_ack, write_ack;
wire                        cache_read_ack, cache_write_ack;



	// Write buffer
	/*
	reg     [31:0]          wbuf_addr_r = 'd0;
	reg     [3:0]           wbuf_sel_r  = 'd0;
	 */
	reg                     wbuf_busy_r = 'd0;

//	reg						data_valid = 0;


	

	
	assign read_ack = (read_state == 2 && master.RVALID && master.RREADY);
	assign cache_read_ack = (read_state == 4 && master.RVALID && master.RREADY);
	assign write_ack = (write_state == 3 && master.BREADY && master.BVALID);
	assign cache_write_ack = (write_state == 6 && master.BREADY && master.BVALID);
	
	wire cache_read_stall = ((read_state == 3 || read_state == 4) && ~cache_read_ack);
	
	assign o_stall_cache = (
//		(cache_read_request && ~cache_read_ack) ||
		cache_read_stall ||
		(cache_write_request && ~cache_write_ack)
		);
	
//	assign core_read_request    = i_select && !i_write_enable;
//	assign core_write_request   = i_select &&  i_write_enable;
	
	// o_stall is for the core
	assign o_stall = 
		( core_read_request  && !read_ack )			|| 
		/*
		( core_read_request  && servicing_cache ) ||
		( core_write_request && servicing_cache ) || */
		( core_write_request && !write_ack) ||
		( cache_write_request && !cache_write_ack) || 
		wbuf_busy_r
		;	
	
	assign o_ack =
		( core_read_request && read_ack) ||
		( core_write_request && write_ack) ||
		( cache_write_request && cache_write_ack);
	
	assign master.ARVALID = (read_state == 1 || read_state == 3);
	assign master.ARADDR = (master.ARVALID)?i_address:32'h0;
	assign master.ARLEN = (read_state == 3)?8'd3:0;
	assign master.ARBURST = (read_state == 3)?2'b10:2'b01;
	assign master.ARSIZE = 3'd2;
	assign master.RREADY = (read_state == 2 || read_state ==4);
	assign master.ARPROT = {~i_data_access, 1'b0, 1'b0};
	
	assign master.AWVALID = (write_state == 1 || write_state == 4);
	assign master.AWADDR = (master.AWVALID)?i_address:{32{1'b0}};
	assign master.AWLEN = 0;
	assign master.AWSIZE = 2;
	
	assign master.WVALID = (write_state == 2 || write_state == 5)?1'b1:1'b0;
	assign master.WDATA = (write_state == 2 || write_state == 5)?i_write_data:{32{1'b0}};
	assign master.WLAST = (write_state == 2 || write_state == 5)?1'b1:1'b0;
	assign master.WSTRB = (write_state == 2 || write_state == 5)?i_byte_enable:4'b0;
	

	assign master.BREADY = (write_state == 3 || write_state == 6);
	
	assign core_read_request    = i_select && !i_write_enable;
	assign core_write_request   = i_select &&  i_write_enable;

	assign cache_read_request   = i_cache_req && !i_write_enable;
	assign cache_write_request  = i_cache_req &&  i_write_enable;
	
	// ======================================
	// Write buffer
	// ======================================
	/*
	always @( posedge i_clk ) begin
		if ( wb_wait && !wbuf_busy_r && (core_write_request || cache_write_request) )
		begin
			wbuf_addr_r <= i_address;
			wbuf_sel_r  <= i_byte_enable;
			wbuf_busy_r <= 1'd1;
		end else if (!o_wb_stb) begin
			wbuf_busy_r <= 1'd0;	
		end
	end
	 */
	

endmodule

