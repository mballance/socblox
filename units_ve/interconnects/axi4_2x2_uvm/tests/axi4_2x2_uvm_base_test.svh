/****************************************************************************
 * axi4_2x2_uvm_base_test.svh
 ****************************************************************************/

/**
 * Class: axi4_2x2_uvm_base_test
 * 
 * TODO: Add class documentation
 */
class axi4_2x2_uvm_base_test extends uvm_test;
	`uvm_component_utils(axi4_2x2_uvm_base_test)
	
	axi4_2x2_uvm_env					m_env;

	function new(string name, uvm_component parent=null);
		super.new(name, parent);
	endfunction
	
	function void build_phase(uvm_phase phase);
		m_env = axi4_2x2_uvm_env::type_id::create("m_env", this);
		
	endfunction


endclass

