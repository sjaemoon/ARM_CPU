module control (clk, reset);

	input logic clk, reset;
	
	logic [63:0] pc;
	logic	[31:0] instruction;	
	logic [10:0] opcode;
	logic [7:0] ctrl_sig;
	logic Reg2Loc, ALUSrc, MemToReg, RegWRite, MemWrite, BrTaken;
	logic [2:0] = ALUOp;
	
	assign opcode = instruction[31:21];
	assign cntrl_sig[9] = Reg2Loc;
	assign cntrl_sig[8] = ALUSrc;
	assign cntrl_sig[7] = MemToReg;	
	assign cntrl_sig[6] = RegWrite;	
	assign cntrl_sig[5] = MemWrite;	
	assign cntrl_sig[4] = BrTaken;	
	assign cntrl_sig[3] = UncondBr;	
	assign cntrl_sig[2:0] = ALUOp;	
	
	// TODO: Set other values as well... (rn, rm, rd, daddr, condaddr, etc)	
	// control signals logic based on table
	always_comb begin
		case (opcode)
		11'b1001000100x: ctrl = 10'b // ADDI - 0x244 (10bit)
		11'b10101011000: ctrl = 10'b // ADDS - 0x558 (11bit)        
		11'b000101xxxxx: ctrl = 10'bxxx0011xxx; // B - 0x05 (6bit)
		11'b01010100xxx: ctrl = 10'b // B.LT - 0x54 (8bit)
		11'b100101xxxxx: ctrl = 10'b // BL - 0x25 (6bit)
		11'b11010110000: ctrl = 10'b // BR - 0x6B0 (11bit)
		11'b10110100xxx: ctrl = 10'b00x00{ZeroFlag}0000 // CBZ - 0xB4 (8bit)
		11'b11111000010: ctrl = 10'bx11100x010; // LDUR =- 0x7C2 (11bit)
		11'b11111000000: ctrl = 10'b01x010x010; // STUR - 0x7C0 (11bit)
		11'b11101011000: ctrl = 10'b // SUBS - 0x658 (11bit)		
	end 
		
	
	logic Reg2Loc_out, ALUSrc_out, MemToReg_out, ALUOp_out, zero_flag;
	
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