/****************************************************************************
 * agent_test.svh
 ****************************************************************************/

/**
 * Class: agent_test
 * 
 * TODO: Add class documentation
 */
class axi4_2x2_uvm_axi4_master_agent_test extends axi4_2x2_uvm_base_test;
	`uvm_component_utils(axi4_2x2_uvm_axi4_master_agent_test)

	function new(string name, uvm_component parent=null);
		super.new(name, parent);
	endfunction

	task main_phase(uvm_phase phase);
		axi4_master_agent_seq_base seq;
		phase.raise_objection(this);
		
		seq = axi4_master_agent_seq_base::type_id::create();
		seq.start(m_env.m_axi4_master_agent.m_seqr);
		
		phase.drop_objection(this);
	endtask

endclass

