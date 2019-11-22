`timescale 1ns/10ps
module program_counter_staged(clk, reset, Reg2, pc_rd, 
                Instr_out, BrTaken, UncondBr, PCPlusFour);

    input logic clk, reset, BrTaken, UncondBr, pc_rd;
    input logic [63:0] Reg2;
    output logic [63:0] PCPlusFour;
    output logic [31:0] Instr_out;

    logic [31:0] Stagereg_in, Stagereg_out; 
    logic [63:0] PC_internal, PC_internal_delayed, shifted_addr, pcrd_mux, 
				 uncondbr_mux, brtaken_mux, pc_in_internal;

    logic [18:0] CondAddr19;
    logic [25:0] BrAddr26;

    logic [1:0][63:0] brtaken_mux_sig, uncondbr_mux_sig, pcrd_mux_sig;

    //Registers for PC
    genvar i;

    generate
        for(i=0; i < 64; i++) begin : eachDFF
            D_FF dff_n (.q(PC_internal[i]), .d(pcrd_mux[i]), .clk, .reset);
        end
    endgenerate

    //register #(.WIDTH(64)) counter (.in(pcrd_mux), .enable(1'b1), .clk, .out(PC_internal));
    register #(.WIDTH(64)) one_cycle_hold (.in(PC_internal), .enable(1'b1), .clk, .out(PC_internal_delayed));

    //Stage register
    register #(.WIDTH(32)) stage_reg (.in(Stagereg_in), .enable(1'b1), .clk, .out(Stagereg_out));

    instructmem instruction_memory (.address(PC_internal), .instruction(Stagereg_in), .clk);

    n_bit_adder non_bradder (.A(PC_internal), .B(64'd4), .result(brtaken_mux_sig[0]));
    n_bit_adder bradder (.A(shifted_addr), .B(PC_internal_delayed), .result(brtaken_mux_sig[1]));

    //Sign extenders for Addr19 and BrAddr26
    sign_extend #(.WIDTH(19)) se19 (.in(CondAddr19), .out(uncondbr_mux_sig[0]));
    sign_extend #(.WIDTH(26)) se26 (.in(BrAddr26), .out(uncondbr_mux_sig[1]));
    
    //Left shift from output of UncondBr mux
    shift_left #(.WIDTH(2)) shift_left2 (.in(uncondbr_mux), .out(shifted_addr));

    //Instantiate muxxes
    mux2_1 #(.WIDTH(64)) uncond_mux (.in(uncondbr_mux_sig), .sel(UncondBr), .out(uncondbr_mux));
    mux2_1 #(.WIDTH(64)) pc_mux (.in(pcrd_mux_sig), .sel(pc_rd), .out(pcrd_mux));
    mux2_1 #(.WIDTH(64)) br_mux (.in(brtaken_mux_sig), .sel(BrTaken), .out(brtaken_mux));

    assign pcrd_mux_sig[0] = brtaken_mux;
    assign pcrd_mux_sig[1] =  Reg2;
    assign CondAddr19 = Stagereg_out[23:5];
    assign BrAddr26 = Stagereg_out[25:0];
    assign Instr_out = Stagereg_out;
    assign PCPlusFour = brtaken_mux_sig[0];
endmodule

module pc_staged_stim();
    logic clk, reset, BrTaken, UncondBr, pc_rd;
    logic [63:0] Reg2, PCPlusFour;
    logic [31:0] Instr_out;

    program_counter_staged dut (.*);

    parameter CLOCK_PERIOD = 100;
    initial begin
        clk <= 0;
        forever #(CLOCK_PERIOD/2) clk <= ~clk;
    end

    initial begin                                                               //Fetched           Evaluated
        reset <= 1; BrTaken <= 0; UncondBr <= 0; pc_rd <= 0;    @(posedge clk);
        reset <= 0;                                             @(posedge clk); //ADDI X0, X31, #1  None
                                                                @(posedge clk); //ADDI x1, X31, #0  ADDI X0
                                                                @(posedge clk); //ADDI X2, X31, #0  ADDI X1
                                                                @(posedge clk); //ADDI X3, X31, #0  ADDI X2
                                                                @(posedge clk); //ADDI X4, X31, #0  ADDI X3
                                                                @(posedge clk); //ADDI X5, X31, #0  ADDI X4
                                                                @(posedge clk); //B FORWARD_B       ADDI X5
                    BrTaken <= 1; UncondBr <= 1; pc_rd <= 0;    @(posedge clk); //ADDI X2, X2, #1   B FORWARD_B
                    BrTaken <= 0; UncondBr <= 0; pc_rd <= 0;    @(posedge clk); //ADDI X4, X4, #1   ADDI X2
    assert (Instr_out == 32'b1001000100_000000000001_00010_00010);
                                                                @(posedge clk); //B BACKWARD_B      ADDI X4
                    BrTaken <= 1; UncondBr <= 1; pc_rd <= 0;    @(posedge clk); //ADDI X2, X2, #1   B BACKWARD_B
                    BrTaken <= 0; UncondBr <= 0; pc_rd <= 0;    @(posedge clk); //ADDI X4, X4, #2   ADDI X2
    assert (Instr_out == 32'b1001000100_000000000001_00010_00010);
                                                                @(posedge clk); //CBZ X31, FW_CBZ   ADDI X4
                    BrTaken <= 1; UncondBr <= 0; pc_rd <= 0;    @(posedge clk); //ADDI X2, X2, #1   CBZ X31
                    BrTaken <= 0; UncondBr <= 0; pc_rd <= 0;    @(posedge clk); //ADDI X4, X4, #4   ADDI X2
    assert (Instr_out == 32'b1001000100_000000000001_00010_00010);
                                                                @(posedge clk); //CBZ X31, BW_CBZ   ADDI X4      
                    BrTaken <= 1; UncondBr <= 0; pc_rd <= 0;    @(posedge clk); //ADDI X2, X2, #1   CBZ X31
                    BrTaken <= 0; UncondBr <= 0; pc_rd <= 0;    @(posedge clk); //ADDI X4, X4, #8   ADDI X2
    assert (Instr_out == 32'b1001000100_000000000001_00010_00010);
                                                                @(posedge clk); //CBZ X0, NT        ADDI X4
                                                                @(posedge clk); //NOOP              CBZ X0;
                                                                @(posedge clk); //ADDI X4, X4, #16  NOOP
    assert (Instr_out == 32'b1001000100_000000000000_11111_11111);
                                                                @(posedge clk); //ADDI X3, X31, #1  ADDI X4
                                                                @(posedge clk); //B HALT            ADDI X3
                    BrTaken <= 1; UncondBr <= 1; pc_rd <= 0;    @(posedge clk); //NOOP              B HALT
                    BrTaken <= 0; UncondBr <= 0; pc_rd <= 0;    @(posedge clk); //B HALT            NOOP
                    BrTaken <= 1; UncondBr <= 1; pc_rd <= 0;    @(posedge clk); //NOOP              B HALT
        $stop;
    end
endmodule
