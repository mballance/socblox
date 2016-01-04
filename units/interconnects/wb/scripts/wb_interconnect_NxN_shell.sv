/****************************************************************************
 * ${NAME}.sv
 ****************************************************************************/

/**
 * Module: ${NAME}
 * 
 * TODO: Add module documentation
 */
module ${NAME} #(
		parameter int WB_ADDR_WIDTH=32,
		parameter int WB_DATA_WIDTH=32,
${ADDRESS_RANGE_PARAMS}
		) (
		input						clk,
		input						rstn,
${MASTER_PORTLIST},
${SLAVE_PORTLIST}
		);
	
	
	localparam int WB_DATA_MSB = (WB_DATA_WIDTH-1);
	localparam int N_MASTERS = ${N_MASTERS};
	localparam int N_SLAVES = ${N_SLAVES};
	localparam int N_MASTERID_BITS = (N_MASTERS>1)?$clog2(N_MASTERS):1;
	localparam int N_SLAVEID_BITS = $clog2(N_SLAVES+1);
	localparam bit[N_SLAVEID_BITS:0]		NO_SLAVE  = {(N_SLAVEID_BITS+1){1'b1}};
	localparam bit[N_MASTERID_BITS:0]		NO_MASTER = {(N_MASTERID_BITS+1){1'b1}};
	
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
	
	wb_interconnect_NxN #(
			.WB_ADDR_WIDTH(WB_ADDR_WIDTH),
			.WB_DATA_WIDTH(WB_DATA_WIDTH),
			.N_MASTERS(N_MASTERS),
			.N_SLAVES(N_SLAVES),
			.ADDR_RANGES(${ADDR_RANGES})
		) ic0 (
			.clk(clk),
			.rstn(rstn),
			.ADR(ADR),
			.CTI(CTI),
			.BTE(BTE),
			.DAT_W(DAT_W),
			.DAT_R(DAT_R),
			.CYC(CYC),
			.ERR(ERR),
			.SEL(SEL),
			.STB(STB),
			.ACK(ACK),
			.WE(WE),
			
			.SADR(SADR),
			.SCTI(SCTI),
			.SBTE(SBTE),
			.SDAT_W(SDAT_W),
			.SDAT_R(SDAT_R),
			.SCYC(SCYC),
			.SERR(SERR),
			.SSEL(SSEL),
			.SSTB(SSTB),
			.SACK(SACK),
			.SWE(SWE)
		);
	
	// master assigns
${MASTER_ASSIGN}
	
	// Slave requests
${SLAVE_ASSIGN}


endmodule
	
