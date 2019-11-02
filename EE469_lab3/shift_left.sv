`timescale 1ns/10ps
module shift_left #(parameter WIDTH=2) (sl_in, sl_out);

	input logic [63:0] sl_in;
	output logic [63:0] sl_out;
	
	assign sl_out = {sl_in[61:0], 2'b00};
	
endmodule


module shift_left_testbench #(parameter WIDTH = 2) ();

	logic [63:0] sl_in, sl_out;
	
	initial begin
		sl_in = 64'd0; #10;
		s1_in = 64'd1; #10;
		sl_in = 64'd2; #10;
		s1_in = 64'd3; #10;
		sl_in = 64'd100; #10;
		sl_in = 64'd1023; #10;
	end

endmodule