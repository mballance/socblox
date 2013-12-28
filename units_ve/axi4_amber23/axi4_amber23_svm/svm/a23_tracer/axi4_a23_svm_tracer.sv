/****************************************************************************
 * axi4_a23_svm_tracer.sv
 ****************************************************************************/

/**
 * Module: axi4_a23_svm_tracer
 * 
 * TODO: Add module documentation
 */
module axi4_a23_svm_tracer(
		input                       i_clk,
		input                       i_fetch_stall,
		input       [31:0]          i_instruction,
		input                       i_instruction_valid,
		input                       i_instruction_undefined,
		input                       i_instruction_execute,
		input       [2:0]           i_interrupt,            // non-zero value means interrupt triggered
		input                       i_interrupt_state,
		input       [31:0]          i_instruction_address,
		input       [1:0]           i_pc_sel,
		input                       i_pc_wen,
		input						i_write_enable,
		input						fetch_stall,
		input						i_data_access,
		input		[31:0]			pc_nxt,
		input		[31:0]			i_address,
		input		[31:0]			i_write_data,
		input		[3:0]			i_byte_enable,
		input		[31:0]			i_read_data,
		input		[31:0]			i_r0_r15_user[15:0]
		);
	
`include "a23_localparams.v"

	wire    [31:0]         imm32;
	wire    [7:0]          imm8;
	wire    [11:0]         offset12;
	wire    [7:0]          offset8;
	wire    [3:0]          reg_n, reg_d, reg_m, reg_s;
	wire    [4:0]          shift_imm;
	wire    [3:0]          opcode;
	wire    [3:0]          condition;
	wire    [3:0]          i_type;
	wire                   opcode_compare;
	wire                   opcode_move;
	wire                   no_shift;
	wire                   shift_op_imm;
	wire    [1:0]          mtrans_type;
	wire                   s_bit;

	reg     [(5*8)-1:0]    xINSTRUCTION_EXECUTE;
	reg     [(5*8)-1:0]    xINSTRUCTION_EXECUTE_R = "---   ";
	wire    [(8*8)-1:0]    TYPE_NAME;
	reg     [3:0]          fchars;
	reg     [31:0]         execute_address = 'd0;
	reg     [2:0]          interrupt_d1;
	reg     [31:0]         execute_instruction = 'd0;
	reg                    execute_now = 'd0;
	reg                    execute_valid = 'd0;
	reg                    execute_undefined = 'd0;
	
	
	reg	[31:0]				r0_r15_user[15:0];
	
	import "DPI-C" context task axi4_a23_svm_tracer_register();
	import "DPI-C" context task axi4_a23_svm_tracer_mem_access(
			int unsigned			addr,
			int unsigned			is_write,
			int unsigned			data
			);
	import "DPI-C" context task axi4_a23_svm_tracer_execute(
			int unsigned			addr,
			int unsigned			op
			);
	
	import "DPI-C" context task axi4_a23_svm_tracer_regchange(
			int unsigned			regno,
			int unsigned			val
			);
	
	initial begin
		axi4_a23_svm_tracer_register();
	end
	
	always @(posedge i_clk) begin
		for (int i=0; i<15; i++) begin
			if (i_r0_r15_user[i] != r0_r15_user[i]) begin
				axi4_a23_svm_tracer_regchange(i, i_r0_r15_user[i]);
				r0_r15_user[i] <= i_r0_r15_user[i];
			end
		end
	end



	// ========================================================
	// Delay instruction to Execute stage
	// ========================================================
	always @( posedge i_clk )
		if ( !i_fetch_stall && i_instruction_valid )
		begin
			execute_instruction <= i_instruction;
			execute_address     <= i_instruction_address;
			execute_undefined   <= i_instruction_undefined;
			execute_now         <= 1'd1;
		end
		else
			execute_now         <= 1'd0;


	always @ ( posedge i_clk ) begin
		if ( !i_fetch_stall ) begin
			execute_valid <= i_instruction_valid;
		end
	end

	// ========================================================
	// Fields within the instruction
	// ========================================================
	assign opcode      = execute_instruction[24:21];
	assign condition   = execute_instruction[31:28];
	assign s_bit       = execute_instruction[20];
	assign reg_n       = execute_instruction[19:16];
	assign reg_d       = execute_instruction[15:12];
	assign reg_m       = execute_instruction[3:0];
	assign reg_s       = execute_instruction[11:8];
	assign shift_imm   = execute_instruction[11:7];
	assign offset12    = execute_instruction[11:0];
	assign offset8     = {execute_instruction[11:8], execute_instruction[3:0]};
	assign imm8        = execute_instruction[7:0];

	assign no_shift    = execute_instruction[11:4] == 8'h0;
	assign mtrans_type = execute_instruction[24:23];


	assign opcode_compare =
		opcode == CMP || 
		opcode == CMN || 
		opcode == TEQ || 
		opcode == TST ;
            
	assign opcode_move =
		opcode == MOV || 
		opcode == MVN ;
            
	assign shift_op_imm = i_type == REGOP && execute_instruction[25] == 1'd1;

	assign imm32 =  execute_instruction[11:8] == 4'h0 ? { 24'h0, imm8[7:0] } :
		execute_instruction[11:8] == 4'h1 ? { imm8[1:0], 24'h0, imm8[7:2] } :
		execute_instruction[11:8] == 4'h2 ? { imm8[3:0], 24'h0, imm8[7:4] } :
		execute_instruction[11:8] == 4'h3 ? { imm8[5:0], 24'h0, imm8[7:6] } :
		execute_instruction[11:8] == 4'h4 ? { imm8[7:0], 24'h0            } :
		execute_instruction[11:8] == 4'h5 ? { 2'h0,  imm8[7:0], 22'h0 }     :
		execute_instruction[11:8] == 4'h6 ? { 4'h0,  imm8[7:0], 20'h0 }     :
		execute_instruction[11:8] == 4'h7 ? { 6'h0,  imm8[7:0], 18'h0 }     :
		execute_instruction[11:8] == 4'h8 ? { 8'h0,  imm8[7:0], 16'h0 }     :
		execute_instruction[11:8] == 4'h9 ? { 10'h0, imm8[7:0], 14'h0 }     :
		execute_instruction[11:8] == 4'ha ? { 12'h0, imm8[7:0], 12'h0 }     :
		execute_instruction[11:8] == 4'hb ? { 14'h0, imm8[7:0], 10'h0 }     :
		execute_instruction[11:8] == 4'hc ? { 16'h0, imm8[7:0], 8'h0  }     :
		execute_instruction[11:8] == 4'hd ? { 18'h0, imm8[7:0], 6'h0  }     :
		execute_instruction[11:8] == 4'he ? { 20'h0, imm8[7:0], 4'h0  }     :
		{ 22'h0, imm8[7:0], 2'h0  };


		// ========================================================
		// Instruction decode
		// ========================================================
		// the order of these matters
	assign i_type = 
		{execute_instruction[27:23], execute_instruction[21:20], execute_instruction[11:4] } == { 5'b00010, 2'b00, 8'b00001001 } ? SWAP     :  // Before REGOP
		{execute_instruction[27:22], execute_instruction[7:4]                              } == { 6'b000000, 4'b1001           } ? MULT     :  // Before REGOP
		{execute_instruction[27:26]                                                        } == { 2'b00                        } ? REGOP    :    
		{execute_instruction[27:26]                                                        } == { 2'b01                        } ? TRANS    :
		{execute_instruction[27:25]                                                        } == { 3'b100                       } ? MTRANS   :
		{execute_instruction[27:25]                                                        } == { 3'b101                       } ? BRANCH   :
		{execute_instruction[27:25]                                                        } == { 3'b110                       } ? CODTRANS :
		{execute_instruction[27:24], execute_instruction[4]                                } == { 4'b1110, 1'b0                } ? COREGOP  :
		{execute_instruction[27:24], execute_instruction[4]                                } == { 4'b1110, 1'b1                } ? CORTRANS :
		SWI      ;

                                                                                                                 
		//
		// Convert some important signals to ASCII
		// so their values can easily be displayed on a waveform viewer
		//
	assign TYPE_NAME    = i_type == REGOP    ? "REGOP   " :
		i_type == MULT     ? "MULT    " :
		i_type == SWAP     ? "SWAP    " :
		i_type == TRANS    ? "TRANS   " : 
		i_type == MTRANS   ? "MTRANS  " : 
		i_type == BRANCH   ? "BRANCH  " : 
		i_type == CODTRANS ? "CODTRANS" : 
		i_type == COREGOP  ? "COREGOP " : 
		i_type == CORTRANS ? "CORTRANS" : 
		i_type == SWI      ? "SWI     " : 
		"UNKNOWN " ;
                                           

	always @*
	begin
    
		if ( !execute_now ) 
		begin 
			xINSTRUCTION_EXECUTE =  xINSTRUCTION_EXECUTE_R; 
		end // stalled

		else if ( i_type == REGOP    && opcode == ADC                                                          ) xINSTRUCTION_EXECUTE = "adc  ";
		else if ( i_type == REGOP    && opcode == ADD                                                          ) xINSTRUCTION_EXECUTE = "add  ";
		else if ( i_type == REGOP    && opcode == AND                                                          ) xINSTRUCTION_EXECUTE = "and  ";
		else if ( i_type == BRANCH   && execute_instruction[24] == 1'b0                                        ) xINSTRUCTION_EXECUTE = "b    ";
		else if ( i_type == REGOP    && opcode == BIC                                                          ) xINSTRUCTION_EXECUTE = "bic  ";
		else if ( i_type == BRANCH   && execute_instruction[24] == 1'b1                                        ) xINSTRUCTION_EXECUTE = "bl   ";
		else if ( i_type == COREGOP                                                                            ) xINSTRUCTION_EXECUTE = "cdp  ";
		else if ( i_type == REGOP    && opcode == CMN                                                          ) xINSTRUCTION_EXECUTE = "cmn  ";
		else if ( i_type == REGOP    && opcode == CMP                                                          ) xINSTRUCTION_EXECUTE = "cmp  ";
		else if ( i_type == REGOP    && opcode == EOR                                                          ) xINSTRUCTION_EXECUTE = "eor  ";
		else if ( i_type == CODTRANS && execute_instruction[20] == 1'b1                                        ) xINSTRUCTION_EXECUTE = "ldc  ";
		else if ( i_type == MTRANS   && execute_instruction[20] == 1'b1                                        ) xINSTRUCTION_EXECUTE = "ldm  ";
		else if ( i_type == TRANS    && {execute_instruction[22],execute_instruction[20]}    == {1'b0, 1'b1}   ) xINSTRUCTION_EXECUTE = "ldr  ";
		else if ( i_type == TRANS    && {execute_instruction[22],execute_instruction[20]}    == {1'b1, 1'b1}   ) xINSTRUCTION_EXECUTE = "ldrb ";
		else if ( i_type == CORTRANS && execute_instruction[20] == 1'b0                                        ) xINSTRUCTION_EXECUTE = "mcr  ";
		else if ( i_type == MULT     && execute_instruction[21] == 1'b1                                        ) xINSTRUCTION_EXECUTE = "mla  ";
		else if ( i_type == REGOP    && opcode == MOV                                                          ) xINSTRUCTION_EXECUTE = "mov  ";
		else if ( i_type == CORTRANS && execute_instruction[20] == 1'b1                                        ) xINSTRUCTION_EXECUTE = "mrc  ";
		else if ( i_type == MULT     && execute_instruction[21] == 1'b0                                        ) xINSTRUCTION_EXECUTE = "mul  ";
		else if ( i_type == REGOP    && opcode == MVN                                                          ) xINSTRUCTION_EXECUTE = "mvn  ";
		else if ( i_type == REGOP    && opcode == ORR                                                          ) xINSTRUCTION_EXECUTE = "orr  ";
		else if ( i_type == REGOP    && opcode == RSB                                                          ) xINSTRUCTION_EXECUTE = "rsb  ";
		else if ( i_type == REGOP    && opcode == RSC                                                          ) xINSTRUCTION_EXECUTE = "rsc  ";
		else if ( i_type == REGOP    && opcode == SBC                                                          ) xINSTRUCTION_EXECUTE = "sbc  ";
		else if ( i_type == CODTRANS && execute_instruction[20] == 1'b0                                        ) xINSTRUCTION_EXECUTE = "stc  ";
		else if ( i_type == MTRANS   && execute_instruction[20] == 1'b0                                        ) xINSTRUCTION_EXECUTE = "stm  ";
		else if ( i_type == TRANS    && {execute_instruction[22],execute_instruction[20]}    == {1'b0, 1'b0}   ) xINSTRUCTION_EXECUTE = "str  ";
		else if ( i_type == TRANS    && {execute_instruction[22],execute_instruction[20]}    == {1'b1, 1'b0}   ) xINSTRUCTION_EXECUTE = "strb ";
		else if ( i_type == REGOP    && opcode == SUB                                                          ) xINSTRUCTION_EXECUTE = "sub  ";  
		else if ( i_type == SWI                                                                                ) xINSTRUCTION_EXECUTE = "swi  ";  
		else if ( i_type == SWAP     && execute_instruction[22] == 1'b0                                        ) xINSTRUCTION_EXECUTE = "swp  ";  
		else if ( i_type == SWAP     && execute_instruction[22] == 1'b1                                        ) xINSTRUCTION_EXECUTE = "swpb ";  
		else if ( i_type == REGOP    && opcode == TEQ                                                          ) xINSTRUCTION_EXECUTE = "teq  ";  
		else if ( i_type == REGOP    && opcode == TST                                                          ) xINSTRUCTION_EXECUTE = "tst  ";  
		else                                                                                                   xINSTRUCTION_EXECUTE = "unkow";  
	end

	always @ ( posedge i_clk ) 
		xINSTRUCTION_EXECUTE_R <= xINSTRUCTION_EXECUTE;

	always @( posedge i_clk ) begin
		if ( execute_now ) begin
        
			// Interrupts override instructions that are just starting
			if ( interrupt_d1 == 3'd0 || interrupt_d1 == 3'd7 ) begin
				axi4_a23_svm_tracer_execute(execute_address, execute_instruction);
			end
		end
	end

	// =================================================================================
	// Memory Writes - Peek into fetch module
	// =================================================================================
	reg [31:0] tmp_address;

	// Data access
	always @(posedge i_clk) begin
		// Data Write    
		if ( i_write_enable && !fetch_stall ) begin
			axi4_a23_svm_tracer_mem_access(i_address, 1, i_write_data);
		end else if (i_data_access && !i_write_enable && !fetch_stall) begin
			// Data Read    
			axi4_a23_svm_tracer_mem_access(i_address, 0, i_read_data);
		end
	end
			
endmodule

