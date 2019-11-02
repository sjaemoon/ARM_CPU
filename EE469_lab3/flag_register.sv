module flag_register    (clk, wr_en, negative, zero, overflow, carry_out, 
                         negative_o, zero_o, overflow_o, carry_out_o);

    input   logic clk, wr_en, negative, zero, overflow, carry_out;
    output  logic negative_o, zero_o, overflow_o, carry_out_o;

    D_FF_en neg_ff (.clk, .reset(1'b0), .enable(wr_en), .in(negative), .out(negative_o));
    D_FF_en zero_ff (.clk, .reset(1'b0), .enable(wr_en), .in(zero), .out(zero_o));
    D_FF_en over_ff (.clk, .reset(1'b0), .enable(wr_en), .in(overflow), .out(overflow_o));
    D_FF_en carry_ff (.clk, .reset(1'b0), .enable(wr_en), .in(carry_out), .out(carry_out_o));
endmodule

module flag_register_testbench();

    logic clk, reset, wr_en, negative, zero, overflow, carry_out, 
          negative_o, zero_o, overflow_o, carry_out_o;

    flag_register dut (.*);

    parameter CLOCK_PERIOD = 100;
    initial begin
        clk <= 0;
        forever #(CLOCK_PERIOD/2) clk <= ~clk;
    end
	
	initial begin
        reset <= 1;             @(posedge clk);
        reset <= 0;             @(posedge clk);
        wr_en <= 1; negative <= 1;
        zero <= 1; overflow <= 1;
        carry_out <= 1;         @(posedge clk);
                                @(posedge clk);
        reset <= 0;             @(posedge clk);
    
        $stop;
    end
endmodule