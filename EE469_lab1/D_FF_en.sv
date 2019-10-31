`timescale 1ns/10ps
module D_FF_en (clk, reset, enable, in, out);
    input   logic   clk, reset, enable, in;
    output  logic  out;
	
	logic ff_in;
	logic [1:0] mux_in;
	
	assign mux_in[1] = in;
	
	mux2_1 #(.WIDTH(1)) muxIn (.in(mux_in), .sel(enable), .out(ff_in));
	D_FF ff (.q(mux_in[0]), .d(ff_in), .reset(reset), .clk(clk));
	
	assign out = mux_in[0];
	//buf #0.05 out_buffer (out, ff_in[0]);
endmodule

module D_FF_en_testbench();

	logic clk, reset, enable, in, out;
	
	D_FF_en dut (.clk, .reset, .enable, .in, .out);
	
	parameter CLOCK_PERIOD = 100;
    initial begin
        clk <= 0;
        forever #(CLOCK_PERIOD/2) clk <= ~clk;
    end
	
	initial begin
		reset <= 0;
		in <= 0; enable <= 0;			@(posedge clk);
		reset <= 1;						@(posedge clk);
										@(posedge clk);
		reset <= 0;						@(posedge clk);
		in <= 1;						@(posedge clk);
										@(posedge clk);
										@(posedge clk);
		enable <= 1;					@(posedge clk);
										@(posedge clk);
										@(posedge clk);
		$stop;
	end
endmodule