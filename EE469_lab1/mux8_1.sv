`timescale 1ns/10ps
module mux8_1 #(parameter WIDTH=8) (in, sel, out);

	input logic [7:0][WIDTH-1:0] in;
	input logic [2:0] sel;
	output logic [WIDTH-1:0] out;
	
	logic [WIDTH-1:0] out0, out1;
	
	mux4_1 #(.WIDTH(WIDTH)) m0 (.in(in[3:0]), .sel(sel[1:0]), .out(out0)); 
	mux4_1 #(.WIDTH(WIDTH)) m1 (.in(in[7:4]), .sel(sel[1:0]), .out(out1)); 
	mux2_1 #(.WIDTH(WIDTH)) m (.in({out1, out0}), .sel(sel[2]), .out(out)); 
	
endmodule

module mux8_1_testbench #(parameter WIDTH = 8)();

	logic [7:0][WIDTH-1:0] in;
	logic [2:0] sel;
	logic [WIDTH-1:0] out;
	
	mux8_1 dut (.in, .sel, .out);
	
	initial begin
		// default reg1-31 to 0
		integer i;
		for (int i = 1; i < 32; i++) begin
			in[i] = 8'b0;
		end
		// set reg0, select reg1 -> 0	
		in[0] = 8'b10101010; 
		in[1] = 8'b1100_0011;
		in[2] = 8'b0011_1100;
		in[4] = 8'b0101_0101;
		in[7] = 8'b0110_0110;
		sel = 5'b00001;#2;
		
		// select reg0 -> 8'b10101010
		sel = 5'b00000; #2;  
		
		// set reg30
		in[30] = 8'b11111111; #2;
		
		// select reg16 -> 0
		sel = 5'b10000; #2;
	
		// select reg30 -> 8'b11111111
		sel = 5'b11110; #2; 
		
		// select reg31 -> 0
		sel = 5'b11111; #2; 

		// select reg0 -> 8'b10101010
		sel = 5'b00000; #2; 
		
		// set reg10. select reg10 -> 8'b00001111
		in[10] = 8'b00001111; sel = 5'b01010; #2;
	end
	
endmodule