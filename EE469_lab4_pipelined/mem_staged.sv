`timescale 1ns/10ps

module mem_staged(clk, 
                  MemToReg, MemWrite, ALU_in, reg2mem_in, //Used signals
                  PCPlusFour_in, Aw_in, RegWrite_in, Rd_X30_in, //Passthru Signals in
                  PCPlusFour_out, Aw_out, RegWrite_out, Rd_X30_out, //Passthru Signals out
                  mem_to_forward, mem_stage_out); //Output from MemToReg Mux

    input logic clk;
    input logic [63:0] ALU_in, PCPlusFour_in, reg2mem_in;
    input logic [4:0] Aw_in;
    input logic MemToReg, MemWrite, RegWrite_in, Rd_X30_in;

    output logic [63:0] mem_stage_out, PCPlusFour_out;
    output logic [4:0] Aw_out;
    output logic RegWrite_out, Rd_X30_out;

    logic [63:0] datamem_out, mux_out;
    logic [1:0][63:0] mux_in;

    assign mux_in[1] = datamem_out;
    assign mux_in[0] = ALU_in;
    assign mem_to_forward = mux_out;

    //Memory itself
    datamem memory (.address(ALU_in), .write_enable(MemWrite), .read_enable(MemToReg),
                    .write_data(reg2mem_in), .clk, .xfer_size(4'd8), .read_data(datamem_out));
    
    //MemToReg Mux
    mux2_1 #(.WIDTH(64)) memtoregMux (.in(mux_in), .sel(MemToReg), .out(mux_out));

    //Staged Registers
    register #(.WIDTH(64)) memReg (.in(mux_out), .enable(1'b1), .clk, .out(mem_stage_out));
    register #(.WIDTH(64)) pc4 (.in(PCPlusFour_in), .enable(1'b1), .clk, .out(PCPlusFour_out));
    register #(.WIDTH(5)) Aw_reg (.in(Aw_in), .enable(1'b1), .clk, .out(Aw_out));
    register #(.WIDTH(1)) regwr (.in(RegWrite_in), .enable(1'b1), .clk, .out(RegWrite_out));
    register #(.WIDTH(1)) rd_x30 (.in(Rd_X30_in), .enable(1'b1), .clk, .out(Rd_X30_out));
endmodule

module mem_staged_stim();
    logic clk;
    logic [63:0] ALU_in, PCPlusFour_in, reg2mem_in;
    logic [4:0] Aw_in;
    logic MemToReg, MemWrite, RegWrite_in, Rd_X30_in;

    logic [63:0] mem_stage_out, PCPlusFour_out;
    logic [4:0] Aw_out;
    logic RegWrite_out, Rd_X30_out;

    mem_staged dut (.*);

    parameter CLOCK_DELAY = 100;

    initial begin
        clk <= 0;
        forever #(CLOCK_DELAY/2) clk <= ~clk;
    end

    initial begin
        ALU_in <= 64'd0; PCPlusFour_in <= 0; reg2mem_in <= 64'd25; Aw_in <= 5'd10;
        MemToReg <= 0; MemWrite <= 1; RegWrite_in <= 0; Rd_X30_in <= 1; @(posedge clk);
        ALU_in <= 64'd0; MemToReg <= 1; MemWrite <= 0; @(posedge clk);
        

        ALU_in <= 64'd1; reg2mem_in <= 64'd26; MemWrite <= 1; MemToReg <= 0; @(posedge clk);
        ALU_in <= 64'd1; MemWrite <= 0; MemToReg <= 1;                       @(posedge clk);

        ALU_in <= 64'd2; reg2mem_in <= 64'd27; MemWrite <= 1; MemToReg <= 0; @(posedge clk);
        ALU_in <= 64'd2; MemWrite <= 0; MemToReg <= 1;                       @(posedge clk);

        ALU_in <= 64'd3; reg2mem_in <= 64'd28; MemWrite <= 1; MemToReg <= 0; @(posedge clk);
        ALU_in <= 64'd3; MemWrite <= 0; MemToReg <= 1;                       @(posedge clk);

        ALU_in <= 64'd200; MemToReg <= 0;              @(posedge clk);

        $stop;
    end
endmodule