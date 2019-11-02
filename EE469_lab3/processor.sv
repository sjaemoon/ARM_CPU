`timescale 1ns/10ps
module processor (clk, reset);

	input logic clk;
	
	instructmem instr (.address, .instruction, .clk);


endmodule