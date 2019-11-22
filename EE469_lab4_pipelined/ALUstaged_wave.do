onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /ALU_staged_stim/clk
add wave -noupdate -expand -group Inputs /ALU_staged_stim/flag_wr_en
add wave -noupdate -expand -group Inputs -radix decimal /ALU_staged_stim/reg1
add wave -noupdate -expand -group Inputs -radix decimal /ALU_staged_stim/reg2
add wave -noupdate -expand -group Inputs -radix unsigned /ALU_staged_stim/PCPlusFour_in
add wave -noupdate -expand -group Inputs -radix unsigned /ALU_staged_stim/Aw_in
add wave -noupdate -expand -group Inputs /ALU_staged_stim/ALU_op
add wave -noupdate -expand -group Inputs /ALU_staged_stim/MemToReg_in
add wave -noupdate -expand -group Inputs /ALU_staged_stim/RegWrite_in
add wave -noupdate -expand -group Inputs /ALU_staged_stim/MemWrite_in
add wave -noupdate -expand -group Inputs /ALU_staged_stim/Rd_X30_in
add wave -noupdate -expand -group Outputs -radix decimal /ALU_staged_stim/ALU_out
add wave -noupdate -expand -group Outputs -radix decimal /ALU_staged_stim/ALU_fw
add wave -noupdate -expand -group Outputs -radix unsigned /ALU_staged_stim/PCPlusFour_out
add wave -noupdate -expand -group Outputs -radix unsigned /ALU_staged_stim/Aw_out
add wave -noupdate -expand -group Outputs /ALU_staged_stim/MemToReg_out
add wave -noupdate -expand -group Outputs /ALU_staged_stim/RegWrite_out
add wave -noupdate -expand -group Outputs /ALU_staged_stim/MemWrite_out
add wave -noupdate -expand -group Outputs /ALU_staged_stim/Rd_X30_out
add wave -noupdate -expand -group Outputs /ALU_staged_stim/alu_neg
add wave -noupdate -expand -group Outputs /ALU_staged_stim/alu_zero
add wave -noupdate -expand -group Outputs /ALU_staged_stim/alu_overf
add wave -noupdate -expand -group Outputs /ALU_staged_stim/alu_cOut
add wave -noupdate -expand -group Outputs /ALU_staged_stim/flag_neg
add wave -noupdate -expand -group Outputs /ALU_staged_stim/flag_zero
add wave -noupdate -expand -group Outputs /ALU_staged_stim/flag_overf
add wave -noupdate -expand -group Outputs /ALU_staged_stim/flag_cOut
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {167880 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
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
WaveRestoreZoom {0 ps} {262500 ps}
