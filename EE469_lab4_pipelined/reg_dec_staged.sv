`timescale 1ns/10ps
module reg_dec_staged (clk, opcode, Rd, Rn, Rm, X30,

						DAddr9, ALUImm12, PCPlusFour_IF, ALU_out, Mem_out, 

						flag_neg, flag_zero, flag_overf, flag_cOut, 
						alu_neg, alu_zero, alu_overf, alu_cOut, 

						BrTaken, UncondBr, pc_rd, reg1, reg2, reg2_IF, PCPlusFour_out, Aw_out, 

						MemToReg_out, RegWrite_out, MemWrite_out, ALU_op_out, flag_wr_en_out, Rd_X30_out, // signals for RF

						PCPlusFour_WB, MemStage_in, Aw_in, Rd_X30_WB, RegWrite_in); // singals for WB

	input logic clk;
	//input from instr
	input logic [10:0] opcode;
	input logic [4:0] Rd, Rn, Rm, X30; 
	input logic [8:0] DAddr9; 
	input logic [11:0] ALUImm12; 
	input logic [31:0] PCPlusFour_IF; 
	// input from ALU and mem_staged for forwarding unit
	input logic [63:0] ALU_out, Mem_out; 
	// input from alu_staged
	input logic flag_neg, flag_zero, flag_overf, flag_cOut, alu_neg, alu_zero, alu_overf, alu_cOut; 
	//input from mem_staged
	input logic [63:0] PCPlusFour_WB, MemStage_in; 
	input logic [4:0] Aw_in; 
	input logic Rd_X30_WB, RegWrite_in; 

	//output to PC counter calculator
	output logic BrTaken, UncondBr, pc_rd; 
	//output to alu_staged
	output logic [63:0] reg1, reg2, reg2_IF, PCPlusFour_out; 
	output logic [4:0] Aw_out; 
	output logic MemToReg_out, RegWrite_out, MemWrite_out, ALU_op_out, flag_wr_en_out, Rd_X30_out; 

	// inputs/outputs of control
	logic Reg2Loc, ALUSrc, MemToReg, RegWrite, MemWrite;
	logic [2:0] ALUOp;
	logic flag_wr_en, Rd_X30;
	// i/o of RegFile
	logic [4:0] Aw, Aa, Ab;
	logic [63:0] Dw, Da, Db;
	// i/o of muxes and alu
	logic [1:0][4:0] Reg2Loc_in0, Rd_X30_in0;
	logic [1:0][63:0] Reg2Loc_in1, ALUSrc_in, Rd_X30_in1;
	
	logic [4:0] Reg2Loc_out0, Rd_X30_out0;
	logic [63:0] Reg2Loc_out1, Rd_X30_out1, ALUSrc_out, reg1_internal, reg2_internal;
	
	// instantiation of control
	control ctrl (.opcode, .Reg2Loc, .ALUSrc, .MemToReg, .RegWrite, 
						.MemWrite, .ALUOp, .flag_wr_en, .Rd_X30);
	
	// sign extend DAddr9 and ALUImm12
	logic [63:0] DAddr9_se, ALUImm12_se;

	// Register Fetch stage
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
	
	// Write Back stage
	// set up input of the muxes
	assign Rd_X30_in1[1] = PCPlusFour_WB;
	assign Rd_X30_in1[0] = MemStage_in;
	
	// instantiation of muxes
	mux2_1 #(.WIDTH(64)) rd_x30_mux1 (.in(Rd_X30_in1), .sel(Rd_X30_WB), .out(Rd_X30_out1));
	
	// Requried units
	// instantitation of regfile
	assign Aw = Aw_in;
	assign Aa = Rn;
	assign Ab = Reg2Loc_out0;
	assign Dw = Rd_X30_out1;

	assign reg2_IF = reg2_internal;

	regfile rf (.ReadData1(Da), .ReadData2(Db), .WriteData(Dw), 
					.ReadRegister1(Aa), .ReadRegister2(Ab), 
					.WriteRegister(Aw), .RegWrite, .clk);
					
	// instantiation of forwarding unit
	forwarding_unit fu (.clk, .Aw(Rd_X30_out0), .Aa, .Ab, .Da, .Db(ALUSrc_out), 
		.ALU_out(ALUOp_out), .Mem_out(Dout), .reg1(reg1_internal), .reg2(reg2_internal));
		
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
	register #(.WIDTH(64)) reg1_out (.in(reg1_internal), .enable(1'b1), .clk, .out(reg1));
	register #(.WIDTH(64)) reg2_out (.in(reg2_internal), .enable(1'b1), .clk, .out(reg2));
	
endmodule

module reg_dec_staged_testbench ();
	logic clk;
	//input from instr
	logic [10:0] opcode;
	logic [4:0] Rd, Rn, Rm, X30; 
	logic [8:0] DAddr9; 
	logic [11:0] ALUImm12; 
	logic [63:0] PCPlusFour_IF; 
	// input from ALU and mem_staged for forwarding unit
	logic [63:0] ALU_out, Mem_out; 
	// input from alu_staged
	logic flag_neg, flag_zero, flag_overf, flag_cOut, alu_neg, alu_zero, alu_overf, alu_cOut; 
	//input from mem_staged
	logic [63:0] PCPlusFour_WB, MemStage_in; 
	logic [4:0] Aw_in; 
	logic Rd_X30_WB, RegWrite_in; 

	//output to PC counter calculator
	logic BrTaken, UncondBr, pc_rd; 
	//output to alu_staged
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
		// ADDS X0 X1 X2 and write 50 to X5
		opcode <= 11'h558; Rd <= 5'd0; Rn <= 5'd1; Rm <= 5'd2; 
		DAddr9 <= 9'd10; ALUImm12 <= 12'd5; PCPlusFour_IF <= 64'd100; ALU_out <= 64'd16; Mem_out <= 64'd32;
		flag_neg <= 0;  flag_zero <= 0; flag_overf <= 0; flag_cOut <= 0;
		alu_neg <= 0;  alu_zero <= 0; alu_overf <= 0; alu_cOut <= 0;	
		PCPlusFour_WB <= 64'd88; MemStage_in <= 64'd50; Aw_in <= 5'd5; RegWrite_in <= 1; Rd_X30_WB <= 0;
		@(posedge clk);
		
		// SUBS X10 X1 X2 and don't write
		opcode <= 11'h758; Rd <= 5'd10; Rn <= 5'd1; Rm <= 5'd2; 
		DAddr9 <= 9'd10; ALUImm12 <= 12'd5; PCPlusFour_IF <= 64'd104; ALU_out <= 64'd81; Mem_out <= 64'd16;
		flag_neg <= 0;  flag_zero <= 0; flag_overf <= 0; flag_cOut <= 0;
		alu_neg <= 0;  alu_zero <= 0; alu_overf <= 0; alu_cOut <= 0;	
		PCPlusFour_WB <= 64'd92; MemStage_in <= 64'd100; Aw_in <= 5'd5; RegWrite_in <= 0; Rd_X30_WB <= 1;
		@(posedge clk);
		
		// ADDI X3 X31 #8 and take in PC+4
		// 244 -> 10 0100 0100 0
		opcode <= 11'b10010001000; Rd <= 5'd3; Rn <= 5'd31; Rm <= 5'd2; 
		DAddr9 <= 9'd10; ALUImm12 <= 12'd8; PCPlusFour_IF <= 64'd108; ALU_out <= 64'd1; Mem_out <= 64'd81;
		flag_neg <= 0;  flag_zero <= 0; flag_overf <= 0; flag_cOut <= 0;
		alu_neg <= 0;  alu_zero <= 0; alu_overf <= 0; alu_cOut <= 0;	
		PCPlusFour_WB <= 64'd96; MemStage_in <= 64'd100; Aw_in <= 5'd5; RegWrite_in <= 1; Rd_X30_WB <= 1;
		@(posedge clk);
		
		// ADDS X4 X3 X10, requires forwarding unit, write 99 to 1
		opcode <= 11'h558; Rd <= 5'd4; Rn <= 5'd31; Rm <= 5'd10; 
		DAddr9 <= 9'd10; ALUImm12 <= 12'd8; PCPlusFour_IF <= 64'd112; ALU_out <= 64'd100; Mem_out <= 64'd1;
		flag_neg <= 0;  flag_zero <= 0; flag_overf <= 0; flag_cOut <= 0;
		alu_neg <= 0;  alu_zero <= 0; alu_overf <= 0; alu_cOut <= 0;	
		PCPlusFour_WB <= 64'd100; MemStage_in <= 64'd99; Aw_in <= 5'd1; RegWrite_in <= 1; Rd_X30_WB <= 0;
		@(posedge clk);
		
		// LDUR X3 [X0, #4], don't write
		// ->
		opcode <= 11'h7C2; Rd <= 5'd3; Rn <= 5'd0; Rm <= 5'd2; 
		DAddr9 <= 9'd4; ALUImm12 <= 12'd8; PCPlusFour_IF <= 64'd116; ALU_out <= 64'd18; Mem_out <= 64'd100;
		flag_neg <= 0;  flag_zero <= 0; flag_overf <= 0; flag_cOut <= 0;
		alu_neg <= 0;  alu_zero <= 0; alu_overf <= 0; alu_cOut <= 0;	
		PCPlusFour_WB <= 64'd104; MemStage_in <= 64'd99; Aw_in <= 5'd1; RegWrite_in <= 0; Rd_X30_WB <= 0;	
		@(posedge clk);
		
		// CBZ X4 4, requires forwarding unit, don't write
		// -> B4 = 1011 0100 000
		opcode <= 11'b10110100000; Rd <= 5'd4; Rn <= 5'd31; Rm <= 5'd2; 
		DAddr9 <= 9'd10; ALUImm12 <= 12'd8; PCPlusFour_IF <= 64'd120; ALU_out <= 64'd2; Mem_out <= 64'd18;
		flag_neg <= 0;  flag_zero <= 0; flag_overf <= 0; flag_cOut <= 0;
		alu_neg <= 0;  alu_zero <= 0; alu_overf <= 0; alu_cOut <= 0;	
		PCPlusFour_WB <= 64'd108; MemStage_in <= 64'd99; Aw_in <= 5'd1; RegWrite_in <= 0; Rd_X30_WB <= 0;
		@(posedge clk);
		
		// BR X5, don't write
		opcode <= 11'b11010110000; Rd <= 5'd5; Rn <= 5'd31; Rm <= 5'd2; 
		DAddr9 <= 9'd10; ALUImm12 <= 12'd8; PCPlusFour_IF <= 64'd124; ALU_out <= 64'd0; Mem_out <= 64'd2;
		flag_neg <= 0;  flag_zero <= 0; flag_overf <= 0; flag_cOut <= 0;
		alu_neg <= 0;  alu_zero <= 0; alu_overf <= 0; alu_cOut <= 0;	
		PCPlusFour_WB <= 64'd112; MemStage_in <= 64'd99; Aw_in <= 5'd1; RegWrite_in <= 0; Rd_X30_WB <= 0;
		@(posedge clk);
		
		$stop;
	end
endmodule
