onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group Inputs /accel_stim/clk
add wave -noupdate -expand -group Inputs /accel_stim/flag_wr_en
add wave -noupdate -expand -group Inputs /accel_stim/flag_neg
add wave -noupdate -expand -group Inputs /accel_stim/flag_zero
add wave -noupdate -expand -group Inputs /accel_stim/flag_overf
add wave -noupdate -expand -group Inputs /accel_stim/flag_cOut
add wave -noupdate -expand -group Inputs /accel_stim/alu_neg
add wave -noupdate -expand -group Inputs /accel_stim/alu_zero
add wave -noupdate -expand -group Inputs /accel_stim/alu_overf
add wave -noupdate -expand -group Inputs /accel_stim/alu_cOut
add wave -noupdate -expand -group Inputs /accel_stim/opcode
add wave -noupdate -expand -group Inputs -radix decimal /accel_stim/regVal_in
add wave -noupdate -expand -group Outputs /accel_stim/BrTaken
add wave -noupdate -expand -group Outputs /accel_stim/UncondBr
add wave -noupdate -expand -group Outputs /accel_stim/pc_rd
add wave -noupdate -expand -group Internals /accel_stim/dut/setFlag_reg
add wave -noupdate -expand -group Internals /accel_stim/dut/zero_internal
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
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
WaveRestoreZoom {11499050 ps} {11503128 ps}
