

class axi4_uvm_master_monitor extends uvm_monitor;

	uvm_analysis_port #(axi4_uvm_master_seq_item)			ap;
	
	axi4_uvm_master_config									m_cfg;
	
	const string report_id = "axi4_uvm_master_monitor";
	
	`uvm_component_utils(axi4_uvm_master_monitor)
	
	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	
		// Obtain the config object
		m_cfg = axi4_uvm_master_config::get_config(this);
	
		// Create the analysis port
		ap = new("ap", this);

	endfunction
	
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
	endfunction
	
	task run_phase(uvm_phase phase);
		// TODO: implement axi4_uvm_master_monitor run_phase
	endtask
	
	
endclass


