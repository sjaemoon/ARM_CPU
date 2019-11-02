module control (clk, reset);

	input logic clk, reset, zero_flag;
	
	input logic alu_neg, alu_zero, alu_overf, alu_cOut;
	input logic [31:0] instruction;	

	output logic Reg2Loc, ALUSrc, MemToReg, RegWrite, MemWrite, BrTaken, UncondBr;
	output logic [2:0] = ALUOp;


	//flag_wr_en stores flags to the flag register
	//rd_x30 used for the purposes of Instr BL

	output logic flag_wr_en, rd_x30;

	
	logic [10:0] opcode;
	logic [9:0] ctrl;
	
	assign opcode = instruction[31:21];

	assign Reg2Loc = ctrl[9];
	assign ALUSrc = ctrl[8];
	assign MemToReg = ctrl[7];
	assign RegWrite = ctrl[6];
	assign MemWrite = ctrl[5];
	assign BrTaken = ctrl[4];
	assign UncondBr = ctrl[3];
	assign ALUOp = ctrl[2:0];
	
	// TODO: Set other values as well... (rn, rm, rd, daddr, condaddr, etc)	
	// control signals logic based on table
	always_comb begin
		casex (opcode)
		//Another mux that inputs into ALUSrc Mux
		//Takes in DAddr9 or ALUImm12, controlled by
		//Reg2Loc as ADDI adds Rn + ALUImm12, therefore
		//Source of Db does not matter.
		11'b1001000100x: begin
							ctrl = 10'b110100x010; // ADDI - 0x244 (10bit)
							rd_x30 = 0;
							flag_wr_en = 0; 
						 end
		11'b10101011000: begin
							ctrl = 10'b100100x010;// ADDS - 0x558 (11bit)  
							rd_x30 = 0;
							flag_wr_en = 1; 
						 end
		11'b000101xxxxx: begin
							ctrl = 10'bxxx0011xxx; // B - 0x05 (6bit)
							rd_x30 = 0;
							flag_wr_en = 0; 
						 end
		11'b01010100xxx: begin
							ctrl = {5'b00x00, (alu_neg && (alu_neg != alu_overf)), 4'b000} // B.LT - 0x54 (8bit)
							rd_x30 = 0;
							flag_wr_en = 0; 
						 end

		//Extra mux needed to hardwire X30 to Aw
		//Extra mux needed to take in PC + 4 and 
		//connect it to Dw.
		//Both mux controlled by rd_x30
		11'b100101xxxxx: begin
							ctrl = 10'bxxx1011xxx; // BL - 0x25 (6bit)
							rd_x30 = 1;
							flag_wr_en = 0; 
						 end
		11'b11010110000: begin
							ctrl = 10'b // BR - 0x6B0 (11bit)
							rd_x30 = 0;
							flag_wr_en = 0; 
						 end
		11'b10110100xxx: begin
							ctrl = {5'b00x00, alu_zero, 4'b0000}; // CBZ - 0xB4 (8bit)
							rd_x30 = 0;
							flag_wr_en = 0; 
						 end
		11'b11111000010: begin
							ctrl = 10'bx11100x010; // LDUR =- 0x7C2 (11bit)
							rd_x30 = 0;
							flag_wr_en = 0; 
						 end
		11'b11111000000: begin
							ctrl = 10'b01x010x010; // STUR - 0x7C0 (11bit)
							rd_x30 = 0;
							flag_wr_en = 0; 
						 end
		11'b11101011000: begin
							ctrl = 10'b100100x011; // SUBS - 0x658 (11bit)
							rd_x30 = 0;
							flag_wr_en = 1;
						end
		endcase
	end 
		
	
	//logic Reg2Loc_out, ALUSrc_out, MemToReg_out, ALUOp_out, zero_flag;
	

	/* This block below is not necessary. Control unit does not contain any
	   other modules. They should be initialized in the CPU top level module */

	/*
	// TODO: initialize pc somehow
	// instruction fetch unit
	program_counter pc (clk, reset, pc_in, BrTaken, UncondBr, CondAddr19, BrAddr26, pc_out);
	instruction instr (.address(pc), .instruction, .clk);
	
	// TODO: maybe put each instruction as separate module
	// Reg2Loc mux
	mux2_1 mux0 #(.WIDTH(64)) mux2 (.in(mux2_sig), .sel(Reg2Loc), .out(Reg2Loc_out));
	
	
	// ALUSrc mux
	mux2_1 mux1 #(.WIDTH(64)) mux2 (.in(mux2_sig), .sel(ALUSrc), .out(ALUSrc_out));
	
	// MemToReg mux
	mux2_1 mux2 #(.WIDTH(64)) mux2 (.in(mux2_sig), .sel(MemToReg), .out(MemToReg_out));

	// ALUOp ALU
	alu alu0 (.A(Da), .B(ALUSrc_out), .cntrl(ALUOp), .result(ALUOp_out), 
				 .negative, .zero(zero_flag), .overflow, .carry_out);
	
	// TODO: integrate regFile and dataMem
	*/
	
endmodule

/*
	Reference

	OPCODE (Hex)
		ADDI: 0x244
		ADDS: 0x558
		B:		0x05
		B.LT:	0x54, cond: 0x0B
		BL:	0x25
		BR:	0x6B0
		CBZ:	0xB4
		LDUR:	0x7C2
		STUR:	0x7C0
		SUBS:	0x658

	ADDI Rd, Rn, Imm12: Reg[Rd] = Reg[Rn] + ZeroExtend(Imm12).
	ADDS Rd, Rn, Rm: Reg[Rd] = Reg[Rn] + Reg[Rm]. Set flags.
	B Imm26: PC = PC + SignExtend(Imm26 << 2).
	 For lab #4 (only) this instr. has a delay slot.
	B.LT Imm19: If (flags.negative != flags.overflow) PC = PC + SignExtend(Imm19<<2).
	 For lab #4 (only) this instr. has a delay slot.
	BL Imm26: X30 = PC + 4 (instruction after this one), PC = PC + SignExtend(Imm26<<2).
	 For lab #4 (only) this instr. has a delay slot.
	BR Rd: PC = Reg[Rd].
	 For lab #4 (only) this instr. has a delay slot.
	CBZ Rd, Imm19: If (Reg[Rd] == 0) PC = PC + SignExtend(Imm19<<2).
	 For lab #4 (only) this instr. has a delay slot.
	LDUR Rd, [Rn, #Imm9]: Reg[Rd] = Mem[Reg[Rn] + SignExtend(Imm9)].
	For lab #4 (only) the value in rd cannot be used in the next cycle.
	STUR Rd, [Rn, #Imm9]: Mem[Reg[Rn] + SignExtend(Imm9)] = Reg[Rd].
	SUBS Rd, Rn, Rm: Reg[Rd] = Reg[Rn] - Reg[Rm]. Set flags. 
*/