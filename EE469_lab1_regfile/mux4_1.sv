`timescale 1ns/10ps
module mux4_1 #(parameter WIDTH=8) (in, sel, out);

	input logic [3:0][WIDTH-1:0] in;
	input logic [1:0] sel;
	output logic [WIDTH-1:0] out;
	
	logic [WIDTH-1:0] out0, out1;
	
	mux2_1 #(.WIDTH(WIDTH)) m0 (.in(in[1:0]), .sel(sel[0]), .out(out0)); 
	mux2_1 #(.WIDTH(WIDTH)) m1 (.in(in[3:2]), .sel(sel[0]), .out(out1)); 
	mux2_1 #(.WIDTH(WIDTH)) m (.in({out1, out0}), .sel(sel[1]), .out(out)); 
	
endmodule

module mux4_1_testbench #(parameter WIDTH=8)();

	logic [3:0][WIDTH-1:0] in;
	logic [1:0] sel;
	logic [WIDTH-1:0] out;

	mux4_1 dut (.in, .sel, .out);

	integer i;

	initial begin
		in[0] = 8'b1100_0110; in[1] = 8'b1010_0101; in[2] = 8'b1111_0000;
		in[3] = 8'b0000_1111; 

		for(i = 0; i < 4; i++) begin
			sel = i; #2;
		end
	end

endmodule