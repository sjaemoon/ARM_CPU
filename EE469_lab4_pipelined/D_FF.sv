module D_FF (clk, reset, d, q);
    input   clk, reset, d;
	 output  reg q;
    
    always_ff @(posedge clk) begin
        if (reset)
            q <= 0; // On reset, set to 0
        else
            q <= d; // else set to input
    end
endmodule