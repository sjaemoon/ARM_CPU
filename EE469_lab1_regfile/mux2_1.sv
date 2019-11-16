`timescale 1ns/10ps
module mux2_1 #(parameter WIDTH=8) (in, sel, out);

	input logic [1:0][WIDTH-1:0] in;
	input logic sel;
	output logic [WIDTH-1:0] out;
	
	logic [WIDTH-1:0]	out0, out1, out2;
	
	genvar i;
	generate
		// out = (in[1] & sel_mask) | (in[0] & ~sel_mask);
		for (i = 0; i < WIDTH; i++) begin : mask
			not #0.05 NOT0 (out0[i], sel);
			and #0.05 AND1 (out1[i], in[1][i], sel);
			and #0.05 AND2 (out2[i], in[0][i], out0[i]);
			or #0.05 OR3 (out[i], out1[i], out2[i]);
		end
	endgenerate
	
endmodule


module mux2_1_testbench #(parameter WIDTH=8) ();

	logic [1:0][WIDTH-1:0] in;
	logic sel;
	logic [WIDTH-1:0] out;
	
	mux2_1 dut (.in, .sel, .out);
	
	initial begin
		in[0] = 8'b0000000; in[1] = 8'b00000001; sel = 1'b0; #2;
		sel = 1'b1; #2;
		#2;
		sel = 1'b0;#2;
		in[0] = 8'b00001111; in[1] = 8'b11110000; #2;
		sel = 1'b1; #2;
	end
	
endmodule