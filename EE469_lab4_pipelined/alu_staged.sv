module alu_staged   (clk,
                     reg1, reg2, ALU_op, flag_wr_en, //Used Signals
                     PCPlusFour_in, Aw_in, MemToReg_in, RegWrite_in, MemWrite_in, Rd_X30_in, //Passthru Sig inputs
                     PCPlusFour_out, Aw_out, MemToReg_out, RegWrite_out, MemWrite_out, Rd_X30_out //Passthru Sig outs
                     ALU_out, alu_neg, alu_zero, alu_overf, alu_cOut, //ALU outputs
                     flag_neg, flag_zero, flag_overf, flag_cOut); //Flag register outputs

    input logic clk, flag_wr_en;
    input logic [63:0] reg1, reg2, PCPlusFour_in;
    input logic [4:0] Aw_in;
    input logic [2:0] ALU_op;
    input logic MemToReg_in, RegWrite_in, MemWrite_in, Rd_X30_in;

    output logic [63:0] ALU_out, PCPlusFour_out;
    output logic [4:0] Aw_out;
    output logic MemToReg_out, RegWrite_out, MemWrite_out, Rd_X30_out;
    
    //