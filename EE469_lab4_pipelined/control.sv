`timescale 1ns/10ps
module control (
				opcode, 
				Reg2Loc, ALUSrc, MemToReg, RegWrite, MemWrite, ALUOp,
				flag_wr_en, Rd_X30);
	
	//input logic flag_neg, flag_zero, flag_overf, flag_cOut, aluFlag_zero;
	input logic [10:0] opcode;	

	output logic Reg2Loc, ALUSrc, MemToReg, RegWrite, MemWrite; 
	//BrTaken, UncondBr;
	output logic [2:0] ALUOp;

	//flag_wr_en stores flags to the flag register
	//Rd_X30 used for the purposes of Instr BL
	//pc_rd used to choose between PC logic or PC = Reg[Rd]

	output logic flag_wr_en, Rd_X30; 
	//pc_rd;

	logic [7:0] ctrl;

	assign Reg2Loc = ctrl[7];
	assign ALUSrc = ctrl[6];
	assign MemToReg = ctrl[5];
	assign RegWrite = ctrl[4];
	assign MemWrite = ctrl[3];
	//assign BrTaken = ctrl[4];
	//assign UncondBr = ctrl[3];
	assign ALUOp = ctrl[2:0];
	
	
	// control signals logic based on table
	always_comb begin
		casex (opcode)
		11'b00000000000: begin
							ctrl = 8'b00000000;
							Rd_X30 = 0;
							flag_wr_en = 0;
						 end

		//Another mux that inputs into ALUSrc Mux
		//Takes in DAddr9 or ALUImm12, controlled by
		//Reg2Loc as ADDI adds Rn + ALUImm12, therefore
		//Source of Db does not matter.
		11'b1001000100x: begin
							ctrl = 8'b11010010; // ADDI - 0x244 (10bit)
							Rd_X30 = 0;
							//pc_rd = 0;
							flag_wr_en = 0; 
							
						 end
		11'b10101011000: begin
							ctrl = 8'b10010010;// ADDS - 0x558 (11bit)  
							Rd_X30 = 0;
							//pc_rd = 0;
							flag_wr_en = 1; 
						 end
		11'b000101xxxxx: begin
							ctrl = 8'bxxx00xxx; // B - 0x05 (6bit)
							Rd_X30 = 0;
							//pc_rd = 0;
							flag_wr_en = 0; 
						 end
		11'b01010100xxx: begin
							ctrl = {5'b00x00, 3'b000}; // B.LT - 0x54 (8bit)
							Rd_X30 = 0;
							//pc_rd = 0;
							flag_wr_en = 0; 
						 end

		//Extra mux needed to hardwire X30 to Aw
		//Extra mux needed to take in PC + 4 and 
		//connect it to Dw.
		//Both mux controlled by Rd_X30
		11'b100101xxxxx: begin
							ctrl = 8'bxxx10xxx; // BL - 0x25 (6bit)
							Rd_X30 = 1;
							//pc_rd = 0;
							flag_wr_en = 0; 
						 end

		//Mux needed to choose between
		//PC in register RD or PC+4
		//controlled by pc_rd;
		11'b11010110000: begin
							ctrl = 8'b00x00xxx; // BR - 0x6B0 (11bit)
							Rd_X30 = 0;
							//pc_rd = 1;
							flag_wr_en = 0; 
						 end
		11'b10110100xxx: begin
							ctrl = {5'b00x00, 3'b000}; // CBZ - 0xB4 (8bit)
							Rd_X30 = 0;
							//pc_rd = 0;
							flag_wr_en = 0; 
						 end
		11'b11111000010: begin
							ctrl = 8'b01110010; // LDUR =- 0x7C2 (11bit)
							Rd_X30 = 0;
							//pc_rd = 0;
							flag_wr_en = 0; 
						 end
		11'b11111000000: begin
							ctrl = 8'b01x01010; // STUR - 0x7C0 (11bit)
							Rd_X30 = 0;
							//pc_rd = 0;
							flag_wr_en = 0; 
						 end
		11'b11101011000: begin
							ctrl = 8'b10010011; // SUBS - 0x658 (11bit)
							Rd_X30 = 0;
							//pc_rd = 0;
							flag_wr_en = 1;
						 end	
						 
		// To synthesize on Quartus
		default: begin
				ctrl = 8'bxxxxxxxx;
				Rd_X30 = 0;
				flag_wr_en = 1;
			end
		endcase
	end 
	
endmodule

module control_testbench();
	logic [10:0] opcode;	

	logic Reg2Loc, ALUSrc, MemToReg, RegWrite, MemWrite,
		  flag_wr_en, Rd_X30;
	logic [2:0] ALUOp; 

	control dut (.*);

	initial begin
		opcode = 11'b1001000100x; #10;
		opcode = 11'b10101011000; #10;
		opcode = 11'b000101xxxxx; #10;
		opcode = 11'b01010100xxx; #10;
		opcode = 11'b100101xxxxx; #10;
		opcode = 11'b11010110000; #10;
		opcode = 11'b10110100xxx; #10;
		opcode = 11'b11111000010; #10;
		opcode = 11'b11111000000; #10;
		opcode = 11'b11101011000; #10;
	end
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

/* Changes *******************
Ctrl bits are now 8 bits instead of 10.
Assignments changed accordingly.
BrTaken, UncondBr, and pc_rd now taken care by
the Branch Accelerator
*/