/****************************************************************************
 * ${NAME}.sv
 ****************************************************************************/

/**
 * Module: wb_interconnect_NxN
 * 
 * TODO: Add module documentation
 */
module wb_interconnect_NxN #(
		parameter int 									WB_ADDR_WIDTH=32,
		parameter int unsigned							WB_DATA_WIDTH=32,
		parameter int unsigned							N_MASTERS=1,
		parameter int unsigned							N_SLAVES=1,
		parameter bit[WB_ADDR_WIDTH*N_SLAVES*2-1:0] 	ADDR_RANGES
		) (
		input							clk,
		input							rstn,
		input[WB_ADDR_WIDTH-1:0]		ADR[N_MASTERS-1:0],
		input[2:0]						CTI[N_MASTERS-1:0],
		input[1:0]						BTE[N_MASTERS-1:0],
		input[WB_DATA_WIDTH-1:0]		DAT_W[N_MASTERS-1:0],
		output[WB_DATA_WIDTH-1:0]		DAT_R[N_MASTERS-1:0],
		input							CYC[N_MASTERS-1:0],
		output							ERR[N_MASTERS-1:0],
		input[(WB_DATA_WIDTH/8)-1:0]	SEL[N_MASTERS-1:0],
		input							STB[N_MASTERS-1:0],
		output							ACK[N_MASTERS-1:0],
		input							WE[N_MASTERS-1:0],

		output[WB_ADDR_WIDTH-1:0]		SADR[N_SLAVES:0],
		output[2:0]						SCTI[N_SLAVES:0],
		output[1:0]						SBTE[N_SLAVES:0],
		output[WB_DATA_WIDTH-1:0]		SDAT_W[N_SLAVES:0],
		input[WB_DATA_WIDTH-1:0]		SDAT_R[N_SLAVES:0],
		output							SCYC[N_SLAVES:0],
		input							SERR[N_SLAVES:0],
		output[(WB_DATA_WIDTH/8)-1:0]	SSEL[N_SLAVES:0],
		output							SSTB[N_SLAVES:0],
		input							SACK[N_SLAVES:0],
		output							SWE[N_SLAVES:0]
		);
	
	localparam int WB_DATA_MSB = (WB_DATA_WIDTH-1);
	localparam int N_MASTERID_BITS = (N_MASTERS>1)?$clog2(N_MASTERS):1;
	localparam int N_SLAVEID_BITS = $clog2(N_SLAVES+1);
	localparam bit[N_SLAVEID_BITS:0]		NO_SLAVE  = {(N_SLAVEID_BITS+1){1'b1}};
	localparam bit[N_MASTERID_BITS:0]		NO_MASTER = {(N_MASTERID_BITS+1){1'b1}};
	
	// Interface to the decode-fail slave
//	wb_if				serr();
	
	function reg[N_SLAVEID_BITS-1:0] addr2slave(
		reg[N_MASTERID_BITS-1:0]	master,
		reg[WB_ADDR_WIDTH-1:0] 		addr
		);
		for (int i=0; i<N_SLAVES; i+=2) begin
			if (addr >= ADDR_RANGES[WB_ADDR_WIDTH*i-:WB_ADDR_WIDTH] &&
					addr <= ADDR_RANGES[WB_ADDR_WIDTH*(i+1)-:WB_ADDR_WIDTH]) begin
				return N_SLAVES-(i/2)-1;
			end
		end
		return (N_SLAVES);
	endfunction
	
// Read request state machine
	reg[3:0]									read_req_state[N_MASTERS-1:0];
	reg[N_SLAVEID_BITS:0]						read_selected_slave[N_MASTERS-1:0];

	// Master state machine
	reg[2:0]						master_state[N_MASTERS-1:0];
	reg[3:0]						master_selected_slave[N_MASTERS-1:0];
	wire							master_gnt[N_SLAVES:0];
	wire[$clog2(N_MASTERS)-1:0]		master_gnt_id[N_SLAVES:0];
	wire[N_MASTERS-1:0]				master_slave_req[N_SLAVES:0];
	
	generate
		genvar m_i;
		for (m_i=0; m_i<N_MASTERS; m_i++) begin : block_m_i
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

		for (m_req_i=0; m_req_i < N_SLAVES; m_req_i++) begin : block_m_req_i
			for (m_req_j=0; m_req_j < N_MASTERS; m_req_j++) begin : block_m_req_j
				assign master_slave_req[m_req_i][m_req_j] = (master_selected_slave[m_req_j] == m_req_i);
			end
		end
	endgenerate

	generate
		genvar s_arb_i;
		
		for (s_arb_i=0; s_arb_i<(N_SLAVES+1); s_arb_i++) begin : s_arb
			wb_NxN_arbiter #(
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
		
		for (s_am_i=0; s_am_i<N_SLAVES+1; s_am_i++) begin : block_s_am_i
			assign slave_active_master[s_am_i] =
				(master_gnt[s_am_i])?master_gnt_id[s_am_i]:NO_MASTER;
		end
	endgenerate
	
		// WB signals from slave back to master
	generate
		genvar s2m_i;
		
		for (s2m_i=0; s2m_i<N_MASTERS; s2m_i++) begin : block_s2m_i
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

endmodule
	

module wb_NxN_arbiter #(
		parameter int			N_REQ=2
		) (
		input						clk,
		input						rstn,
		input[N_REQ-1:0]			req,
		output						gnt,
		output[$clog2(N_REQ)-1:0]	gnt_id
		);
	
	reg state;
	
	reg [N_REQ-1:0]	gnt_o = 0;
	reg [N_REQ-1:0]	last_gnt = 0;
	reg [$clog2(N_REQ)-1:0] gnt_id_o = 0;
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
		
	for (gnt_ppc_i=N_REQ-1; gnt_ppc_i>=0; gnt_ppc_i--) begin : block_gnt_ppc_i
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
		
	for (unmasked_gnt_i=0; unmasked_gnt_i<N_REQ; unmasked_gnt_i++) begin : block_unmasked_gnt_i
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
		
	for (masked_gnt_i=0; masked_gnt_i<N_REQ; masked_gnt_i++) begin : block_masked_gnt_i
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

	function reg[$clog2(N_REQ)-1:0] gnt2id(reg[N_REQ-1:0] gnt);
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
