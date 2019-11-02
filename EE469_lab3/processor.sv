`timescale 1ns/10ps
module processor (clk, reset);

	input logic clk, reset;
	
	logic [63:0] pc_Addr;
	logic [31:0] instruction;
	
	logic [63:0] Rd, Rm, Rn;
	logic [63:0] Aw, Ab, Aa, reg_WrEn, Dw, Da, Db;
	logic [63:0] Din, mem_Addr, mem_WrEn, Dout;
	
	logic flag_neg, flag_zero, flag_overf, flag_cOut;
	logic Reg2Loc, ALUSrc, MemToReg, RegWrite, MemWrite, BrTaken, UncondBr;
	logic [2:0] ALUOp;
	
 	program_counter pc (.clk, .reset, .pc_ext(Db), .BrTaken, .UncondBr, .CondAddr19, .BrAddr26, .pc_out(pc_Addr));
	
	instructmem instr (.address(pc_address), .instruction, .clk);
	
	control (.flag_neg, .flag_zero, .flag_overf, .flag_cOut, .instruction,
				.Reg2Loc, .ALUSrc, .MemToReg, .RegWrite, .MemWrite, .BrTaken, .UncondBr, .ALUOp);
	
	assign reg_WrEn = RegWrite;
	regfile(.ReadData1(Da), .ReadData2(Db), .WriteData(Wd), 
				.ReadRegister1(Aa),. ReadRegister2(Ab), 
				.WriteRegister(Aw), .RegWrite(reg_WrEn), .clk);
				
	datapath(.clk, .Da, .Db, .Reg2Loc, .ALUSrc, .MemToReg, .RegWrite, .MemWrite, .ALUOp, .Dw);

endmodule