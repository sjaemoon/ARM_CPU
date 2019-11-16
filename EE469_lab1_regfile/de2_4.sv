`timescale 1ns/10ps
module de2_4 (in, en, out);

	input logic [1:0] in;
	input logic en;
	output logic [3:0] out;
	
	logic inv0, inv1;
	not #0.05 NOT0 (inv0, in[0]);
	not #0.05 NOT1 (inv1, in[1]);
	and #0.05 AND0 (out[0], en, inv1, inv0);
	and #0.05 AND1 (out[1], en, inv1, in[0]);
	and #0.05 AND2 (out[2], en, in[1], inv0);
	and #0.05 AND3 (out[3], en, in[1], in[0]);
	
endmodule

module de2_4_testbench();

	logic [1:0] in;
	logic en;
	logic [3:0] out;
	
	de2_4 dut (.in, .en, .out);
	
	initial begin
		in[1] = 0; in[0] = 0; en = 0; #10;
		in[1] = 0; in[0] = 1; en = 0; #10;
		in[1] = 1; in[0] = 0; en = 0; #10;
		in[1] = 1; in[0] = 1; en = 0; #10;
		in[1] = 0; in[0] = 0; en = 1; #10;
		in[1] = 0; in[0] = 1; en = 1; #10;
		in[1] = 1; in[0] = 0; en = 1; #10;
		in[1] = 1; in[0] = 1; en = 1; #10;
	end

endmodule
