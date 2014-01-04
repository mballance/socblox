/****************************************************************************
 * axi4_2x2_uvm_stim_seqs_pkg.sv
 ****************************************************************************/

/**
 * Package: axi4_2x2_uvm_stim_seqs_pkg
 * 
 * TODO: Add package documentation
 */
`include "uvm_macros.svh" 
package axi4_2x2_uvm_stim_seqs_pkg;
	import uvm_pkg::*;
	import axi4_master_agent_agent_pkg::*;
	import axi4_2x2_uvm_stim_types_pkg::*;

	// Include special-purpose sequences here
	`include "axi4_master_agent_rand_seq.svh"

endpackage

