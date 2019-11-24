module processor_pipelined(clk, reset);
    
    input logic clk, reset;

    logic [63:0] PCPlusFour, Reg2;
    logic [31:0] instruction;

    logic BrTaken, UncondBr, pc_rd;

    //Program Counter (IF Stage)
    program_counter_staged PC (.clk, .reset, .Reg2, .pc_rd,
                               .Instr_out(instruction), .BrTaken, .UncondBr, .pc_rd, .PCPlusFour);

    //Datapath (DEC, EX, MEM, WB stage)
    datapath_staged datapath (.clk, .PCPlusFour, .instruction, .BrTaken, .UncondBr, .pc_rd, .Reg2);
endmodule