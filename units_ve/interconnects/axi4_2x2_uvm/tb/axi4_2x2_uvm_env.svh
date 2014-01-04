/****************************************************************************
 * axi4_2x2_uvm_env.svh
 ****************************************************************************/

/**
 * Class: axi4_2x2_uvm_env
 * 
 * TODO: Add class documentation
 */
class axi4_2x2_uvm_env extends uvm_env;
	`uvm_component_utils(axi4_2x2_uvm_env)
	
	axi4_master_agent_agent					m_axi4_master_agent;

	function new(string name, uvm_component parent=null);
		super.new(name, parent);
	endfunction
	
	
	function void build_phase(uvm_phase phase);
		axi4_master_agent_config axi4_master_agent_cfg = axi4_master_agent_config::type_id::create();
	
		uvm_config_db #(axi4_master_agent_config)::set(this, "*", 
				"axi4_master_agent_config", axi4_master_agent_cfg);
		
		m_axi4_master_agent = axi4_master_agent_agent::type_id::create("m_axi4_master_agent", this);
	endfunction
	

endclass

