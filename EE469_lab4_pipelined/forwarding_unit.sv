`timescale 1ns/10ps
module forwarding_unit (clk, Rd, Rn, Rm, Da, Db, ALU_out, Mem_out, reg1, reg2);

	input logic clk;
	input logic [4:0] Rd, Rn, Rm;
	input logic [63:0] Da, Db, ALU_out, Mem_out;
	output logic [63:0] reg1, reg2;
	
	logic [4:0] Rd_1cyc, Rd_2cyc, RnXNORRd1cyc_sel, RnXNORRd2cyc_sel, RmXNORRd1cyc_sel, RmXNORRd2cyc_sel;
	logic [1:0] reg1_sel, reg2_sel;
	logic reg1_sel_temp0, reg1_sel_temp1, reg2_sel_temp0, reg2_sel_temp1;
	logic [3:0][63:0] reg1_mux_in, reg2_mux_in;
	
	genvar i;
	generate
	for (i = 0; i < 5; i++) begin: shift
		D_FF dff1 (.q(Rd_1cyc[i]), .d(Rd[i]), .reset(1'b0), .clk);
		D_FF dff2 (.q(Rd_2cyc[i]), .d(Rd_1cyc[i]), .reset(1'b0), .clk);
		xnor #0.05 XNOR0 (RnXNORRd1cyc_sel[i], Rn[i], Rd_1cyc[i]); // timing
		xnor #0.05 XNOR1 (RnXNORRd2cyc_sel[i], Rn[i], Rd_2cyc[i]);
		xnor #0.05 XNOR2 (RmXNORRd1cyc_sel[i], Rm[i], Rd_1cyc[i]);	
		xnor #0.05 XNOR3 (RmXNORRd2cyc_sel[i], Rm[i], Rd_2cyc[i]);
		end
	endgenerate
	
//	xor #0.05 XNOR0 (RnXNORRd1cyc_sel[0], Rn[0], Rd_1cyc[0]);
//	
//	xor #0.05 XNOR1 (RnXNORRd2cyc_sel[0], Rn[0], Rd_2cyc[0]);
//	
//	xor #0.05 XNOR2 (RmXNORRd1cyc_sel[0], Rm[0], Rd_1cyc[0]);
//	
//	xor #0.05 XNOR3 (RmXNORRd2cyc_sel[0], Rm[0], Rd_2cyc[0]);	
	
	// At most 4 gate inputs
	// reg1_sel
	and #0.05 AND0 (reg1_sel_temp0, RnXNORRd1cyc_sel[0], RnXNORRd1cyc_sel[1], RnXNORRd1cyc_sel[2], RnXNORRd1cyc_sel[3]);
	and #0.05 AND1 (reg1_sel[0], reg1_sel_temp0, RnXNORRd1cyc_sel[4]);
	and #0.05 AND2 (reg1_sel_temp1, RnXNORRd2cyc_sel[0], RnXNORRd2cyc_sel[1], RnXNORRd2cyc_sel[2], RnXNORRd2cyc_sel[3]);
	and #0.05 AND3 (reg1_sel[1], reg1_sel_temp1, RnXNORRd2cyc_sel[4]);
	
	// reg2_sel
	and #0.05 AND4 (reg2_sel_temp0, RmXNORRd1cyc_sel[0], RmXNORRd1cyc_sel[1], RmXNORRd1cyc_sel[2], RmXNORRd1cyc_sel[3]);
	and #0.05 AND5 (reg2_sel[0], reg2_sel_temp0, RmXNORRd1cyc_sel[4]);
	and #0.05 AND6 (reg2_sel_temp1, RmXNORRd2cyc_sel[0], RmXNORRd2cyc_sel[1], RmXNORRd2cyc_sel[2], RmXNORRd2cyc_sel[3]);
	and #0.05 AND7 (reg2_sel[1], reg2_sel_temp1, RmXNORRd2cyc_sel[4]);
	
	assign reg1_mux_in[0] = Da;
	assign reg1_mux_in[1] = ALU_out;
	assign reg1_mux_in[2] = Mem_out;
	assign reg1_mux_in[3] = 5'b0;
	
	assign reg2_mux_in[0] = Db;
	assign reg2_mux_in[1] = ALU_out;
	assign reg2_mux_in[2] = Mem_out;
	assign reg2_mux_in[3] = 5'b0;
	
	mux4_1 #(.WIDTH(64)) reg1_mux (reg1_mux_in, reg1_sel, reg1);
	mux4_1 #(.WIDTH(64)) reg2_mux (reg2_mux_in, reg2_sel, reg2);

endmodule


module forwarding_unit_testbench ();
	logic clk;
	logic [4:0] Rd, Rn, Rm;
	logic [63:0] Da, Db, ALU_out, Mem_out;
	logic [63:0] reg1, reg2;
	
	parameter ClockDelay = 100;

	initial begin // Set up the clock
		clk <= 0;
		forever #(ClockDelay/2) clk <= ~clk;
	end

	forwarding_unit dut (.*);
	
	initial begin
		Rd <= 5'd2; Rn <= 5'd1; Rm <= 5'd0; Da <= 64'd8; Db <= 64'd16; ALU_out <= 64'd32; Mem_out <= 64'd64; @(posedge clk);
		assert(reg1 == Da && reg2 == Db); 
		Rd <= 5'd3; Rn <= 5'd2; Rm <= 5'd0; Da <= 64'd12; Db <= 64'd16; ALU_out <= 64'd24; Mem_out <= 64'd64; @(posedge clk);
		assert(reg1 == ALU_out && reg2 == Db); 
		Rd <= 5'd4; Rn <= 5'd3; Rm <= 5'd2; Da <= 64'd10; Db <= 64'd24; ALU_out <= 64'd20; Mem_out <= 64'd24; @(posedge clk);
		assert(reg1 == ALU_out && reg2 == Mem_out); 
		Rd <= 5'd5; Rn <= 5'd3; Rm <= 5'd4; Da <= 64'd10; Db <= 64'd28; ALU_out <= 64'd34; Mem_out <= 64'd100; @(posedge clk);
		assert(reg1 == Mem_out && reg2 == ALU_out); 
		Rd <= 5'd6; Rn <= 5'd6; Rm <= 5'd5; Da <= 64'd64; Db <= 64'd0; ALU_out <= 64'd38; Mem_out <= 64'd100; @(posedge clk);
		assert(reg1 == Da && reg2 == ALU_out); 
		Rd <= 5'd7; Rn <= 5'd3; Rm <= 5'd4; Da <= 64'd28; Db <= 64'd38; ALU_out <= 64'd64; Mem_out <= 64'd100; @(posedge clk);
		assert(reg1 == Da && reg2 == Db); 
		$stop;		
	end
	
endmodule
