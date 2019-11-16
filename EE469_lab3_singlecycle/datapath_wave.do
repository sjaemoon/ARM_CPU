onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /datapath_testbench/clk
add wave -noupdate /datapath_testbench/Rd
add wave -noupdate /datapath_testbench/Rm
add wave -noupdate /datapath_testbench/Rn
add wave -noupdate /datapath_testbench/X30
add wave -noupdate /datapath_testbench/PCPlusFour
add wave -noupdate /datapath_testbench/DAddr9
add wave -noupdate /datapath_testbench/ALUImm12
add wave -noupdate /datapath_testbench/Reg2Loc
add wave -noupdate /datapath_testbench/ALUSrc
add wave -noupdate /datapath_testbench/MemToReg
add wave -noupdate /datapath_testbench/RegWrite
add wave -noupdate /datapath_testbench/MemWrite
add wave -noupdate /datapath_testbench/Rd_X30
add wave -noupdate /datapath_testbench/ALUOp
add wave -noupdate /datapath_testbench/flag_neg
add wave -noupdate /datapath_testbench/flag_zero
add wave -noupdate /datapath_testbench/flag_overf
add wave -noupdate /datapath_testbench/flag_cOut
add wave -noupdate /datapath_testbench/Db_ext
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {214400 ps} 0}
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
WaveRestoreZoom {0 ps} {9922500 ps}
