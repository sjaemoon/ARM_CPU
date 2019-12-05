`timescale 1ns/10ps
module forwarding_unit (clk, Aw, Aa, Ab, Da, Db, ALUSrc, RegWrite, ALU_out, Mem_out, reg1, reg2, 
						Rd_X30_sel1, Rd_X30_sel2, PCPlusFour1, PCPlusFour2,
						opcode, Dbmem_in, Dbmem_out);

	input logic clk, ALUSrc, Rd_X30_sel1, Rd_X30_sel2, RegWrite;
	input logic [4:0] Aw, Aa, Ab;
	input logic [63:0] Da, Db, ALU_out, Mem_out, PCPlusFour1, PCPlusFour2, Dbmem_in;
	input logic [10:0] opcode;
	output logic [63:0] reg1, reg2, Dbmem_out;

	
	logic [4:0] Aw_1cyc, Aw_2cyc;
	logic [1:0] reg1_sel, reg2_sel, Db_mux_sel;
	logic [3:0][63:0] reg1_mux_in, reg2_mux_in, Db_mux_in;
	logic [1:0][63:0] memout, aluout;
	logic RegWrite_1cyc;//, RegWrite_2cyc;
	
	register #(.WIDTH(5)) r1 (.in(Aw), .enable(1'b1), .clk, .out(Aw_1cyc));
	register #(.WIDTH(5)) r2 (.in(Aw_1cyc), .enable(1'b1), .clk, .out(Aw_2cyc));
	register #(.WIDTH(1)) wr_reg (.in(RegWrite), .enable(1'b1), .clk, .out(RegWrite_1cyc));

	always_comb begin 
		if (Aa == 5'd31 || (~RegWrite_1cyc && ~(opcode == 11'b11111000000)))
			reg1_sel = 2'b00;
		else
			casex({(Aa == Aw_2cyc), (Aa == Aw_1cyc)})
				2'b00: reg1_sel = 2'b00;
				2'b01: reg1_sel = 2'b01;
				2'b10: reg1_sel = 2'b10;
				2'b11: reg1_sel = 2'b01;
				2'bx0: reg1_sel = 2'b00;
				2'b0x: reg1_sel = 2'b00;
				2'bx1: reg1_sel = 2'b01;
				2'b1x: reg1_sel = 2'b10;
				default: reg1_sel = 2'b00;
			endcase
			
		if (Ab == 5'd31 || (~RegWrite_1cyc && ~(opcode == 11'b11111000000)))
			reg2_sel = 2'b00;
		else begin
			casex({(Ab == Aw_2cyc && ~(ALUSrc == 1)), (Ab == Aw_1cyc && ~(ALUSrc == 1))})
				2'b00: reg2_sel = 2'b00;
				2'b01: reg2_sel = 2'b01;
				2'b10: reg2_sel = 2'b10;
				2'b11: reg2_sel = 2'b01;
				2'b0x: reg2_sel = 2'b00;
				2'bx0: reg2_sel = 2'b00;
				2'bx1: reg2_sel = 2'b01;
				2'b1x: reg2_sel = 2'b10;
				default: reg2_sel = 2'b00;
			endcase


			casex({(Ab == Aw_2cyc), (Ab == Aw_1cyc)})
				2'b00: Db_mux_sel = 2'b00;
				2'b01: Db_mux_sel = 2'b01;
				2'b10: Db_mux_sel = 2'b10;
				2'b11: Db_mux_sel = 2'b01;
				2'b0x: Db_mux_sel = 2'b00;
				2'bx0: Db_mux_sel = 2'b00;
				2'bx1: Db_mux_sel = 2'b01;
				2'b1x: Db_mux_sel = 2'b10;
			endcase
		end
	end

	assign aluout[0] = ALU_out;
	assign aluout[1] = PCPlusFour1;

	assign memout[0] = Mem_out;
	assign memout[1] = PCPlusFour2;

	assign reg1_mux_in[0] = Da;
	//assign reg1_mux_in[1] = ALU_out;
	//assign reg1_mux_in[2] = Mem_out;
	assign reg1_mux_in[3] = 64'b0;
	
	assign reg2_mux_in[0] = Db;
	//assign reg2_mux_in[1] = ALU_out;
	//assign reg2_mux_in[2] = Mem_out;
	assign reg2_mux_in[3] = 64'b0;

	assign Db_mux_in[0] = Dbmem_in;
	assign Db_mux_in[3] = 64'b0;

	mux2_1 #(.WIDTH(64)) aluout1_mux (.in(aluout), .sel(Rd_X30_sel1), .out(reg1_mux_in[1]));
	mux2_1 #(.WIDTH(64)) aluout2_mux (.in(aluout), .sel(Rd_X30_sel1), .out(reg2_mux_in[1]));
	mux2_1 #(.WIDTH(64)) aluout3_mux (.in(aluout), .sel(Rd_X30_sel1), .out(Db_mux_in[1]));
	mux2_1 #(.WIDTH(64)) memout1_mux (.in(memout), .sel(Rd_X30_sel2), .out(reg1_mux_in[2]));
	mux2_1 #(.WIDTH(64)) memout2_mux (.in(memout), .sel(Rd_X30_sel2), .out(reg2_mux_in[2]));
	mux2_1 #(.WIDTH(64)) memout3_mux (.in(memout), .sel(Rd_X30_sel2), .out(Db_mux_in[2]));
	
	
	mux4_1 #(.WIDTH(64)) reg1_mux (reg1_mux_in, reg1_sel, reg1);
	mux4_1 #(.WIDTH(64)) reg2_mux (reg2_mux_in, reg2_sel, reg2);
	mux4_1 #(.WIDTH(64)) Db_mux (.in(Db_mux_in), .sel(Db_mux_sel), .out(Dbmem_out));

endmodule


module forwarding_unit_testbench ();
	logic clk;
	logic [4:0] Aw, Aa, Ab;
	logic [63:0] Da, Db, ALU_out, Mem_out;
	logic [63:0] reg1, reg2;
	
	parameter ClockDelay = 100;

	initial begin // Set up the clock
		clk <= 0;
		forever #(ClockDelay/2) clk <= ~clk;
	end

	forwarding_unit dut (.*);
	
	initial begin
		Aw <= 5'd2; Aa <= 5'd1; Ab <= 5'd0; Da <= 64'd8; Db <= 64'd16; ALU_out <= 64'd32; Mem_out <= 64'd64; @(posedge clk);
		assert(reg1 == Da && reg2 == Db); 
		Aw <= 5'd3; Aa <= 5'd2; Ab <= 5'd0; Da <= 64'd12; Db <= 64'd16; ALU_out <= 64'd24; Mem_out <= 64'd64; @(posedge clk);
		assert(reg1 == ALU_out && reg2 == Db); 
		Aw <= 5'd4; Aa <= 5'd3; Ab <= 5'd2; Da <= 64'd10; Db <= 64'd24; ALU_out <= 64'd20; Mem_out <= 64'd24; @(posedge clk);
		assert(reg1 == ALU_out && reg2 == Mem_out); 
		Aw <= 5'd5; Aa <= 5'd3; Ab <= 5'd4; Da <= 64'd10; Db <= 64'd28; ALU_out <= 64'd34; Mem_out <= 64'd100; @(posedge clk);
		assert(reg1 == Mem_out && reg2 == ALU_out); 
		Aw <= 5'd6; Aa <= 5'd6; Ab <= 5'd5; Da <= 64'd64; Db <= 64'd0; ALU_out <= 64'd38; Mem_out <= 64'd100; @(posedge clk);
		assert(reg1 == Da && reg2 == ALU_out); 
		Aw <= 5'd7; Aa <= 5'd3; Ab <= 5'd4; Da <= 64'd28; Db <= 64'd38; ALU_out <= 64'd64; Mem_out <= 64'd100; @(posedge clk);
		assert(reg1 == Da && reg2 == Db); 
		$stop;		
	end
	
endmodule
