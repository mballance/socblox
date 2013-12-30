/****************************************************************************
 * wb_if.sv
 ****************************************************************************/

/**
 * Interface: wb_if
 * 
 * TODO: Add interface documentation
 */
interface wb_if #(
		parameter int WB_ADDR_WIDTH = 32,
		parameter int WB_DATA_WIDTH = 32
		);
	
	reg[(WB_ADDR_WIDTH-1):0]			ADR;
	reg[2:0]							CTI;
	reg[1:0]							BTE;
	reg[(WB_DATA_WIDTH-1):0]			DAT_W;
	reg[(WB_DATA_WIDTH-1):0]			DAT_R;
	reg									CYC;
	reg									ERR;
	reg[(WB_DATA_WIDTH/8)-1:0]			SEL;
	reg									STB;
	reg									ACK;
	reg									WE;

	modport master(
			output		ADR,
			output		CTI,
			output		BTE,
			output		DAT_W,
			input		DAT_R,
			output		CYC,
			input		ERR,
			output		SEL,
			output		STB,
			input		ACK,
			output		WE);
	
	modport slave(
			input		ADR,
			input		CTI,
			input		BTE,
			input		DAT_W,
			output		DAT_R,
			input		CYC,
			output		ERR,
			input		SEL,
			input		STB,
			output		ACK,
			input		WE);
		
	modport monitor(
			input		ADR,
			input		CTI,
			input		BTE,
			input		DAT_W,
			input		DAT_R,
			input		CYC,
			input		ERR,
			input		SEL,
			input		STB,
			input		ACK,
			input		WE);
			

endinterface

