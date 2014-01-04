/****************************************************************************
 * axi4_uvm_master_bfm.sv
 ****************************************************************************/

/**
 * Interface: axi4_uvm_master_bfm
 * 
 * TODO: Add interface documentation
 */
`include "uvm_macros.svh"
interface axi4_uvm_master_bfm #(
		parameter int AXI4_ADDRESS_WIDTH=32,
		parameter int AXI4_DATA_WIDTH=32,
		parameter int AXI4_ID_WIDTH=4,
		parameter int AXI4_REGION_MAP_SIZE=16,
		parameter int AXI4_USER_WIDTH=4,
		parameter string UVM_REGISTRATION_INDEX=""
	)
	(
		input				clk,
		input				rstn,
		axi4_if.master		master
	);
	import uvm_pkg::*;
	import mvc_pkg::*;
	import mgc_axi4_v1_0_pkg::*;
	
	typedef virtual mgc_axi4 #(
		AXI4_ADDRESS_WIDTH,
		AXI4_DATA_WIDTH,
		AXI4_DATA_WIDTH,
		AXI4_ID_WIDTH,
		AXI4_USER_WIDTH,
		AXI4_REGION_MAP_SIZE
		) mgc_axi4_vif_t;	
	
	mgc_axi4	#(
			.AXI4_ADDRESS_WIDTH(AXI4_ADDRESS_WIDTH),
			.AXI4_RDATA_WIDTH(AXI4_DATA_WIDTH),
			.AXI4_WDATA_WIDTH(AXI4_DATA_WIDTH),
			.AXI4_ID_WIDTH(AXI4_ID_WIDTH),
			.AXI4_REGION_MAP_SIZE(AXI4_REGION_MAP_SIZE)
			) bfm (
			.iACLK(clk), 
			.iARESETn(rstn)
			);	

	// Write Address
	assign master.AWADDR = bfm.AWADDR;
	assign master.AWBURST = bfm.AWBURST;
	assign master.AWCACHE = bfm.AWCACHE;
	assign master.AWID = bfm.AWID;
	assign master.AWLEN = bfm.AWLEN;
	assign master.AWPROT = bfm.AWPROT;
	assign master.AWQOS = bfm.AWQOS;
	assign bfm.AWREADY = master.AWREADY;
	assign master.AWREGION = bfm.AWREGION;
	assign master.AWSIZE = bfm.AWSIZE;
	assign master.AWVALID = bfm.AWVALID;
	
		// Write Data
	assign master.WDATA = bfm.WDATA;
	assign master.WSTRB = bfm.WSTRB;
	assign master.WLAST = bfm.WLAST;
	assign master.WVALID = bfm.WVALID;
	assign bfm.WREADY = master.WREADY;
	
		// Write Response
	assign bfm.BID = master.BID;
	assign bfm.BRESP = master.BRESP;
	assign bfm.BVALID = master.BVALID;
	assign master.BREADY = bfm.BREADY;
	assign bfm.BUSER = 0; // Stub out unused

		// Read address
	assign master.ARADDR = bfm.ARADDR;
	assign master.ARBURST = bfm.ARBURST;
	assign master.ARCACHE = bfm.ARCACHE;
	assign master.ARID = bfm.ARID;
	assign master.ARLEN = bfm.ARLEN;
	assign master.ARPROT = bfm.ARPROT;
	assign bfm.ARREADY = master.ARREADY;
	assign master.ARREGION = bfm.ARREGION;
	assign master.ARSIZE = bfm.ARSIZE;
	assign master.ARVALID = bfm.ARVALID;
	
		// Read Data
	assign bfm.RID = master.RID;
	assign bfm.RDATA = master.RDATA;
	assign bfm.RRESP = master.RRESP;
	assign bfm.RLAST = master.RLAST;
	assign bfm.RVALID = master.RVALID;
	assign master.RREADY = bfm.RREADY;
	assign bfm.RUSER = 0; // Stub out unused
	
	typedef axi4_master_rw_transaction #(
		.AXI4_ADDRESS_WIDTH(AXI4_ADDRESS_WIDTH),
		.AXI4_RDATA_WIDTH(AXI4_DATA_WIDTH),
		.AXI4_WDATA_WIDTH(AXI4_DATA_WIDTH),
		.AXI4_ID_WIDTH(AXI4_ID_WIDTH),
		.AXI4_USER_WIDTH(AXI4_USER_WIDTH),
		.AXI4_REGION_MAP_SIZE(AXI4_REGION_MAP_SIZE)
		) rw_item_t;
	
	class axi4_seq extends mvc_sequence;
		rw_item_t				item;

		task body();
			start_item(item);
			finish_item(item);
		endtask
	endclass
	
	class axi4_connector extends uvm_component;
		`uvm_component_utils(axi4_connector)
		
		typedef axi4_vip_config #(
			AXI4_ADDRESS_WIDTH, 
			AXI4_DATA_WIDTH,
			AXI4_DATA_WIDTH, 
			AXI4_ID_WIDTH,
			4,
			AXI4_REGION_MAP_SIZE) axi_config_t;	
		
		
		mvc_agent					m_agent;
		axi_config_t				m_config;
		
		function new(string name, uvm_component parent=null);
			super.new(name, parent);
		endfunction
	
		/**
		 * Function: build_phase
		 *
		 * Override from class 
		 */
		virtual function void build_phase(input uvm_phase phase);
			mgc_axi4_vif_t axi4_if;
			
			m_config = axi_config_t::type_id::create("m_config");
			m_agent = mvc_agent::type_id::create("m_agent", this);
			
			if (!uvm_config_db #(mgc_axi4_vif_t)::get(this, "", "AXI_VIF", m_config.m_bfm)) begin
				$display("FATAL");
			end
			
			uvm_config_db #(uvm_object)::set(this, "m_agent*", 
					mvc_config_base_id, m_config);
		
			axi4_if = m_config.m_bfm;
			axi4_if.axi4_set_master_abstraction_level(0, 1);
			axi4_if.axi4_set_slave_abstraction_level(1, 0);
			axi4_if.axi4_set_clock_source_abstraction_level(1, 0);
			axi4_if.axi4_set_reset_source_abstraction_level(1, 0);
			m_config.m_warn_on_uninitialized_read = 1'b0;

		endfunction

		/**
		 * Function: connect_phase
		 *
		 * Override from class 
		 */
		virtual function void connect_phase(input uvm_phase phase);

		endfunction
		
	endclass
	
	axi4_connector connector;
	
	task write32(
		longint unsigned			addr,
		int unsigned				data);
		automatic axi4_seq seq = new();
		automatic rw_item_t				item = rw_item_t::type_id::create();
		
		assert(item.randomize() with {
				item.addr == addr;
				item.read_or_write == AXI4_TRANS_WRITE;
				item.burst == AXI4_INCR;
				item.burst_length == 0;
				item.size == AXI4_BYTES_4;
				item.lock == AXI4_NORMAL;
				});
		item.wdata_words[0] = data; // TODO:

		seq.item = item;
		
		seq.start(connector.m_agent.m_sequencer);
	endtask
	
	task read32(
		longint unsigned			addr,
		output int unsigned			data);
		automatic axi4_seq seq = new();
		automatic rw_item_t				item = rw_item_t::type_id::create();
		
		assert(item.randomize() with {
				item.addr == addr;
				item.read_or_write == AXI4_TRANS_READ;
				item.burst == AXI4_INCR;
				item.burst_length == 0;
				item.size == AXI4_BYTES_4;
				item.lock == AXI4_NORMAL;
				});

		seq.item = item;
		
		seq.start(connector.m_agent.m_sequencer);
		
		data = item.rdata_words[0]; // TODO:
	endtask
	
	
	initial begin
		connector = new("connector", null);
	
		uvm_config_db #(mgc_axi4_vif_t)::set(connector, "*", "AXI_VIF", bfm);
	end

	


endinterface

