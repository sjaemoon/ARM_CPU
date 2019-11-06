onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /processorstim/clk
add wave -noupdate /processorstim/reset
add wave -noupdate /processorstim/dut/instr/instruction
add wave -noupdate -group {Register Inputs} /processorstim/dut/dp/Rd
add wave -noupdate -group {Register Inputs} /processorstim/dut/dp/Rm
add wave -noupdate -group {Register Inputs} /processorstim/dut/dp/Rn
add wave -noupdate -group {Register Inputs} /processorstim/dut/dp/X30
add wave -noupdate -group {Datapath Inputs} /processorstim/dut/dp/PCPlusFour
add wave -noupdate -group {Datapath Inputs} /processorstim/dut/dp/DAddr9
add wave -noupdate -group {Datapath Inputs} /processorstim/dut/dp/ALUImm12
add wave -noupdate -group {Control Signals} /processorstim/dut/ctrl/opcode
add wave -noupdate -group {Control Signals} /processorstim/dut/ctrl/Reg2Loc
add wave -noupdate -group {Control Signals} /processorstim/dut/ctrl/ALUSrc
add wave -noupdate -group {Control Signals} /processorstim/dut/ctrl/MemToReg
add wave -noupdate -group {Control Signals} /processorstim/dut/ctrl/RegWrite
add wave -noupdate -group {Control Signals} /processorstim/dut/ctrl/MemWrite
add wave -noupdate -group {Control Signals} /processorstim/dut/ctrl/BrTaken
add wave -noupdate -group {Control Signals} /processorstim/dut/ctrl/UncondBr
add wave -noupdate -group {Control Signals} /processorstim/dut/ctrl/ALUOp
add wave -noupdate -group {Control Signals} /processorstim/dut/ctrl/flag_wr_en
add wave -noupdate -group {Control Signals} /processorstim/dut/ctrl/Rd_X30
add wave -noupdate -group {Control Signals} /processorstim/dut/ctrl/pc_rd
add wave -noupdate -group {ALU Signals} /processorstim/dut/dp/aluop_alu/A
add wave -noupdate -group {ALU Signals} /processorstim/dut/dp/aluop_alu/B
add wave -noupdate -group {ALU Signals} /processorstim/dut/dp/aluop_alu/cntrl
add wave -noupdate -group {ALU Signals} /processorstim/dut/dp/aluop_alu/result
add wave -noupdate -group {Flag Registers} /processorstim/dut/flag_reg/negative_o
add wave -noupdate -group {Flag Registers} /processorstim/dut/flag_reg/zero_o
add wave -noupdate -group {Flag Registers} /processorstim/dut/flag_reg/overflow_o
add wave -noupdate -group {Flag Registers} /processorstim/dut/flag_reg/carry_out_o
add wave -noupdate -group Registers -radix hexadecimal -radixshowbase 0 {/processorstim/dut/dp/rf/regOut[0]}
add wave -noupdate -group Registers -radix hexadecimal -radixshowbase 0 {/processorstim/dut/dp/rf/regOut[1]}
add wave -noupdate -group Registers -radix hexadecimal -radixshowbase 0 {/processorstim/dut/dp/rf/regOut[2]}
add wave -noupdate -group Registers -radix hexadecimal -radixshowbase 0 {/processorstim/dut/dp/rf/regOut[3]}
add wave -noupdate -group Registers -radix hexadecimal -radixshowbase 0 {/processorstim/dut/dp/rf/regOut[4]}
add wave -noupdate -group Registers -radix hexadecimal -radixshowbase 0 {/processorstim/dut/dp/rf/regOut[5]}
add wave -noupdate -group Registers -radix hexadecimal -radixshowbase 0 {/processorstim/dut/dp/rf/regOut[6]}
add wave -noupdate -group Registers -radix hexadecimal -radixshowbase 0 {/processorstim/dut/dp/rf/regOut[7]}
add wave -noupdate -group Registers -radix hexadecimal -radixshowbase 0 {/processorstim/dut/dp/rf/regOut[8]}
add wave -noupdate -group Registers -radix hexadecimal -radixshowbase 0 {/processorstim/dut/dp/rf/regOut[9]}
add wave -noupdate -group Registers -radix hexadecimal -radixshowbase 0 {/processorstim/dut/dp/rf/regOut[10]}
add wave -noupdate -group Registers -radix hexadecimal -radixshowbase 0 {/processorstim/dut/dp/rf/regOut[11]}
add wave -noupdate -group Registers -radix hexadecimal -radixshowbase 0 {/processorstim/dut/dp/rf/regOut[12]}
add wave -noupdate -group Registers -radix hexadecimal -radixshowbase 0 {/processorstim/dut/dp/rf/regOut[13]}
add wave -noupdate -group Registers -radix hexadecimal -radixshowbase 0 {/processorstim/dut/dp/rf/regOut[14]}
add wave -noupdate -group Registers -radix hexadecimal -radixshowbase 0 {/processorstim/dut/dp/rf/regOut[15]}
add wave -noupdate -group Registers -radix hexadecimal -radixshowbase 0 {/processorstim/dut/dp/rf/regOut[16]}
add wave -noupdate -group Registers -radix hexadecimal -radixshowbase 0 {/processorstim/dut/dp/rf/regOut[17]}
add wave -noupdate -group Registers -radix hexadecimal -radixshowbase 0 {/processorstim/dut/dp/rf/regOut[18]}
add wave -noupdate -group Registers -radix hexadecimal -radixshowbase 0 {/processorstim/dut/dp/rf/regOut[19]}
add wave -noupdate -group Registers -radix hexadecimal -radixshowbase 0 {/processorstim/dut/dp/rf/regOut[20]}
add wave -noupdate -group Registers -radix hexadecimal -radixshowbase 0 {/processorstim/dut/dp/rf/regOut[21]}
add wave -noupdate -group Registers -radix hexadecimal -radixshowbase 0 {/processorstim/dut/dp/rf/regOut[22]}
add wave -noupdate -group Registers -radix hexadecimal -radixshowbase 0 {/processorstim/dut/dp/rf/regOut[23]}
add wave -noupdate -group Registers -radix hexadecimal -radixshowbase 0 {/processorstim/dut/dp/rf/regOut[24]}
add wave -noupdate -group Registers -radix hexadecimal -radixshowbase 0 {/processorstim/dut/dp/rf/regOut[25]}
add wave -noupdate -group Registers -radix hexadecimal -radixshowbase 0 {/processorstim/dut/dp/rf/regOut[26]}
add wave -noupdate -group Registers -radix hexadecimal -radixshowbase 0 {/processorstim/dut/dp/rf/regOut[27]}
add wave -noupdate -group Registers -radix hexadecimal -radixshowbase 0 {/processorstim/dut/dp/rf/regOut[28]}
add wave -noupdate -group Registers -radix hexadecimal -radixshowbase 0 {/processorstim/dut/dp/rf/regOut[29]}
add wave -noupdate -group Registers -radix hexadecimal -radixshowbase 0 {/processorstim/dut/dp/rf/regOut[30]}
add wave -noupdate -group Registers -radix hexadecimal -radixshowbase 0 {/processorstim/dut/dp/rf/regOut[31]}
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {407910 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 200
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {18434540 ps}
