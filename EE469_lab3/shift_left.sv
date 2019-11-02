`timescale 1ns/10ps
module shift_left #(parameter WIDTH=2) (in, out);

	input logic [63:0] in;
	output logic [63:0] out;
	
	assign out = {in[63-WIDTH:0], 'b0};
	
endmodule


module shift_left_testbench #(parameter WIDTH = 2) ();

	logic [63:0] in, out;
	
	initial begin
		in = 64'd0; #10;
		in = 64'd1; #10;
		in = 64'd2; #10;
		in = 64'd3; #10;
		in = 64'd100; #10;
		in = 64'd1023; #10;
	end

endmodule