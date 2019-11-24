`timescale 1ns/10ps
module alu_staged   (clk,
                     reg1, reg2, ALU_op, flag_wr_en, //Used Signals
                     PCPlusFour_in, Aw_in, MemToReg_in, RegWrite_in, MemWrite_in, Rd_X30_in, Dbmem_in, //Passthru Sig inputs
                     PCPlusFour_out, Aw_out, MemToReg_out, RegWrite_out, MemWrite_out, Rd_X30_out, Dbmem_out, //Passthru Sig outs
                     ALU_out, ALU_fw, alu_neg, alu_zero, alu_overf, alu_cOut, //ALU outputs
                     flag_neg, flag_zero, flag_overf, flag_cOut); //Flag register outputs


    input logic clk, flag_wr_en;
    input logic [63:0] reg1, reg2, PCPlusFour_in, Dbmem_in;
    input logic [4:0] Aw_in;
    input logic [2:0] ALU_op;
    input logic MemToReg_in, RegWrite_in, MemWrite_in, Rd_X30_in;

    output logic [63:0] ALU_out, ALU_fw, PCPlusFour_out, Dbmem_out;
    output logic [4:0] Aw_out;
    output logic MemToReg_out, RegWrite_out, MemWrite_out, Rd_X30_out;
    output logic alu_neg, alu_zero, alu_overf, alu_cOut,
                 flag_neg, flag_zero, flag_overf, flag_cOut;


    logic neg, zero, overf, cOut;
    logic [63:0] ALU_internal;
    
    alu ALU_unit (.A(reg1), .B(reg2), .cntrl(ALU_op), .result(ALU_internal),
                  .negative(neg), .zero(zero), .overflow(overf), .carry_out(cOut));

    flag_register flagreg (.clk, .wr_en(flag_wr_en),
                           .negative(neg), .zero(zero), .overflow(overf), .carry_out(cOut),
                           .negative_o(flag_neg), .zero_o(flag_zero), .overflow_o(flag_overf), .carry_out_o(flag_cOut));

    //Assign ALU Output to External Output
    assign alu_neg = neg;
    assign alu_zero = zero;
    assign alu_overf = overf;
    assign alu_cOut = cOut;
    assign ALU_fw = ALU_internal; //Output signal to forwarding Unit

    //Stage Registers
    register #(.WIDTH(64)) ALUout (.in(ALU_internal), .enable(1'b1), .clk, .out(ALU_out));
    register #(.WIDTH(64)) pcplusfour_reg (.in(PCPlusFour_in), .enable(1'b1), .clk, .out(PCPlusFour_out));
    register #(.WIDTH(64)) db_mem (.in(Dbmem_in), .enable(1'b1), .clk, .out(Dbmem_out));
    register #(.WIDTH(5)) Aw_reg (.in(Aw_in), .enable(1'b1), .clk, .out(Aw_out));
    register #(.WIDTH(1)) MemtoReg (.in(MemToReg_in), .enable(1'b1), .clk, .out(MemToReg_out));
    register #(.WIDTH(1)) RegWr (.in(RegWrite_in), .enable(1'b1), .clk, .out(RegWrite_out));
    register #(.WIDTH(1)) MemWr (.in(MemWrite_in), .enable(1'b1), .clk, .out(MemWrite_out));
    register #(.WIDTH(1)) Rd_X30 (.in(Rd_X30_in), .enable(1'b1), .clk, .out(Rd_X30_out));
endmodule

module ALU_staged_stim();
    logic clk, flag_wr_en;
    logic [63:0] reg1, reg2, PCPlusFour_in;
    logic [4:0] Aw_in;
    logic [2:0] ALU_op;
    logic MemToReg_in, RegWrite_in, MemWrite_in, Rd_X30_in;

    logic [63:0] ALU_out, ALU_fw, PCPlusFour_out, reg2mem;
    logic [4:0] Aw_out;
    logic MemToReg_out, RegWrite_out, MemWrite_out, Rd_X30_out;
    logic alu_neg, alu_zero, alu_overf, alu_cOut,
                 flag_neg, flag_zero, flag_overf, flag_cOut;

    alu_staged dut (.*);

    parameter CLOCK_DELAY = 100;

    initial begin
        clk <= 0;
        forever #(CLOCK_DELAY/2) clk <= ~clk;
    end

    initial begin
        flag_wr_en <= 0; reg1 <= 0; reg2 <= 0; PCPlusFour_in <= 0;
        Aw_in <= 0; ALU_op <= 0; MemToReg_in <= 0; RegWrite_in <= 0; MemWrite_in <= 0; Rd_X30_in <= 0; @(posedge clk);

        //ADDS Instr
        flag_wr_en <= 1; reg1 <= 64'd10; reg2 <= 64'd20; PCPlusFour_in <= 64'd128;
        Aw_in <= 5'd5; ALU_op <= 3'b010; MemToReg_in <= 0; RegWrite_in <= 1; MemWrite_in <= 0; Rd_X30_in <= 0; @(posedge clk); //ADDS Executed
        

        //ADDI Instr
        flag_wr_en <= 0; reg1 <= 64'd20; reg2 <= 64'd1; PCPlusFour_in <= 64'd132;
        Aw_in <= 5'd6; ALU_op <= 3'b010; MemToReg_in <= 0; RegWrite_in <= 1; MemWrite_in <= 0; Rd_X30_in <= 0; @(posedge clk);
        assert(ALU_out == 64'd30 && Aw_out == 5'd5 && PCPlusFour_out == 64'd128);
        
        $stop;
    end
endmodule
        

        

