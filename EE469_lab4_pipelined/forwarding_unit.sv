`timescale 1ns/10ps
module forwarding_unit (clk, Aw, Aa, Ab, Da, Db, ALU_out, Mem_out, reg1, reg2);

	input logic clk;
	input logic [4:0] Aw, Aa, Ab;
	input logic [63:0] Da, Db, ALU_out, Mem_out;
	output logic [63:0] reg1, reg2;
	
	logic [4:0] Aw_1cyc, Aw_2cyc;
	logic [1:0] reg1_sel, reg2_sel;
	logic [3:0][63:0] reg1_mux_in, reg2_mux_in;
	
	register #(.WIDTH(5)) r1 (.in(Aw), .enable(1'b1), .clk, .out(Aw_1cyc));
	register #(.WIDTH(5)) r2 (.in(Aw_1cyc), .enable(1'b1), .clk, .out(Aw_2cyc));
	
	always_comb begin 
		if (Aa == 5'd31)
			reg1_sel = 2'b00;
		else
			casex({(Aa == Aw_2cyc), (Aa == Aw_1cyc)})
				2'b00: reg1_sel = 2'b00;
				2'b01: reg1_sel = 2'b01;
				2'b10: reg1_sel = 2'b10;
				2'b11: reg1_sel = 2'b01;
				2'bx1: reg1_sel = 2'b01;
				2'b1x: reg1_sel = 2'b10;
				default: reg1_sel = 2'b00;
			endcase
		if (Ab == 5'd31)
			reg2_sel = 2'b00;
		else
			casex({(Ab == Aw_2cyc), (Ab == Aw_1cyc)})
				2'b00: reg2_sel = 2'b00;
				2'b01: reg2_sel = 2'b01;
				2'b10: reg2_sel = 2'b10;
				2'b11: reg2_sel = 2'b01;
				2'bx1: reg2_sel = 2'b01;
				2'b1x: reg2_sel = 2'b10;
				default: reg2_sel = 2'b00;
			endcase
	end
	
	assign reg1_mux_in[0] = Da;
	assign reg1_mux_in[1] = ALU_out;
	assign reg1_mux_in[2] = Mem_out;
	assign reg1_mux_in[3] = 64'b0;
	
	assign reg2_mux_in[0] = Db;
	assign reg2_mux_in[1] = ALU_out;
	assign reg2_mux_in[2] = Mem_out;
	assign reg2_mux_in[3] = 64'b0;
	
	mux4_1 #(.WIDTH(64)) reg1_mux (reg1_mux_in, reg1_sel, reg1);
	mux4_1 #(.WIDTH(64)) reg2_mux (reg2_mux_in, reg2_sel, reg2);

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
