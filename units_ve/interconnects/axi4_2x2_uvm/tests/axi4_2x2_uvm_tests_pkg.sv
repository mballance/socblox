/****************************************************************************
 * axi4_2x2_uvm_tests_pkg.sv
 ****************************************************************************/

/**
 * Package: axi4_2x2_uvm_tests_pkg
 * 
 * TODO: Add package documentation
 */
`include "uvm_macros.svh" 
package axi4_2x2_uvm_tests_pkg;
	import uvm_pkg::*;
	import axi4_master_agent_agent_pkg::*;
	import axi4_2x2_uvm_env_pkg::*;
	import axi4_2x2_uvm_stim_types_pkg::*;
	import axi4_2x2_uvm_stim_seqs_pkg::*;
	
	`include "axi4_2x2_uvm_base_test.svh"
	`include "axi4_2x2_uvm_axi4_master_agent_test.svh"

endpackage

