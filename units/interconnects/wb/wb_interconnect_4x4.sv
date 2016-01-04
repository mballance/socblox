/****************************************************************************
 * wb_interconnect_4x4.sv
 ****************************************************************************/

/**
 * Module: wb_interconnect_4x4
 * 
 * TODO: Add module documentation
 */
module wb_interconnect_4x4 #(
		parameter int WB_ADDR_WIDTH=32,
		parameter int WB_DATA_WIDTH=32,
		parameter bit[WB_ADDR_WIDTH-1:0] SLAVE0_ADDR_BASE='h0,
		parameter bit[WB_ADDR_WIDTH-1:0] SLAVE0_ADDR_LIMIT='h0,
		parameter bit[WB_ADDR_WIDTH-1:0] SLAVE1_ADDR_BASE='h0,
		parameter bit[WB_ADDR_WIDTH-1:0] SLAVE1_ADDR_LIMIT='h0,
		parameter bit[WB_ADDR_WIDTH-1:0] SLAVE2_ADDR_BASE='h0,
		parameter bit[WB_ADDR_WIDTH-1:0] SLAVE2_ADDR_LIMIT='h0,
		parameter bit[WB_ADDR_WIDTH-1:0] SLAVE3_ADDR_BASE='h0,
		parameter bit[WB_ADDR_WIDTH-1:0] SLAVE3_ADDR_LIMIT='h0
		) (
		input						clk,
		input						rstn,
		wb_if.slave					m0,
		wb_if.slave					m1,
		wb_if.slave					m2,
		wb_if.slave					m3,
		wb_if.master					s0,
		wb_if.master					s1,
		wb_if.master					s2,
		wb_if.master					s3
		);
	
	
	localparam int WB_DATA_MSB = (WB_DATA_WIDTH-1);
	localparam int N_MASTERS = 4;
	localparam int N_SLAVES = 4;
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
			.ADDR_RANGES({SLAVE0_ADDR_BASE, SLAVE0_ADDR_LIMIT,SLAVE1_ADDR_BASE, SLAVE1_ADDR_LIMIT,SLAVE2_ADDR_BASE, SLAVE2_ADDR_LIMIT,SLAVE3_ADDR_BASE, SLAVE3_ADDR_LIMIT})
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
	assign ADR[0] = m0.ADR;
	assign ADR[1] = m1.ADR;
	assign ADR[2] = m2.ADR;
	assign ADR[3] = m3.ADR;
	assign CTI[0] = m0.CTI;
	assign CTI[1] = m1.CTI;
	assign CTI[2] = m2.CTI;
	assign CTI[3] = m3.CTI;
	assign BTE[0] = m0.BTE;
	assign BTE[1] = m1.BTE;
	assign BTE[2] = m2.BTE;
	assign BTE[3] = m3.BTE;
	assign DAT_W[0] = m0.DAT_W;
	assign DAT_W[1] = m1.DAT_W;
	assign DAT_W[2] = m2.DAT_W;
	assign DAT_W[3] = m3.DAT_W;
	assign CYC[0] = m0.CYC;
	assign CYC[1] = m1.CYC;
	assign CYC[2] = m2.CYC;
	assign CYC[3] = m3.CYC;
	assign SEL[0] = m0.SEL;
	assign SEL[1] = m1.SEL;
	assign SEL[2] = m2.SEL;
	assign SEL[3] = m3.SEL;
	assign STB[0] = m0.STB;
	assign STB[1] = m1.STB;
	assign STB[2] = m2.STB;
	assign STB[3] = m3.STB;
	assign WE[0] = m0.WE;
	assign WE[1] = m1.WE;
	assign WE[2] = m2.WE;
	assign WE[3] = m3.WE;
	assign m0.DAT_R = DAT_R[0];
	assign m1.DAT_R = DAT_R[1];
	assign m2.DAT_R = DAT_R[2];
	assign m3.DAT_R = DAT_R[3];
	assign m0.ERR = ERR[0];
	assign m1.ERR = ERR[1];
	assign m2.ERR = ERR[2];
	assign m3.ERR = ERR[3];
	assign m0.ACK = ACK[0];
	assign m1.ACK = ACK[1];
	assign m2.ACK = ACK[2];
	assign m3.ACK = ACK[3];

	
	// Slave requests
	assign SDAT_R[0] = s0.DAT_R;
	assign SDAT_R[1] = s1.DAT_R;
	assign SDAT_R[2] = s2.DAT_R;
	assign SDAT_R[3] = s3.DAT_R;
	assign SERR[0] = s0.ERR;
	assign SERR[1] = s1.ERR;
	assign SERR[2] = s2.ERR;
	assign SERR[3] = s3.ERR;
	assign SACK[0] = s0.ACK;
	assign SACK[1] = s1.ACK;
	assign SACK[2] = s2.ACK;
	assign SACK[3] = s3.ACK;
	assign s0.ADR = SADR[0];
	assign s1.ADR = SADR[1];
	assign s2.ADR = SADR[2];
	assign s3.ADR = SADR[3];
	assign s0.CTI = SCTI[0];
	assign s1.CTI = SCTI[1];
	assign s2.CTI = SCTI[2];
	assign s3.CTI = SCTI[3];
	assign s0.BTE = SBTE[0];
	assign s1.BTE = SBTE[1];
	assign s2.BTE = SBTE[2];
	assign s3.BTE = SBTE[3];
	assign s0.DAT_W = SDAT_W[0];
	assign s1.DAT_W = SDAT_W[1];
	assign s2.DAT_W = SDAT_W[2];
	assign s3.DAT_W = SDAT_W[3];
	assign s0.CYC = SCYC[0];
	assign s1.CYC = SCYC[1];
	assign s2.CYC = SCYC[2];
	assign s3.CYC = SCYC[3];
	assign s0.SEL = SSEL[0];
	assign s1.SEL = SSEL[1];
	assign s2.SEL = SSEL[2];
	assign s3.SEL = SSEL[3];
	assign s0.STB = SSTB[0];
	assign s1.STB = SSTB[1];
	assign s2.STB = SSTB[2];
	assign s3.STB = SSTB[3];
	assign s0.WE = SWE[0];
	assign s1.WE = SWE[1];
	assign s2.WE = SWE[2];
	assign s3.WE = SWE[3];



endmodule
	

