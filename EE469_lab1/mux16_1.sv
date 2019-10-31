`timescale 1ns/10ps
module mux16_1 #(parameter WIDTH=8) (in, sel, out);

	input logic [15:0][WIDTH-1:0] in;
	input logic [3:0] sel;
	output logic [WIDTH-1:0] out;
	
	logic [WIDTH-1:0] out0, out1;
	
	mux8_1 #(.WIDTH(WIDTH)) m0 (.in(in[7:0]), .sel(sel[2:0]), .out(out0)); 
	mux8_1 #(.WIDTH(WIDTH)) m1 (.in(in[15:8]), .sel(sel[2:0]), .out(out1)); 
	mux2_1 #(.WIDTH(WIDTH)) m (.in({out1, out0}), .sel(sel[3]), .out(out)); 
	
endmodule

module mux16_1_testbench #(parameter WIDTH = 8)();

	logic [15:0][WIDTH-1:0] in;
	logic [3:0] sel;
	logic [WIDTH-1:0] out;
	
	mux16_1 dut (.in, .sel, .out);
	
	integer i;
	initial begin
		// default reg1-31 to 0
		
		for (i = 0; i < 32; i++) begin
			in[i] = 8'b0;
		end
		// set reg0, select reg1 -> 0	
		in[0] = 8'b1010_1010; 
		in[1] = 8'b1100_0011;
		in[2] = 8'b0011_1100;
		in[4] = 8'b0101_0101;
		in[7] = 8'b0110_0110;
		
		for (i = 0; i < 16; i++) begin
			sel = i; #2;
		end
	end
	
endmodule