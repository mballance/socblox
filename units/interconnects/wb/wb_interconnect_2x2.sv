/****************************************************************************
 * wb_interconnect_2x2.sv
 ****************************************************************************/

/**
 * Module: wb_interconnect_2x2
 * 
 * TODO: Add module documentation
 */
module wb_interconnect_2x2 #(
		parameter int WB_ADDR_WIDTH=32,
		parameter int WB_DATA_WIDTH=32,
		parameter bit[WB_ADDR_WIDTH-1:0] SLAVE0_ADDR_BASE='h0,
		parameter bit[WB_ADDR_WIDTH-1:0] SLAVE0_ADDR_LIMIT='h0,
		parameter bit[WB_ADDR_WIDTH-1:0] SLAVE1_ADDR_BASE='h0,
		parameter bit[WB_ADDR_WIDTH-1:0] SLAVE1_ADDR_LIMIT='h0
		) (
		input						clk,
		input						rstn,
		wb_if.slave					m0,
		wb_if.slave					m1,
		wb_if.master					s0,
		wb_if.master					s1
		);
	
	localparam int WB_DATA_MSB = (WB_DATA_WIDTH-1);
//	localparam int AXI4_WSTRB_MSB = (AXI4_DATA_WIDTH/8)-1;
	localparam int N_MASTERS = 2;
	localparam int N_SLAVES = 2;
	localparam int N_MASTERID_BITS = (N_MASTERS>1)?$clog2(N_MASTERS):1;
	localparam int N_SLAVEID_BITS = $clog2(N_SLAVES+1);
	localparam bit[N_SLAVEID_BITS:0]		NO_SLAVE  = {(N_SLAVEID_BITS+1){1'b1}};
	localparam bit[N_MASTERID_BITS:0]		NO_MASTER = {(N_MASTERID_BITS+1){1'b1}};
	
	// Interface to the decode-fail slave
	wb_if				serr();
	
	function reg[N_SLAVEID_BITS-1:0] addr2slave(
		reg[N_MASTERID_BITS-1:0]	master,
		reg[WB_ADDR_WIDTH-1:0] 		addr
		);
		if (addr >= SLAVE0_ADDR_BASE && addr <= SLAVE0_ADDR_LIMIT) begin
			return 0;
		end
		if (addr >= SLAVE1_ADDR_BASE && addr <= SLAVE1_ADDR_LIMIT) begin
			return 1;
		end
		
		return (2);
	endfunction
	
	wire[WB_ADDR_WIDTH-1:0]						ADR[N_MASTERS-1:0];
	wire[2:0]									CTI[N_MASTERS-1:0];
	wire[1:0]									BTE[N_MASTERS-1:0];
	wire[WB_DATA_WIDTH-1:0]						DAT_W[N_MASTERS-1:0];
	wire[WB_DATA_WIDTH-1:0]						DAT_R[N_MASTERS-1:0];
	wire										CYC[N_MASTERS-1:0];
	wire										ERR[N_MASTERS-1:0];
	wire[(WB_DATA_WIDTH/8)-1:0]					SEL[N_MASTERS-1:0];
	wire										STB[N_MASTERS-1:0];
	wire										ACK[N_MASTERS-1:0];
	wire										WE[N_MASTERS-1:0];
	
	wire[WB_ADDR_WIDTH-1:0]						SADR[N_SLAVES:0];
	wire[2:0]									SCTI[N_SLAVES:0];
	wire[1:0]									SBTE[N_SLAVES:0];
	wire[WB_DATA_WIDTH-1:0]						SDAT_W[N_SLAVES:0];
	wire[WB_DATA_WIDTH-1:0]						SDAT_R[N_SLAVES:0];
	wire										SCYC[N_SLAVES:0];
	wire										SERR[N_SLAVES:0];
	wire[(WB_DATA_WIDTH/8)-1:0]					SSEL[N_SLAVES:0];
	wire										SSTB[N_SLAVES:0];
	wire										SACK[N_SLAVES:0];
	wire										SWE[N_SLAVES:0];
	
	// master assigns
	assign ADR[0] = m0.ADR;
	assign ADR[1] = m1.ADR;
	assign CTI[0] = m0.CTI;
	assign CTI[1] = m1.CTI;
	assign BTE[0] = m0.BTE;
	assign BTE[1] = m1.BTE;
	assign DAT_W[0] = m0.DAT_W;
	assign DAT_W[1] = m1.DAT_W;
	assign CYC[0] = m0.CYC;
	assign CYC[1] = m1.CYC;
	assign SEL[0] = m0.SEL;
	assign SEL[1] = m1.SEL;
	assign STB[0] = m0.STB;
	assign STB[1] = m1.STB;
	assign WE[0] = m0.WE;
	assign WE[1] = m1.WE;
	assign m0.DAT_R = DAT_R[0];
	assign m1.DAT_R = DAT_R[1];
	assign m0.ERR = ERR[0];
	assign m1.ERR = ERR[1];
	assign m0.ACK = ACK[0];
	assign m1.ACK = ACK[1];

	
	// Slave requests
	assign SDAT_R[0] = s0.DAT_R;
	assign SDAT_R[1] = s1.DAT_R;
	assign SDAT_R[2] = serr.DAT_R;
	assign SERR[0] = s0.ERR;
	assign SERR[1] = s1.ERR;
	assign SERR[2] = serr.ERR;
	assign SACK[0] = s0.ACK;
	assign SACK[1] = s1.ACK;
	assign SACK[2] = serr.ACK;
	assign s0.ADR = SADR[0];
	assign s1.ADR = SADR[1];
	assign serr.ADR = SADR[2];
	assign s0.CTI = SCTI[0];
	assign s1.CTI = SCTI[1];
	assign serr.CTI = SCTI[2];
	assign s0.BTE = SBTE[0];
	assign s1.BTE = SBTE[1];
	assign serr.BTE = SBTE[2];
	assign s0.DAT_W = SDAT_W[0];
	assign s1.DAT_W = SDAT_W[1];
	assign serr.DAT_W = SDAT_W[2];
	assign s0.CYC = SCYC[0];
	assign s1.CYC = SCYC[1];
	assign serr.CYC = SCYC[2];
	assign s0.SEL = SSEL[0];
	assign s1.SEL = SSEL[1];
	assign serr.SEL = SSEL[2];
	assign s0.STB = SSTB[0];
	assign s1.STB = SSTB[1];
	assign serr.STB = SSTB[2];
	assign s0.WE = SWE[0];
	assign s1.WE = SWE[1];
	assign serr.WE = SWE[2];


/*
	assign SWREADY[0] = s0.WREADY;
	assign SWREADY[1] = s1.WREADY;
	assign SWREADY[2] = serr.WREADY;
	assign s0.WDATA = SWDATA[0];
	assign s1.WDATA = SWDATA[1];
	assign serr.WDATA = SWDATA[2];
	assign s0.WSTRB = SWSTRB[0];
	assign s1.WSTRB = SWSTRB[1];
	assign serr.WSTRB = SWSTRB[2];
	assign s0.WLAST = SWLAST[0];
	assign s1.WLAST = SWLAST[1];
	assign serr.WLAST = SWLAST[2];
	assign s0.WVALID = SWVALID[0];
	assign s1.WVALID = SWVALID[1];
	assign serr.WVALID = SWVALID[2];


	assign SBID[0] = s0.BID;
	assign SBID[1] = s1.BID;
	assign SBID[2] = serr.BID;
	assign SBRESP[0] = s0.BRESP;
	assign SBRESP[1] = s1.BRESP;
	assign SBRESP[2] = serr.BRESP;
	assign SBVALID[0] = s0.BVALID;
	assign SBVALID[1] = s1.BVALID;
	assign SBVALID[2] = serr.BVALID;
	assign s0.BREADY = SBREADY[0];
	assign s1.BREADY = SBREADY[1];
	assign serr.BREADY = SBREADY[2];
	
 
 */

// Read request state machine
	bit[3:0]									read_req_state[N_MASTERS-1:0];
	reg[N_SLAVEID_BITS:0]						read_selected_slave[N_MASTERS-1:0];

	/*
// Read request
${AR_MASTER_ASSIGN}	
	
${R_MASTER_ASSIGN}	
	
	// Slave requests
	assign SARREADY[0] = s0.ARREADY;
	assign SARREADY[1] = s1.ARREADY;
	assign SARREADY[2] = serr.ARREADY;
	assign s0.ARADDR = SARADDR[0];
	assign s1.ARADDR = SARADDR[1];
	assign serr.ARADDR = SARADDR[2];
	assign s0.ARID = SARID[0];
	assign s1.ARID = SARID[1];
	assign serr.ARID = SARID[2];
	assign s0.ARLEN = SARLEN[0];
	assign s1.ARLEN = SARLEN[1];
	assign serr.ARLEN = SARLEN[2];
	assign s0.ARSIZE = SARSIZE[0];
	assign s1.ARSIZE = SARSIZE[1];
	assign serr.ARSIZE = SARSIZE[2];
	assign s0.ARBURST = SARBURST[0];
	assign s1.ARBURST = SARBURST[1];
	assign serr.ARBURST = SARBURST[2];
	assign s0.ARCACHE = SARCACHE[0];
	assign s1.ARCACHE = SARCACHE[1];
	assign serr.ARCACHE = SARCACHE[2];
	assign s0.ARPROT = SARPROT[0];
	assign s1.ARPROT = SARPROT[1];
	assign serr.ARPROT = SARPROT[2];
	assign s0.ARREGION = SARREGION[0];
	assign s1.ARREGION = SARREGION[1];
	assign serr.ARREGION = SARREGION[2];
	assign s0.ARVALID = SARVALID[0];
	assign s1.ARVALID = SARVALID[1];
	assign serr.ARVALID = SARVALID[2];
	

	assign SRDATA[0] = s0.RDATA;
	assign SRDATA[1] = s1.RDATA;
	assign SRDATA[2] = serr.RDATA;
	assign SRLAST[0] = s0.RLAST;
	assign SRLAST[1] = s1.RLAST;
	assign SRLAST[2] = serr.RLAST;
	assign SRVALID[0] = s0.RVALID;
	assign SRVALID[1] = s1.RVALID;
	assign SRVALID[2] = serr.RVALID;
	assign SRID[0] = s0.RID;
	assign SRID[1] = s1.RID;
	assign SRID[2] = serr.RID;
	assign s0.RREADY = SRREADY[0];
	assign s1.RREADY = SRREADY[1];
	assign serr.RREADY = SRREADY[2];
	

 */

	
	// Master state machine
	reg[2:0]						master_state[N_MASTERS-1:0];
	reg[3:0]						master_selected_slave[N_MASTERS-1:0];
	wire							master_gnt[N_SLAVES:0];
	wire[$clog2(N_MASTERS)-1:0]		master_gnt_id[N_SLAVES:0];
	wire[N_MASTERS-1:0]				master_slave_req[N_SLAVES:0];
	
	generate
		genvar m_i;
		for (m_i=0; m_i<N_MASTERS; m_i++) begin
			always @(posedge clk) begin
				if (rstn == 0) begin
					master_state[m_i] <= 0;
					master_selected_slave[m_i] <= NO_SLAVE;
				end else begin
					case (master_state[m_i])
						0: begin
							if (CYC[m_i] && STB[m_i]) begin
								master_state[m_i] <= 1;
								master_selected_slave[m_i] <= addr2slave(m_i, ADR[m_i]);
							end
						end
						
						1: begin
							// Wait for the addressed slave to acknowledge
							if (CYC[m_i] && STB[m_i] && ACK[m_i]) begin
								master_state[m_i] <= 0;
								master_selected_slave[m_i] <= NO_SLAVE;
							end
						end
					endcase
				end
			end
		end
	endgenerate

	// Build the req vector for each slave
	generate
		genvar m_req_i, m_req_j;

		for (m_req_i=0; m_req_i < N_SLAVES; m_req_i++) begin
			for (m_req_j=0; m_req_j < N_MASTERS; m_req_j++) begin
				assign master_slave_req[m_req_i][m_req_j] = (master_selected_slave[m_req_j] == m_req_i);
			end
		end
	endgenerate

	generate
		genvar s_arb_i;
		
		for (s_arb_i=0; s_arb_i<(N_SLAVES+1); s_arb_i++) begin : s_arb
			wb_interconnect_2x2_arbiter #(
				.N_REQ  (N_MASTERS)
				) 
				aw_arb (
					.clk    (clk   ), 
					.rstn   (rstn  ), 
					.req    (master_slave_req[s_arb_i]), 
					.gnt    (master_gnt[s_arb_i]),
					.gnt_id	(master_gnt_id[s_arb_i])
				);
		end
	endgenerate

	wire[N_MASTERID_BITS:0]					slave_active_master[N_SLAVES:0];

	generate
		genvar s_am_i;
		
		for (s_am_i=0; s_am_i<N_SLAVES+1; s_am_i++) begin
			assign slave_active_master[s_am_i] =
				(master_gnt[s_am_i])?master_gnt_id[s_am_i]:NO_MASTER;
		end
	endgenerate
`ifdef UNDEFINED	
`endif		
	
		// WB signals from slave back to master
	generate
		genvar s2m_i;
		
		for (s2m_i=0; s2m_i<N_MASTERS; s2m_i++) begin
			assign DAT_R[s2m_i] = (master_selected_slave[s2m_i] != NO_SLAVE && 
										master_gnt[master_selected_slave[s2m_i]] && 
										master_gnt_id[master_selected_slave[s2m_i]] == s2m_i)?
										SDAT_R[master_selected_slave[s2m_i]]:0;
			assign ERR[s2m_i] = (master_selected_slave[s2m_i] != NO_SLAVE && 
										master_gnt[master_selected_slave[s2m_i]] && 
										master_gnt_id[master_selected_slave[s2m_i]] == s2m_i)?
										SERR[master_selected_slave[s2m_i]]:0;
			assign ACK[s2m_i] = (master_selected_slave[s2m_i] != NO_SLAVE && 
										master_gnt[master_selected_slave[s2m_i]] && 
										master_gnt_id[master_selected_slave[s2m_i]] == s2m_i)?
										SACK[master_selected_slave[s2m_i]]:0;
		end
	endgenerate

`ifdef UNDEFINED		
	generate
		genvar s2m_i;
		for(s2m_i=0; s2m_i<(N_SLAVES+1); s_w_i++) begin
			assign SWDATA[s_w_i] = (slave_active_master[s_w_i] == NO_MASTER)?0:WDATA[slave_active_master[s_w_i]];
			assign SWSTRB[s_w_i] = (slave_active_master[s_w_i] == NO_MASTER)?0:WSTRB[slave_active_master[s_w_i]];
			assign SWLAST[s_w_i] = (slave_active_master[s_w_i] == NO_MASTER)?0:WLAST[slave_active_master[s_w_i]];
			assign SWVALID[s_w_i] = (slave_active_master[s_w_i] == NO_MASTER)?0:WVALID[slave_active_master[s_w_i]];
		end
	endgenerate
`endif		

		// WB signals to slave mux
	generate
		genvar m2s_i;
		for(m2s_i=0; m2s_i<(N_SLAVES+1); m2s_i++) begin : WB_M2S_assign
			assign SADR[m2s_i] = (slave_active_master[m2s_i] == NO_MASTER)?0:ADR[slave_active_master[m2s_i]];
			assign SCTI[m2s_i] = (slave_active_master[m2s_i] == NO_MASTER)?0:CTI[slave_active_master[m2s_i]];
			assign SBTE[m2s_i] = (slave_active_master[m2s_i] == NO_MASTER)?0:BTE[slave_active_master[m2s_i]];
			assign SDAT_W[m2s_i] = (slave_active_master[m2s_i] == NO_MASTER)?0:DAT_W[slave_active_master[m2s_i]];
			assign SCYC[m2s_i] = (slave_active_master[m2s_i] == NO_MASTER)?0:CYC[slave_active_master[m2s_i]];
			assign SSEL[m2s_i] = (slave_active_master[m2s_i] == NO_MASTER)?0:SEL[slave_active_master[m2s_i]];
			assign SSTB[m2s_i] = (slave_active_master[m2s_i] == NO_MASTER)?0:STB[slave_active_master[m2s_i]];
			assign SWE[m2s_i] = (slave_active_master[m2s_i] == NO_MASTER)?0:WE[slave_active_master[m2s_i]];
		end
	endgenerate

	// Decode-fail target
`ifdef UNDEFINED		
	reg[1:0]									write_state;
	reg[AXI4_ID_WIDTH+N_MASTERID_BITS-1:0]		write_id;
	assign serr.AWREADY = (write_state == 0);
	assign serr.WREADY = (write_state == 1);
	assign serr.BVALID = (write_state == 2);
	assign serr.BID = (write_state == 2)?write_id:0;

	always @(posedge clk) begin
		if (rstn != 1) begin
			write_state <= 0;
		end else begin
			case (write_state)
				2'b00: begin
					if (serr.AWVALID) begin
						write_id <= serr.AWID;
						write_state <= 1;
					end
				end
				
				2'b01: begin
					if (serr.WVALID == 1'b1 && serr.WREADY == 1'b1) begin
						if (serr.WLAST == 1'b1) begin
							write_state <= 2;
						end
					end
				end
				
				2'b10: begin // Send write response
					if (serr.BVALID == 1'b1 && serr.BREADY == 1'b1) begin
						write_state <= 2'b0;
					end
				end
			endcase
		end
	end
`endif

endmodule
	

module wb_interconnect_2x2_arbiter #(
		parameter int			N_REQ=2
		) (
		input						clk,
		input						rstn,
		input[N_REQ-1:0]			req,
		output						gnt,
		output[$clog2(N_REQ)-1:0]	gnt_id
		);
	
	bit state;
	
	reg [N_REQ-1:0]	gnt_o;
	reg [N_REQ-1:0]	last_gnt;
	reg [$clog2(N_REQ)-1:0] gnt_id_o;
	assign gnt = |gnt_o;
	assign gnt_id = gnt_id_o;
	
	wire[N_REQ-1:0] gnt_ppc;
	wire[N_REQ-1:0]	gnt_ppc_next;

	generate
		if (N_REQ > 1) begin
			assign gnt_ppc_next = {gnt_ppc[N_REQ-2:0], 1'b0};
		end else begin
			assign gnt_ppc_next = gnt_ppc;
		end
	endgenerate

	generate
		genvar gnt_ppc_i;
		
	for (gnt_ppc_i=N_REQ-1; gnt_ppc_i>=0; gnt_ppc_i--) begin
		if (gnt_ppc_i == 0) begin
			assign gnt_ppc[gnt_ppc_i] = last_gnt[0];
		end else begin
			assign gnt_ppc[gnt_ppc_i] = |last_gnt[gnt_ppc_i-1:0];
		end
	end
	endgenerate
	
		wire[N_REQ-1:0]		unmasked_gnt;
	generate
		genvar unmasked_gnt_i;
		
	for (unmasked_gnt_i=0; unmasked_gnt_i<N_REQ; unmasked_gnt_i++) begin
		// Prioritized unmasked grant vector. Grant to the lowest active grant
		if (unmasked_gnt_i == 0) begin
			assign unmasked_gnt[unmasked_gnt_i] = req[unmasked_gnt_i];
		end else begin
			assign unmasked_gnt[unmasked_gnt_i] = (req[unmasked_gnt_i] & ~(|req[unmasked_gnt_i-1:0]));
		end
	end
	endgenerate
	
		wire[N_REQ-1:0]		masked_gnt;
	generate
		genvar masked_gnt_i;
		
	for (masked_gnt_i=0; masked_gnt_i<N_REQ; masked_gnt_i++) begin
		if (masked_gnt_i == 0) begin
			assign masked_gnt[masked_gnt_i] = (gnt_ppc_next[masked_gnt_i] & req[masked_gnt_i]);
		end else begin
			// Select first request above the last grant
			assign masked_gnt[masked_gnt_i] = (gnt_ppc_next[masked_gnt_i] & req[masked_gnt_i] & 
					~(|(gnt_ppc_next[masked_gnt_i-1:0] & req[masked_gnt_i-1:0])));
		end
	end
	endgenerate
	
		wire[N_REQ-1:0] prioritized_gnt;

	// Give priority to the 'next' request
	assign prioritized_gnt = (|masked_gnt)?masked_gnt:unmasked_gnt;
	
	always @(posedge clk) begin
		if (rstn == 0) begin
			state <= 0;
			last_gnt <= 0;
			gnt_o <= 0;
			gnt_id_o <= 0;
		end else begin
			case (state) 
				0: begin
					if (|prioritized_gnt) begin
						state <= 1;
						gnt_o <= prioritized_gnt;
						last_gnt <= prioritized_gnt;
						gnt_id_o <= gnt2id(prioritized_gnt);
					end
				end
				
				1: begin
					if ((gnt_o & req) == 0) begin
						state <= 0;
						gnt_o <= 0;
					end
				end
			endcase
		end
	end

	function bit[$clog2(N_REQ)-1:0] gnt2id(bit[N_REQ-1:0] gnt);
		automatic int i;
		reg[$clog2(N_REQ)-1:0] result;
		
		result = 0;
		
		for (i=0; i<N_REQ; i++) begin
			if (gnt[i]) begin
				result |= i;
			end
		end
	
		return result;
	endfunction

endmodule

