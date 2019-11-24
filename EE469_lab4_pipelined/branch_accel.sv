`timescale 1ns/10ps
module branch_accel(clk, opcode, flag_wr_en, BrTaken, UncondBr, pc_rd, regVal_in,
                    flag_neg, flag_zero, flag_overf, flag_cOut,
                    alu_neg, alu_zero, alu_overf, alu_cOut);
    //Store flag_wr_en in a register, effectively figuring if previous instruction sets flags
    //or not. Read flags from ALU if register is 1, read from flags register otherwise.
    
    input logic clk, flag_wr_en;
    input logic flag_neg, flag_zero, flag_overf, flag_cOut, alu_neg, alu_zero, alu_overf, alu_cOut;
    input logic [10:0] opcode;

    //regVal_in needed for CBZ
    //Internal zero module to check if reg value is zero.
    input logic [63:0] regVal_in;

    output logic BrTaken, UncondBr, pc_rd;

    logic setFlag_reg;
    logic [1:0] neg_in, zero_in, overf_in, cOut_in; 
    logic neg_o, zer_o, overf_o, cOut_o;
    logic zero_internal;

    assign neg_in = {alu_neg, flag_neg};
    assign zero_in = {alu_zero, flag_zero};
    assign overf_in = {alu_overf, flag_overf};
    assign cOut_in = {alu_cOut, flag_cOut};

    register #(.WIDTH(1)) setFlag_register (.in(flag_wr_en), .enable(1'b1), .clk, .out(setFlag_reg));

    mux2_1 #(.WIDTH(1)) flags_neg (.in(neg_in), .sel(setFlag_reg), .out(neg_o));
    mux2_1 #(.WIDTH(1)) flags_zero (.in(zero_in), .sel(setFlag_reg), .out(zero_o));
    mux2_1 #(.WIDTH(1)) flags_overf (.in(overf_in), .sel(setFlag_reg), .out(overf_o));
    mux2_1 #(.WIDTH(1)) flags_cOut (.in(cOut_in), .sel(setFlag_reg), .out(cOut_o));

    zero_flag zero_module (.in(regVal_in), .out(zero_internal));

    always_comb begin
        casex (opcode)

        //Garbage case to filter 11'bxxxxxxxxxxx
        11'b11111111111: begin
                    BrTaken = 0;
                    UncondBr = 0;
                    pc_rd = 0;
                 end

        
        // B - 0x05 (6bit)
        11'b000101xxxxx: begin
                            BrTaken = 1;
                            UncondBr = 1;
                            pc_rd = 0;
                         end

        // B.LT - 0x54 (8bit)
        11'b01010100xxx: begin
                            BrTaken = (neg_o && (neg_o != overf_o)); //logic for B.LT
                            UncondBr = 0;
                            pc_rd = 0;
                         end

        // BL - 0x25 (6bit)
        11'b100101xxxxx: begin
                            BrTaken = 1;
                            UncondBr = 1;
                            pc_rd = 0;
                         end

        // BR - 0x6B0 (11bit)
        11'b11010110000: begin
                            BrTaken = 0;
                            UncondBr = 0;
                            pc_rd = 1;
                         end

        // CBZ - 0xB4 (8bit)
        11'b10110100xxx: begin
                            BrTaken = zero_internal;
                            UncondBr = 0;
                            pc_rd = 0;
                         end

        default: begin
                  BrTaken = 0;
                  UncondBr = 0;
                  pc_rd = 0;
        end
        
        endcase
    end
endmodule

module accel_stim();
   
   logic clk, flag_wr_en;
   logic flag_neg, flag_zero, flag_overf, flag_cOut, alu_neg, alu_zero, alu_overf, alu_cOut;
   logic [10:0] opcode;
   logic [63:0] regVal_in;
   logic BrTaken, UncondBr, pc_rd;

   branch_accel dut (.*);

   parameter CLOCK_PERIOD = 100;

   initial begin
      clk <= 0;
      forever #(CLOCK_PERIOD/2) clk <= ~clk;
   end

   initial begin
      flag_neg <= 0; flag_zero <= 0; flag_overf <= 0; flag_cOut <= 0; 
      alu_neg <= 0; alu_zero <= 0; alu_overf <= 0; alu_cOut <= 0;

      regVal_in <= 64'd100;

      @(posedge clk);

      // B instr
      opcode <= 11'b00010100000;
      flag_wr_en <= 0; @(posedge clk);

      // ADDI instr
      opcode <= 11'b1001000100x;
      flag_wr_en <= 0; @(posedge clk);

      // SUBS instr
      opcode <= 11'b11101011000;
      flag_wr_en = 1; @(posedge clk);

      // Flags from ALU executing SUBS
      alu_neg <= 1; //rest are 0s

      // B.LT instr 
      opcode <= 11'b01010100xxx;
      flag_wr_en = 0; @(posedge clk);

      assert (UncondBr == 0 && BrTaken == 1 && pc_rd == 0);

      // Flags from ALU moves to FlagReg
      alu_neg <= 0;
      flag_neg <= 1; flag_zero <= 0; flag_overf <= 0; flag_cOut <= 0;

      // ADD instr
      opcode <= 11'b1001000100x;
      @(posedge clk);

      // LDUR inst
      opcode <= 11'b11111000010;
      @(posedge clk);

      // ADDS instr
      opcode <= 11'b10101011000;
      flag_wr_en = 1; @(posedge clk);

      // Flags from ALU executing ADDS
      alu_cOut <= 1; //rest are 0s

      // ADDI instr
      opcode <= 11'b1001000100x;
      flag_wr_en = 0; @(posedge clk);

      // Flags from ALU moves to FlagReg
      alu_cOut <= 0;
      flag_neg <= 0; flag_zero <= 0; flag_overf <= 0; flag_cOut <= 1;

      // B.LT instr
      opcode <= 11'b01010100xxx;
      flag_wr_en = 0; @(posedge clk);

      assert (UncondBr == 0 && BrTaken == 0 && pc_rd == 0);

      // CBZ instr
      opcode <= 11'b10110100xxx;
      @(posedge clk);

      assert (UncondBr == 0 && BrTaken == 0 && pc_rd == 0);

      // CBZ instr
      regVal_in <= 64'd0;
      opcode <= 11'b10110100xxx;
      @(posedge clk);
      
      assert (UncondBr == 0 && BrTaken == 1 && pc_rd == 0);

      // BR instr
      opcode <= 11'b11010110000;
      @(posedge clk);

      assert (pc_rd == 1);

      opcode <= 11'b00010100000;
      flag_wr_en <= 0; @(posedge clk);

      $stop;
   end
endmodule
