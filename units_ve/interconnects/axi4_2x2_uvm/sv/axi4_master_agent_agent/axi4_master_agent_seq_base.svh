

class axi4_master_agent_seq_base extends uvm_sequence #(axi4_master_agent_seq_item);
	`uvm_object_utils(axi4_master_agent_seq_base);
	
	static const string report_id = "axi4_master_agent_seq_base";
	
	function new(string name="axi4_master_agent_seq_base");
		super.new(name);
	endfunction
	
	task body();
		`uvm_error(report_id, "base-class body task not overridden");
	endtask
	
endclass



