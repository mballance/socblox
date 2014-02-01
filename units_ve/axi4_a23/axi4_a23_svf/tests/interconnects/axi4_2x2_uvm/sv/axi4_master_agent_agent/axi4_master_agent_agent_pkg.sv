/****************************************************************************
 * axi4_master_agent_pkg.sv
 ****************************************************************************/

/**
 * Package: axi4_master_agent_agent_pkg
 * 
 * TODO: Add package documentation
 */
`include "uvm_macros.svh" 
package axi4_master_agent_agent_pkg;
	import uvm_pkg::*;

	`include "axi4_master_agent_config.svh"
	`include "axi4_master_agent_seq_item.svh"
	`include "axi4_master_agent_driver.svh"
	`include "axi4_master_agent_monitor.svh"
	`include "axi4_master_agent_seq_base.svh"
	`include "axi4_master_agent_agent.svh"	
	
endpackage

