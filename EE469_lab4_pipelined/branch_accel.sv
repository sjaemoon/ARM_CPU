module branch_accel(clk, opcode, flag_wr_en, BrTaken, UncondBr, pc_rd, regVal_in
                    flag_neg, flag_zero, flag_overf, flag_cOut
                    alu_neg, alu_zero, alu_overf, alu_cOut);
    //Store flag_wr_en in a register, effectively figuring if previous instruction sets flags
    //or not. Read flags from ALU if register is 1, read from flags register otherwise.
    
    input logic clk, flag_wr_en;
    input logic flag_neg, flag_zero, flag_overf, flag_cOut, alu_neg, alu_zero, alu_overf, alu_cOut);
    input logic [10:0] opcode;

    //regVal_in needed for CBZ
    //Internal zero module to check if reg value is zero.
    input logic [63:0] regVal_in;

    output logic BrTaken, UncondBr, pc_rd;

    logic setFlag_reg;
    logic neg_in, zero_in1, zero_in2, overf_in, cOut_in, neg_o, zer_o1, zero_o2, overf_o, cOut_o;
    logic zero_internal;

    assign neg_in = {alu_neg, flag_neg};
    assign zero_in1 = {alu_zero, flag_zero};
    assign zero_in2 = {zero_internal, zero_o1};
    assign overf_in = {alu_overf, flag_overf};
    assign cOut_in = {alu_cOut, flag_cOut};

    register #(.WIDTH(1)) setFlag_register (.in(flag_wr_en), .enable(1'b1), .clk, .out(setFlag_reg));

    mux2_1 #(.WIDTH(1)) flags_neg (.in(neg_in), .sel(setFlag_reg), .out(neg_o));
    mux2_1 #(.WIDTH(1)) flags_zero (.in(zero_in1), .sel(setFlag_reg), .out(zero_o1));
    mux2_1 #(.WIDTH(1)) flags_overf (.in(overf_in), .sel(setFlag_reg), .out(overf_o));
    mux2_1 #(.WIDTH(1)) flags_cOut (.in(cOut_in), .sel(setFlag_reg), .out(cOut_o));
    mux2_1 #(.WIDTH(1)) flags_zero2 (.in(zero_in2), .sel(CBZ?), .out(zero_o2));

    always_comb begin
        casex (opcode)
        // B - 0x05 (6bit)
        11'b000101xxxxx: begin
                            BrTaken = 1;
                            UncondBr = 1;
                            pc_rd = 0;
                         end

        // B.LT - 0x54 (8bit)
        11'b01010100xxx: begin
                            BrTaken = (flag_neg && (flag_neg != flag_overf)); //logic for B.LT
                            UncondBr = 0;
                            pc_rd = 0;
                         end

        