

class axi4_uvm_master_seq_base extends uvm_sequence #(axi4_uvm_master_seq_item);
	`uvm_object_utils(axi4_uvm_master_seq_base);
	
	static const string report_id = "axi4_uvm_master_seq_base";
	
	function new(string name="axi4_uvm_master_seq_base");
		super.new(name);
	endfunction
	
	task body();
		`uvm_error(report_id, "base-class body task not overridden");
	endtask
	
endclass



