`timescale 1ns/10ps
module program_counter (clk, reset, pc_ext, CondAddr19, BrAddr26, BrTaken, UncondBr,  pc_out);

	input logic	clk, reset, BrTaken, UncondBr, pc_rd;
	input logic [18:0] CondAddr19;
	input logic [25:0] BrAddr26;
	input logic [63:0] pc_ext;
	output logic [63:0] pc_out;

	logic [63:0] pc_out_internal, non_br, br, shifted_addr, pcrd_mux, 
				 uncondbr_mux, brtaken_mux, pc_in_internal;
	logic [1:0][63:0] brtaken_mux_sig, uncondbr_mux_sig, pcrd_mux_sig;

	//Register for the counter itself
	genvar i;

    generate
        for(i=0; i < 64; i++) begin : eachDFF
            D_FF dff_n (.q(pc_out_internal[i]), .d(pcrd_mux[i]), .clk, .reset);
        end
    endgenerate

	
	n_bit_adder non_bradder (.A(pc_out_internal), .B(3'b100), .result(non_br));
	n_bit_adder bradder (.A(shifted_addr), .B(pc_out_internal), .result(br));

	//sign extenders for Addr19 and 26
	sign_extend #(.WIDTH(19)) se19 (.in(CondAddr19), .out(uncondbr_mux_sig[0]));
	sign_extend #(.WIDTH(26)) se26 (.in(BrAddr26), .out(uncondbr_mux_sig[1]));

	//shift_left.sv for shifter module
	shift_left #(.WIDTH(2)) shift_left2 (.in(uncond_mux), .out(shifted_addr));
	
	//Instantiate Muxes
	mux2_1 #(.WIDTH(64)) uncond_mux (.in(uncondbr_mux_sig), .sel(UncondBr), .out(uncondbr_mux));
	mux2_1 #(.WIDTH(64)) pc_mux (.in(pcrd_mux_sig), .sel(pc_rd), .out(pcrd_mux));
	mux2_1 #(.WIDTH(64)) br_mux (.in(brtaken_mux_sig), .sel(BrTaken), .out(brtaken_mux));

	assign pcrd_mux_sig[1] = pc_ext;
	assign pcrd_mux_sig[0] = brtaken_mux;
	assign pc_out = pc_out_internal;
endmodule


module program_counter_textbench();
	logic	clk, reset, BrTaken, UncondBr, pc_rd;
	logic [18:0] CondAddr19;
	logic [25:0] BrAddr26;
	logic [63:0] pc_ext;
	logic [63:0] pc_out;

	program_counter dut (.*);

	parameter CLOCK_PERIOD = 100;
    initial begin
        clk <= 0;
        forever #(CLOCK_PERIOD/2) clk <= ~clk;
    end

	int i;

	initial begin
		reset <= 1;
		BrTaken <= 0; UncondBr <= 0;
		pc_rd <= 0; CondAddr19 <= 0;
		BrAddr26 <= 0; pc_ext <= 'd45826; 	@(posedge clk);

		reset <= 0; @(posedge clk);

		for(i = 0; i < 64; i++) begin
			@(posedge clk);
		end

		BrAddr26 <= 'd328; 					@(posedge clk);
		UncondBr <= 1; 						@(posedge clk);
		BrTaken <= 1; 						@(posedge clk);

		BrTaken <= 0; 						@(posedge clk);
		UncondBr <= 0; 						@(posedge clk);
		CondAddr19 <= 'd164;	 			@(posedge clk);
		BrTaken <= 1; 						@(posedge clk);
		BrTaken <= 0; 						@(posedge clk);
		pc_rd <= 1; 						@(posedge clk);
		pc_rd <= 0; 						@(posedge clk);

		for(i = 0; i < 32; i++) begin
			@(posedge clk);
		end

		$stop;
	end
endmodule
		
