// Test bench for ALU
`timescale 1ns/10ps

// Meaning of signals in and out of the ALU:

// Flags:
// negative: whether the result output is negative if interpreted as 2's comp.
// zero: whether the result output was a 64-bit zero.
// overflow: on an add or subtract, whether the computation overflowed if the inputs are interpreted as 2's comp.
// carry_out: on an add or subtract, whether the computation produced a carry-out.

// cntrl			Operation						Notes:
// 000:			result = B						value of overflow and carry_out unimportant
// 010:			result = A + B
// 011:			result = A - B
// 100:			result = bitwise A & B		value of overflow and carry_out unimportant
// 101:			result = bitwise A | B		value of overflow and carry_out unimportant
// 110:			result = bitwise A XOR B	value of overflow and carry_out unimportant

module alustim();

	parameter delay = 100000;

	logic		[63:0]	A, B;
	logic		[2:0]		cntrl;
	logic		[63:0]	result;
	logic					negative, zero, overflow, carry_out ;

	parameter ALU_PASS_B=3'b000, ALU_ADD=3'b010, ALU_SUBTRACT=3'b011, ALU_AND=3'b100, ALU_OR=3'b101, ALU_XOR=3'b110;
	

	alu dut (.A, .B, .cntrl, .result, .negative, .zero, .overflow, .carry_out);

	// Force %t's to print in a nice format.
	initial $timeformat(-9, 2, " ns", 10);

	integer i;
	logic [63:0] test_val;
	initial begin
	
		$display("%t testing PASS_B operations", $time);
		cntrl = ALU_PASS_B;
		for (i=0; i<50; i++) begin
			A = $random(); B = $random();
			#(delay);
			assert(result == B && negative == B[63] && zero == (B == '0));
		end
		
		$display("%t testing addition", $time);
		cntrl = ALU_ADD;
		A = 64'h0000000000000001; B = 64'h0000000000000001;
		#(delay);
		assert(result == 64'h0000000000000002 && carry_out == 0 && overflow == 0 && negative == 0 && zero == 0);

		A = 64'h7fffffffffffffff; B = 64'h7fffffffffffffff; 
		#(delay);
		assert(result == 64'hfffffffffffffffe && carry_out == 0 && overflow == 1 && negative == 1 && zero == 0);

		$display("%t testing XOR operation", $time);
		A = 64'h70000000000000cc; B = 64'h700000000000001a; cntrl = ALU_XOR; //XOR Operation
		#(delay);
		assert(result == 64'h00000000000000d6 && carry_out == 0 && overflow == 0 && negative == 0 && zero == 0);

		$display("%t testing AND operations", $time);
		cntrl = ALU_AND;
		A = 64'h0;
		for (i = 0; i < 50; i++) begin
			B = $random();
			#(delay);
			assert (result == 64'h0 && carry_out == 0 && overflow == 0 && negative == 0 && zero == 1);
		end

		$display("%t testing SUB operations", $time);
		cntrl = ALU_SUBTRACT;
		A = 64'h1; B = 64'h2;
		#(delay);
		assert(result == 64'hffffffffffffffff && carry_out == 0 && overflow == 0 && negative == 1 && zero == 0);

		//A = MAX_INT64, B = -3
		A = 64'h7fffffffffffffff; B = 64'h8ffffffffffffffd;
		#(delay);
		assert(carry_out == 0 && overflow == 1 && negative == 1 && zero == 0);

		A = 64'hffffffffffffffff; B = 64'h1;
		#(delay);
		assert(carry_out == 1 && overflow == 0 && negative == 1 && zero == 0);

		A = 64'h8000000000000000; B = 64'h2;
		#(delay);
		assert(carry_out == 1 && overflow == 1 && negative == 0 && zero == 0);

	end
endmodule