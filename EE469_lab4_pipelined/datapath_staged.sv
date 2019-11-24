module datapath_staged();

    input logic clk, reset;
    input logic [63:0] PCPlusFour;
    input logic [31:0] Instr_in;