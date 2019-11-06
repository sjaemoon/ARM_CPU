`timescale 1ns/10ps
module processor (clk, reset);

	// TODO: Testbench, where do we get the signal for Rd_X30?
	// I am guessing from the control, so make output logic from control.sv
	input logic clk, reset;
	logic [63:0] pc_Addr;
	
	// instruction formats
	logic [31:0] instruction;
	logic [10:0] opcode;
	logic [4:0] Rd, Rn, Rm;
	logic [8:0] DAddr9;
	logic [11:0] ALUImm12;
	logic [18:0] CondAddr19;
	logic [25:0] BrAddr26;
	logic [4:0] X30;
	logic [64:0] PCPlusFour, Db_ext;
	
	// control signals
	logic Reg2Loc, ALUSrc, MemToReg, RegWrite, MemWrite, BrTaken, UncondBr, pc_rd, Rd_X30; 
	logic [2:0] ALUOp;
	
	// flags from the ALU
	logic flag_neg, flag_zero, flag_overf, flag_cOut;
	logic flag_wr_en;
	
	//register flag out
	logic negative_o, zero_o, overflow_o, carry_out_o;

	// decodes 32-bit instruction
	assign opcode = instruction[31:21];
	assign Rd = instruction[4:0];
	assign Rn = instruction[9:5];
	assign Rm = instruction[20:16];
	assign DAddr9  = instruction[20:12];
	assign ALU_Imm12 = instruction[21:10];
	assign CondAddr19 = instruction[23:5];
	assign BrAddr26 = instruction[25:0];
	assign X30 = 5'd30;

	//Flag register
	//Takes in alu flags, stores it in register
	//When ADDS or SUBS is executed
	flag_register flag_reg (.clk, .wr_en(flag_wr_en), .negative(flag_neg), .zero(flag_zero), .overflow(flag_overf),
							.carry_out(flag_cOut), .*);
	
	//Instruction memory containing
	//Instructions for the processor
	instructmem instr (.address(pc_Addr), .instruction, .clk);
	
	//Control module for
	//the Processor
	control ctrl (.opcode, .flag_neg(negative_o), .flag_zero(zero_o), 
				  .flag_overf(overflow_o), .flag_cOut(carry_out_o), 
				  .Reg2Loc, .ALUSrc, .MemToReg, .RegWrite, .MemWrite, .BrTaken, .UncondBr, .ALUOp,
				  .flag_wr_en, .Rd_X30, .pc_rd);
	
	//Program counter block
	//Contains counter itself, necessady adders and muxes
 	program_counter pc (.clk, .reset, .pc_ext(Db_ext), .pc_rd, .CondAddr19, .BrAddr26, 
	 					.BrTaken, .UncondBr, .pc_out(pc_Addr), .PCPlusFour);
	
	//Datapath containing memory
	//Regfile
	//ALU. Only outputs Db_ext and flags.
	datapath dp (.clk, .Rd, .Rn, .Rm, .PCPlusFour, .X30, .DAddr9, .ALUImm12, 
				 .Reg2Loc, .ALUSrc, .MemToReg, .RegWrite, .MemWrite, .ALUOp, .Rd_X30, 
				 .flag_neg, .flag_zero, .flag_overf, .flag_cOut, .Db_ext);

endmodule