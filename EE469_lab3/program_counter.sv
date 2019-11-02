module program_counter (clk, reset, pc_in, BrTaken, UncondBr, CondAddr19, BrAddr26, pc_out);

	input logic	clk, reset, BrTaken, UncondBr;
	input logic [63:0] pc_in;
	output logic [63:0] pc_out;
	
	logic pc_out0, pc_out1;
	logic [1:0] mux2_sig;
	
	n_bit_adder adder0 (.A(pc_in), .B(3'b100), .result(pc0));
	
	// extract address
	n_bit_adder adder1 (.A(pc_in), .B(), .result(pc1));
	
	assign mux2_sig[0] = pc_out0;
	assign mux2_sig[1] = pc_out1;
	mux2_1 mux0 #(.WIDTH(64)) mux2 (.in(mux2_sig), .sel(BrTaken), .out(pc_out));

endmodule