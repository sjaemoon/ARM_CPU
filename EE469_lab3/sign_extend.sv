`timescale 1ns/10ps
module sign_extend #(parameter WIDTH=8) (in, out);

	input logic [WIDTH-1:0] in;
	output logic [63:0] out;

	assign out = {(64-WIDTH){in[WIDTH - 1]}, in};
	
endmodule


module sign_extend_testbench #(parameter WIDTH = 8) ();

	logic [WIDTH-1:0] in;
	logic [63:0] out;
	
	initial begin
		in = 1'b0; #10;
		in = 1'b1; #10;
		in = 2'b01; #10;
		in = 2'b11; #10;
		in = 10'b0000011111; #10;
		in = 10'b1111100000; #10;
	end

endmodule