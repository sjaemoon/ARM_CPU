`timescale 1ns/10ps
module reg_dec_staged (clk, opcode, Rd, Rn, Rm, PCPlusFour_IF, X30,
								DAddr9, ALUImm12, ALU_out, Mem_out, 
								flag_neg, flag_zero, flag_overf, flag_cOut, 
								alu_neg, alu_zero, alu_overf, alu_cOut, 
								BrTaken, UncondBr, pc_rd, reg1, reg2, PCPlusFour_out, Aw_out, 
								MemToReg_out, RegWrite_out, MemWrite_out, ALU_op_out, flag_wr_en_out, Rd_X30_out, // signals for RF
								PCPlusFour_WB, Aw_in, RegWrite_in, Rd_X30_in); // singals for WB

	input logic clk;
	input logic [10:0] opcode;
	input logic [4:0] Rd, Rn, Rm, PCPlusFour_IF, X30;
	input logic [8:0] DAddr9;
	input logic [11:0] ALUImm12;
	input logic [63:0] ALU_out, Mem_out;
	input logic flag_neg, flag_zero, flag_overf, flag_cOut, alu_neg, alu_zero, alu_overf, alu_cOut; 
	output logic BrTaken, UncondBr, pc_rd;
	output logic [63:0] reg1, reg2, PCPlusFour_out;
	output logic [4:0] Aw_out;
	output logic MemToReg_out, RegWrite_out, MemWrite_out, ALU_op_out, flag_wr_en_out, Rd_X30_out;
	input logic [4:0] PCPlusFour_WB;
	input logic [4:0] Aw_in;
	input logic RegWrite_in, Rd_X30_in;
	
	// inputs/outputs of control
	logic Reg2Loc, ALUSrc, MemToReg, RegWrite, MemWrite;
	logic [2:0] ALUOp;
	logic flag_wr_en, Rd_X30;
	// i/o of RegFile
	logic [4:0] Aw, Aa, Ab;
	logic [63:0] Dw, Da, Db;
	// i/o of muxes and alu
	logic [1:0][4:0] Reg2Loc_in0, Rd_X30_in0;
	logic [1:0][63:0] Reg2Loc_in1, Rd_X30_in1, ALUSrc_in;
	
	logic [4:0] Reg2Loc_out0, Rd_X30_out0;
	logic [63:0] Reg2Loc_out1, Rd_X30_out1, ALUSrc_out;
	
	// instantiation of control
	control ctrl (.opcode, .Reg2Loc, .ALUSrc, .MemToReg, .RegWrite, 
						.MemWrite, .ALUOp, .flag_wr_en, .Rd_X30);
	
	// sign extend DAddr9 and ALUImm12
	logic [63:0] DAddr9_se, ALUImm12_se;

	sign_extend #(.WIDTH(9)) daddr9_se (.in(DAddr9), .out(DAddr9_se));	
	sign_extend #(.WIDTH(12)) aluimm12_se (.in(ALUImm12), .out(ALUImm12_se));
	
	// set up input of the muxes
	assign Reg2Loc_in0[0] = Rd;
	assign Reg2Loc_in0[1] = Rm;
	
	assign Rd_X30_in0[0] = Rd;
	assign Rd_X30_in0[1] = X30;
	
	assign Reg2Loc_in1[0] = DAddr9_se;
	assign Reg2Loc_in1[1] = ALUImm12_se;
	
	assign ALUSrc_in[0] = Db;
	assign ALUSrc_in[1] = Reg2Loc_out1;
	
	// instantiation of muxes
	mux2_1 #(.WIDTH(5)) reg2loc_mux0 (.in(Reg2Loc_in0), .sel(Reg2Loc), .out(Reg2Loc_out0));
	mux2_1 #(.WIDTH(5)) rd_x30_mux0 (.in(Rd_X30_in0), .sel(Rd_X30), .out(Rd_X30_out0));
	mux2_1 #(.WIDTH(64)) reg2loc_mux1 (.in(Reg2Loc_in1),.sel(Reg2Loc), .out(Reg2Loc_out1));
	mux2_1 #(.WIDTH(64)) alusrc_mux (.in(ALUSrc_in),.sel(ALUSrc), .out(ALUSrc_out));
	
	// instantitation of regfile
	assign Aw = Rd_X30_out0;
	assign Aa = Rn;
	assign Ab = Reg2Loc_out0;
	assign Dw = Rd_X30_out1;
	regfile rf (.ReadData1(Da), .ReadData2(Db), .WriteData(Dw), 
					.ReadRegister1(Aa), .ReadRegister2(Ab), 
					.WriteRegister(Aw), .RegWrite, .clk);
					
	// instantiation of forwarding unit
	forwarding_unit fu (.clk, .Aw, .Aa, .Ab, .Da, .Db(ALUSrc_out), 
		.ALU_out(ALUOp_out), .Mem_out(Dout), .reg1, .reg2);
		
	// instantiation of branch accelerator
	branch_accel ba (.clk, .opcode, .flag_wr_en, .BrTaken, .UncondBr, .pc_rd, .regVal_in(reg2),
					  .flag_neg, .flag_zero, .flag_overf, .flag_cOut,
					  .alu_neg, .alu_zero, .alu_overf, .alu_cOut);
	
	// instantiation of registers
	register #(.WIDTH(1)) PCPlusFour_reg (.in(PCPlusFour), .enable(1'b1), .clk, .out(PCPlusFour_out));
	register #(.WIDTH(5)) Aw_reg (.in(Aw), .enable(1'b1), .clk, .out(Aw_out));
	register #(.WIDTH(1)) MemToReg_reg (.in(MemToReg), .enable(1'b1), .clk, .out(MemToReg_out));
	register #(.WIDTH(1)) RegWrite_reg (.in(RegWrite), .enable(1'b1), .clk, .out(RegWrite_out));
	register #(.WIDTH(1)) ALUOp_reg (.in(ALUOp), .enable(1'b1), .clk, .out(ALUOp_out));
	register #(.WIDTH(1)) flag_wr_en_reg (.in(flag_wr_en), .enable(1'b1), .clk, .out(flag_wr_en_out));
	register #(.WIDTH(1)) Rd_X30_reg (.in(Rd_X30), .enable(1'b1), .clk, .out(Rd_X30_out));
	
endmodule

module reg_dec_staged_testbench ();
	logic clk;
	logic [10:0] opcode;
	logic [4:0] Rd, Rn, Rm, PCPlusFour, X30;
	logic [8:0] DAddr9;
	logic [11:0] ALUImm12;
	logic [63:0] ALU_out, Mem_out;
	logic flag_neg, flag_zero, flag_overf, flag_cOut, alu_neg, alu_zero, alu_overf, alu_cOut; 
	logic BrTaken, UncondBr, pc_rd;
	logic [63:0] reg1, reg2, PCPlusFour_out;
	logic [4:0] Aw_out;
	logic MemToReg_out, RegWrite_out, MemWrite_out, ALU_op_out, flag_wr_en_out, Rd_X30_out;
	
	parameter ClockDelay = 100;
	initial begin // Set up the clock
		clk <= 0;
		forever #(ClockDelay/2) clk <= ~clk;
	end

	reg_dec_staged dut (.*);
	
	int i;

	initial begin
		Rd <= 0; Rn <= 0; Rm <= 0; PCPlusFour <= 0; X30 <= 5'd30; 
		DAddr9 <= 0; ALUIMm12 <= 0; ALU_out <= 0; Mem_out <= 0; 
		flag_neg <= 0;  flag_zero <= 0; flag_overf <= 0; flag_cOut <= 0;
		alu_neg <= 0;  alu_zero <= 0; alu_overf <= 0; alu_cOut <= 0; 
		opcode <= 0;
		
		$stop;
	end
endmodule