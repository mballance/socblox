/****************************************************************************
 * axi4_master_agent_rand_seq.svh
 ****************************************************************************/

/**
 * Class: axi4_master_agent_rand_seq
 * 
 * TODO: Add class documentation
 */
class axi4_master_agent_rand_seq extends axi4_master_agent_seq_base;
	`uvm_object_utils(axi4_master_agent_rand_seq)

	task body();
		int count = 10;
		axi4_master_agent_seq_item item;
	
		repeat (count) begin
			
			item = axi4_master_agent_seq_item::type_id::create();
			
			start_item(item);
			assert(item.randomize());
			finish_item(item);
		end
	endtask

endclass

