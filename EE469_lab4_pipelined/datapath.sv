`timescale 1ns/10ps
module datapath (clk, Rd, Rn, Rm, PCPlusFour, X30, DAddr9, ALUImm12, 
					Reg2Loc, ALUSrc, MemToReg, RegWrite, MemWrite, ALUOp, Rd_X30, 
					flag_neg, flag_zero, flag_overf, flag_cOut, Db_ext);
	
	input logic clk;	
	input logic [4:0] Rd, Rn, Rm, X30;
	input logic [63:0] PCPlusFour;
	input logic [8:0] DAddr9;
	input logic [11:0] ALUImm12;
	input logic Reg2Loc, ALUSrc, MemToReg, RegWrite, MemWrite, Rd_X30;
	input logic [2:0] ALUOp;
	output logic flag_neg, flag_zero, flag_overf, flag_cOut; 
	output logic [63:0] Db_ext;
	
	// inputs/outputs of RegFile
	logic [4:0] Aw, Aa, Ab;
	logic [63:0] Dw, Da, Db;
	// i/o of DataMemory
	logic [63:0] Din, mem_Addr, Dout;
	// i/o of muxes and alu
	logic [1:0][4:0] Reg2Loc_in0, Rd_X30_in0;
	logic [1:0][63:0] Reg2Loc_in1, Rd_X30_in1, ALUSrc_in, MemToReg_in;
	logic [4:0] Reg2Loc_out0, Rd_X30_out0;
	logic [63:0] Reg2Loc_out1, Rd_X30_out1, ALUSrc_out, MemToReg_out, ALUOp_out;
	logic negative, zero, overflow, carry_out;
	
	// sign extend DAddr9 and ALUImm12
	logic [63:0] DAddr9_se, ALUImm12_se;

	// instantiation of forwarding unit
	logic [63:0] reg1, reg2;
	forwarding_unit fu (.clk, .Rd, .Rn, .Rm, .Da, 
		.Db(ALUSrc_out), .ALU_out(ALUOp_out), .Mem_out(Dout), .reg1, .reg2);
	
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

	assign MemToReg_in[0] = ALUOp_out;
	assign MemToReg_in[1] = Dout;
	
	assign Rd_X30_in1[1] = PCPlusFour;
	assign Rd_X30_in1[0] = MemToReg_out;
	
	// instantiation of muxes and alu
	mux2_1 #(.WIDTH(5)) reg2loc_mux0 (.in(Reg2Loc_in0), .sel(Reg2Loc), .out(Reg2Loc_out0));
	mux2_1 #(.WIDTH(5)) rd_x30_mux0 (.in(Rd_X30_in0), .sel(Rd_X30), .out(Rd_X30_out0));
	mux2_1 #(.WIDTH(64)) reg2loc_mux1 (.in(Reg2Loc_in1),.sel(Reg2Loc), .out(Reg2Loc_out1));
	mux2_1 #(.WIDTH(64)) alusrc_mux (.in(ALUSrc_in),.sel(ALUSrc), .out(ALUSrc_out));
	mux2_1 #(.WIDTH(64)) memtoreg_mux (.in(MemToReg_in),.sel(MemToReg), .out(MemToReg_out));
	mux2_1 #(.WIDTH(64)) rd_x30_mux1 (.in(Rd_X30_in1), .sel(Rd_X30), .out(Rd_X30_out1));

	alu aluop_alu (.A(reg1), .B(reg2), .cntrl(ALUOp), .result(ALUOp_out), 
		.negative, .zero, .overflow, .carry_out);
	
	// instantitation of RegFile
	assign Aw = Rd_X30_out0;
	assign Aa = Rn;
	assign Ab = Reg2Loc_out0;
	assign Dw = Rd_X30_out1;
	regfile rf (.ReadData1(Da), .ReadData2(Db), .WriteData(Dw), 
					.ReadRegister1(Aa), .ReadRegister2(Ab), 
					.WriteRegister(Aw), .RegWrite, .clk);
				
	// instantiation of DataMemory
	assign Din = Db;
	assign mem_Addr = ALUOp_out;
	datamem dm (.address(mem_Addr), .write_enable(MemWrite), .read_enable(MemToReg), 
					.write_data(Db), .clk, .xfer_size(4'd8), .read_data(Dout));
	
	// assign datapath outputs
	assign flag_neg = negative;
	assign flag_zero = zero;
	assign flag_overf = overflow;
	assign flag_cOut = carry_out;
	assign Db_ext = Db;
	
endmodule

module datapath_testbench();
	logic clk;	
	logic [4:0] Rd, Rn, Rm, X30;
	logic [63:0] PCPlusFour, Db_ext;
	logic [8:0] DAddr9;
	logic [11:0] ALUImm12;
	logic Reg2Loc, ALUSrc, MemToReg, RegWrite, MemWrite, Rd_X30;
	logic [2:0] ALUOp;
	logic flag_neg, flag_zero, flag_overf, flag_cOut;

	initial $timeformat(-9, 2, " ns", 10);

	parameter ClockDelay = 100;

	initial begin // Set up the clock
		clk <= 0;
		forever #(ClockDelay/2) clk <= ~clk;
	end

	datapath dut (.*);

	int i;

	initial begin
		Rd <= 0; Rn <= 0; Rm <= 0; X30 <= 5'd30; PCPlusFour <= 0;
		DAddr9 <= 0; ALUImm12 <= 0;
		Reg2Loc <= 0; ALUSrc <= 0; MemToReg <= 0; RegWrite <= 0; MemWrite <= 0;
		Rd_X30 <= 1;
		ALUOp <= 0; @(posedge clk);

		$display("%t Writing pattern to all registers.", $time);
		for (i=0; i<31; i=i+1) begin
			RegWrite <= 0;
			X30 <= i;
			PCPlusFour <= i*64'h0000010204080001;
			@(posedge clk);
			
			RegWrite <= 1;
			@(posedge clk);
		end

		X30 <= 5'd30;
		Rd_X30 <= 0;
		
		RegWrite <= 0; @(posedge clk);

		$display("%t Read contents of Registers from Db_ext", $time);

		for (i = 0; i < 31; i++) begin
			Rd <= i;
			@(posedge clk);
			assert(Db_ext == (i * 64'h0000010204080001));
		end
		$stop;
	end
endmodule