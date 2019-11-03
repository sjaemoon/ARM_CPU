`timescale 1ns/10ps
module processor (clk, reset);

	input logic clk, reset;
	
	logic [63:0] pc_Addr;
	logic [31:0] instruction;
	
	logic Rd, Rm, Rn, PCPlusFour, X30, DAddr9, ALUImm12;
	logic Reg2Loc, ALUSrc, MemToReg, RegWrite, MemWrite, BrTaken, UncondBr;
	logic [2:0] ALUOp;
	logic flag_neg, flag_zero, flag_overf, flag_cOut;
	
	
 	program_counter pc (.clk, .reset, .pc_ext(Db_ext), .BrTaken, .UncondBr, .CondAddr19, .BrAddr26, .pc_out(pc_Addr));
	
	instructmem instr (.address(pc_address), .instruction, .clk);
	
	control ctrl (.opcode, .flag_neg, .flag_zero, .flag_overf, .flag_cOut, 
				.Reg2Loc, .ALUSrc, .MemToReg, .RegWrite, .MemWrite, .BrTaken, .UncondBr, .ALUOp);
	
	datapath dp (.clk, .Rd, .Rm, .Rn, .PCPlusFour, .X30, .DAddr9, .ALUImm12, 
					.Reg2Loc, .ALUSrc, .MemToReg, .RegWrite, .MemWrite, .ALUOp, .Rd_X30, 
					.flag_neg, .flag_zero, .flag_overf, .flag_cOut, .Db_ext);

endmodule