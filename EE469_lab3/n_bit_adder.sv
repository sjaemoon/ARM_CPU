`timescale 1ns/10ps
module n_bit_adder (A, B, result);
    input logic [63:0] A, B;
    output logic [63:0] result;

    //Signals for CarryOut from each full adder
    //Signals for Sum from each full adder
    logic [63:0] next_carry, sum_out;

    //bit 0 adder
    full_adder adder0 (.a(A[0]), .b(B[0]), .Cin(cntrl[0]), 
							  .Cout(next_carry[0]), .out(sum_out[0]));
    
    genvar i;
    //Generate bits 1-63
    generate 
        for(i = 1; i < 64; i++) begin : full_adders
            full_adder adderN (.a(A[i]), .b(B[i]), .Cin(next_carry[i - 1]), 
										 .Cout(next_carry[i]), .out(sum_out[i]);
        end
    endgenerate
						 
	 assign result = sum_out;
						 
endmodule