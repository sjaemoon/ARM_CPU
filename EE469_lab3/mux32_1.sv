`timescale 1ns/10ps
module mux32_1 #(parameter WIDTH=8) (in, sel, out);

	input logic [31:0][WIDTH-1:0] in;
	input logic [4:0] sel;
	output logic [WIDTH-1:0] out;
	
	logic [WIDTH-1:0] out0, out1;
	
	mux16_1 #(.WIDTH(WIDTH)) m0 (.in(in[15:0]), .sel(sel[3:0]), .out(out0)); 
	mux16_1 #(.WIDTH(WIDTH)) m1 (.in(in[31:16]), .sel(sel[3:0]), .out(out1)); 
	mux2_1 #(.WIDTH(WIDTH)) m (.in({out1, out0}), .sel(sel[4]), .out(out)); 	
	
endmodule

module mux32_1_testbench #(parameter WIDTH = 8)();

	logic [31:0][WIDTH-1:0] in;
	logic [4:0] sel;
	logic [WIDTH-1:0] out;
	
	mux32_1 dut (.in, .sel, .out);
	
	initial begin
		
		integer i;
		for (int i = 0; i < 32; i++) begin
			in[i] = i + (2 * i);
		end
		
		for (i = 0; i < 32; i++) begin
			sel = i; #2;
		end
	end
	
endmodule
	