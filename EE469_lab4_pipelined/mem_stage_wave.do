onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group Inputs /mem_staged_stim/clk
add wave -noupdate -expand -group Inputs -radix decimal /mem_staged_stim/ALU_in
add wave -noupdate -expand -group Inputs -radix decimal /mem_staged_stim/PCPlusFour_in
add wave -noupdate -expand -group Inputs -radix decimal /mem_staged_stim/reg2mem_in
add wave -noupdate -expand -group Inputs -radix unsigned /mem_staged_stim/Aw_in
add wave -noupdate -expand -group Inputs /mem_staged_stim/MemToReg
add wave -noupdate -expand -group Inputs /mem_staged_stim/MemWrite
add wave -noupdate -expand -group Inputs /mem_staged_stim/RegWrite_in
add wave -noupdate -expand -group Inputs /mem_staged_stim/Rd_X30_in
add wave -noupdate -expand -group Outputs -radix decimal /mem_staged_stim/mem_stage_out
add wave -noupdate -expand -group Outputs -radix decimal /mem_staged_stim/PCPlusFour_out
add wave -noupdate -expand -group Outputs -radix unsigned /mem_staged_stim/Aw_out
add wave -noupdate -expand -group Outputs /mem_staged_stim/RegWrite_out
add wave -noupdate -expand -group Outputs /mem_staged_stim/Rd_X30_out
add wave -noupdate -expand -group Internals -radix decimal /mem_staged_stim/dut/memory/read_data
add wave -noupdate -expand -group Internals -radix decimal /mem_staged_stim/dut/memory/address
add wave -noupdate -expand -group Internals -radix decimal /mem_staged_stim/dut/memory/write_data
add wave -noupdate -expand -group Internals /mem_staged_stim/dut/memory/write_enable
add wave -noupdate -expand -group Internals /mem_staged_stim/dut/memory/read_enable
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {41050 ps} 0}
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
WaveRestoreZoom {0 ps} {892500 ps}
