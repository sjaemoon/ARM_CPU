`timescale 1ns/10ps
module datapath_staged(clk, PCPlusFour, instruction, BrTaken, UncondBr, pc_rd, Reg2);

    input logic clk;
    input logic [63:0] PCPlusFour; //Connect to PC+4IF
    input logic [31:0] instruction; //Break down to reg_dec_staged signals

    output logic BrTaken, UncondBr, pc_rd; //Output to IF stage
    output logic [63:0] Reg2; //Input to IF stage

	logic [10:0] opcode;
	logic [4:0] Rd, Rn, Rm;
	logic [8:0] DAddr9;
	logic [11:0] ALUImm12;
	logic [4:0] X30;

	logic [63:0] PCPlusFour_DEC_EX, PCPlusFour_EX_MEM, PCPlusFour_WB, //PC+4OUT pass through
                 ALU_EX_DEC, ALU_EX_MEM, //Value from ALU to Forwarding unit
                 Mem_MEM_DEC, //Value from Memory to Forwarding unit 
                 MemStage_in, //Value for Writeback from MEM
                 reg1_DEC_EX, //Value of reg1 for EX from DEC
                 reg2_DEC_EX, reg2_EX_MEM; //Values of reg2 for DEC_EX and EX_MEM
                 

    logic [4:0] Aw_DEC_EX, Aw_EX_MEM, Aw_in; //Pass thru logic for Aw

    logic   flag_neg, flag_zero, flag_overf, flag_cOut,
            alu_neg, alu_zero, alu_overf, alu_cOut,

            MemToReg_DEC_EX, MemToReg_EX_MEM,
            RegWrite_DEC_EX, RegWrite_EX_MEM, RegWrite_in,
            MemWrite_DEC_EX, MemWrite_EX_MEM,
            
            flag_wr_en_DEC_EX,

            Rd_X30_DEC_EX, Rd_X30_EX_MEM, Rd_X30_WB;

    logic [2:0] ALU_op_DEC_EX;

    assign opcode = instruction[31:21];
	assign Rd = instruction[4:0];
	assign Rn = instruction[9:5];
	assign Rm = instruction[20:16];
	assign DAddr9  = instruction[20:12];
	assign ALUImm12 = instruction[21:10];
	assign X30 = 5'd30;

    //Register Decode Stage
    reg_dec_staged RegisterStage (.clk, .opcode, .Rd, .Rn, .Rm, .X30,
                                
                                  .DAddr9, .ALUImm12, .PCPlusFour_IF(PCPlusFour), .ALU_out(ALU_EX_DEC), .Mem_out(Mem_MEM_DEC),
                                  
                                  .flag_neg, .flag_zero, .flag_overf, .flag_cOut, .alu_neg, .alu_zero, .alu_overf, .alu_cOut,
                                  
                                  .BrTaken, .UncondBr, .pc_rd, .reg1(reg1_DEC_EX), .reg2(reg2_DEC_EX), .reg2_IF(Reg2), .PCPlusFour_out(PCPlusFour_DEC_EX), .Aw_out(Aw_DEC_EX),
                                  
                                  .MemToReg_out(MemToReg_DEC_EX), .RegWrite_out(RegWrite_DEC_EX), .MemWrite_out(MemWrite_DEC_EX), 
                                  .ALUOp_out(ALU_op_DEC_EX), .flag_wr_en_out(flag_wr_en_DEC_EX), .Rd_X30_out(Rd_X30_DEC_EX), 
                                  
                                  .PCPlusFour_WB, .MemStage_in, .Aw_in, .Rd_X30_WB, .RegWrite_in);

    //ALU Execute Stage
    alu_staged ALUstage (.clk,
    
                         .reg1(reg1_DEC_EX), .reg2(reg2_DEC_EX), .ALU_op(ALU_op_DEC_EX), .flag_wr_en(flag_wr_en_DEC_EX),
                         
                         .PCPlusFour_in(PCPlusFour_DEC_EX), .Aw_in(Aw_DEC_EX), .MemToReg_in(MemToReg_DEC_EX), .RegWrite_in(RegWrite_DEC_EX), .MemWrite_in(MemWrite_DEC_EX), .Rd_X30_in(Rd_X30_DEC_EX),
                         
                         .PCPlusFour_out(PCPlusFour_EX_MEM), .Aw_out(Aw_EX_MEM), .MemToReg_out(MemToReg_EX_MEM), .RegWrite_out(RegWrite_EX_MEM), .MemWrite_out(MemWrite_EX_MEM), .Rd_X30_out(Rd_X30_EX_MEM),
                         
                         .ALU_out(ALU_EX_MEM), .ALU_fw(ALU_EX_DEC), .alu_neg, .alu_zero, .alu_overf, .alu_cOut,
                         .flag_neg, .flag_zero, .flag_overf, .flag_cOut,
                         
                         .reg2mem(reg2_EX_MEM));

    //Memory Stage
    mem_staged MemoryStage (.clk,
    
                            .MemToReg(MemToReg_EX_MEM), .MemWrite(MemWrite_EX_MEM), .ALU_in(ALU_EX_MEM), .reg2mem_in(reg2_EX_MEM),
                            
                            .PCPlusFour_in(PCPlusFour_EX_MEM), .Aw_in(Aw_EX_MEM), .RegWrite_in(RegWrite_EX_MEM), .Rd_X30_in(Rd_X30_EX_MEM),
                            
                            .PCPlusFour_out(PCPlusFour_WB), .Aw_out(Aw_in), .RegWrite_out(RegWrite_in), .Rd_X30_out(Rd_X30_WB),
                            
                            .mem_to_forward(Mem_MEM_DEC), .mem_stage_out(MemStage_in));
endmodule
