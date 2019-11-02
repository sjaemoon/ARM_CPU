`timescale 1ns/10ps
module sign_extend #(parameter WIDTH=8) (se_in, se_out);

	input logic [WIDTH-1:0] se_in;
	output logic [63:0] se_out;
	
//	assign se_out[WIDTH-2:0] = se_in[WIDTH-2:0];
//	assign se_out[63:WIDTH-1] = {(63-WIDTH-1){se_in[WIDTH-1]}};
	assign se_out = {(64-WIDTH){se_in[WIDTH - 1]}, se_in};
	
endmodule


module sign_extend_testbench #(parameter WIDTH = 8) ();

	logic [WIDTH-1:0] se_in;
	logic [63:0] se_out;
	
	initial begin
		se_in = 1'b0; #10;
		se_in = 1'b1; #10;
		se_in = 2'b01; #10;
		se_in = 2'b11; #10;
		se_in = 10'b0000011111; #10;
		se_in = 10'b1111100000; #10;
	end

endmodule