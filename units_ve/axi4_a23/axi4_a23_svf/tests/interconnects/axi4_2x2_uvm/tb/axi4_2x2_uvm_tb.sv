/****************************************************************************
 * axi4_2x2_uvm_tb.sv
 ****************************************************************************/

/**
 * Module: tb
 * 
 * TODO: Add module documentation
 */
`include "uvm_macros.svh" 
module axi4_2x2_uvm_tb;
	import uvm_pkg::*;
	import axi4_2x2_uvm_env_pkg::*;
	import axi4_2x2_uvm_tests_pkg::*;
	
	localparam AXI4_ADDRESS_WIDTH = 32;
	localparam AXI4_DATA_WIDTH = 32;
	localparam AXI4_ID_WIDTH = 4;
	
	reg 			clk = 0;
	reg 			rstn = 0;


	initial begin
		repeat (100) begin
			#1ns;
			clk <= 1;
			#1ns;
			clk <= 0;
		end
		
		rstn = 1;
		
		forever begin
			#1ns;
			clk <= 1;
			#1ns;
			clk <= 0;
		end
	end
	
	axi4_if #(
			.AXI4_ADDRESS_WIDTH(AXI4_ADDRESS_WIDTH),
			.AXI4_DATA_WIDTH(AXI4_DATA_WIDTH),
			.AXI4_ID_WIDTH(AXI4_ID_WIDTH)
			)
		m02ic(
			.ACLK(clk),
			.ARESETn(rstn)
			),
		m12ic(
			.ACLK(clk),
			.ARESETn(rstn)
			)
		;
	
	axi4_uvm_master_bfm #(
			.AXI4_ADDRESS_WIDTH(AXI4_ADDRESS_WIDTH),
			.AXI4_DATA_WIDTH(AXI4_DATA_WIDTH),
			.AXI4_ID_WIDTH(AXI4_ID_WIDTH))
		m0(
			.clk(clk),
			.rstn(rstn),
			.master(m02ic.master)
			),
		m1(
			.clk(clk),
			.rstn(rstn),
			.master(m12ic.master)
			)
		;
		
	axi4_if #(
			.AXI4_ADDRESS_WIDTH(AXI4_ADDRESS_WIDTH),
			.AXI4_DATA_WIDTH(AXI4_DATA_WIDTH),
			.AXI4_ID_WIDTH(AXI4_ID_WIDTH+1)
			)
		ic2s0(
			.ACLK(clk),
			.ARESETn(rstn)
			),
		ic2s1(
			.ACLK(clk),
			.ARESETn(rstn)
			)
		;
	
		
	axi4_interconnect_2x2 #(
		.AXI4_ADDRESS_WIDTH  (AXI4_ADDRESS_WIDTH), 
		.AXI4_DATA_WIDTH     (AXI4_DATA_WIDTH	), 
		.AXI4_ID_WIDTH       (AXI4_ID_WIDTH		), 
		.SLAVE0_ADDR_BASE    ('h00000000		), 
		.SLAVE0_ADDR_LIMIT   ('h00000fff		), 
		.SLAVE1_ADDR_BASE    ('h00001000		), 
		.SLAVE1_ADDR_LIMIT   ('h00001fff		)
		) axi4_interconnect_2x2 (
		.clk                 (clk                ), 
		.rstn                (rstn               ), 
		.m0                  (m02ic.slave        ), 
		.m1                  (m12ic.slave        ), 
		.s0                  (ic2s0.master       ), 
		.s1                  (ic2s1.master       ));		
	
	initial begin
		typedef virtual axi4_uvm_master_bfm #(
			.AXI4_ADDRESS_WIDTH(AXI4_ADDRESS_WIDTH),
			.AXI4_DATA_WIDTH(AXI4_DATA_WIDTH),
			.AXI4_ID_WIDTH(AXI4_ID_WIDTH)) bfm_vif_t;
		
		uvm_config_db #(bfm_vif_t)::set(null, ", field_name, value)
		run_test();
	end


endmodule

